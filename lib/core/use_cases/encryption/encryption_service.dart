import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:crypto/crypto.dart';
import 'package:basic_utils/basic_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:whatsapp_clone/common/utilities/utilities.dart';
import 'package:whatsapp_clone/core/use_cases/encryption/asymmetric_encryption.dart';
import 'package:whatsapp_clone/data/app_data.dart';
import 'package:whatsapp_clone/data/hive_data/hive_data.dart';
import 'package:whatsapp_clone/data/user_data/user_data.dart';
import 'package:whatsapp_clone/models/asymmetric_encrypt_model.dart';

class EncryptionService {
  static final EncryptionService _instance = EncryptionService._internal();
  factory EncryptionService() => _instance;
  EncryptionService._internal() {
    _initialize();
  }
  static EncryptionService get instance => _instance;

  AsymmetricKeysModel? _currAsymmetricKeysModel;
  bool isInit = false;
  String? _myId;
  static const FlutterSecureStorage _flutterSecureStorage = FlutterSecureStorage();
  static final HiveData _hiveData = HiveData();
  StreamSubscription<DocumentSnapshot>? _firebasePublicKeySub;
  static const String _aesEncPath = "encryptionPath/asymmetricEncryption/";

  // Instead of a getter, we add an async method to wait for the public key.
  Future<RSAPublicKey?> getPublicKeyAsync() async {
    // Wait until initialization is complete.
    while (!isInit || _currAsymmetricKeysModel == null) {
      await Future.delayed(const Duration(milliseconds: 50));
    }
    return _currAsymmetricKeysModel!.publicKey;
  }

  // Synchronous getter (might be null if not yet initialized)
  RSAPublicKey? get publicKey => _currAsymmetricKeysModel?.publicKey;

  late DocumentReference _fbPublicKeyDocRef;

  // Called in the private constructor.
  void _initialize() {
    try {
      _myId = AppData.userId;
      if (_myId == null || _myId!.isEmpty) {
        log("EncryptionService: No userId found in AppData");
      }
      _fbPublicKeyDocRef = FirebaseFirestore.instance.collection("public_info").doc(_myId);
      // Initialize keys first, then start listening.
      _initKeys().then((result) {
        if (result.isSuccess) {
          isInit = true;
          _listenToPublicKeyInFirebase();
        } else {
          log("EncryptionService: Failed to initialize keys: ${result.error}");
        }
      });
    } catch (e) {
      log("EncryptionService: Initialization failed: $e");
    }
  }

  /// Listens for changes in the public key document.
  void _listenToPublicKeyInFirebase() {
    _firebasePublicKeySub = _fbPublicKeyDocRef.snapshots().listen(
      (rawData) async {
        try {
          // Process only if initialization is complete.
          if (!isInit) return;
          if (!rawData.exists || rawData.data() == null) {
            await _updateFirebasePublicKey();
            return;
          }
          final Map<String, dynamic> dataMap = rawData.data() as Map<String, dynamic>;
          if (!dataMap.containsKey('publicKey')) {
            await _updateFirebasePublicKey();
            return;
          }
          final String rawPublicKey = dataMap['publicKey'] as String;
          // If our current key is missing or differs, update Firebase.
          if (_currAsymmetricKeysModel == null ||
              _currAsymmetricKeysModel!.publicKey == null ||
              _currAsymmetricKeysModel!.publicKey != CryptoUtils.rsaPublicKeyFromPem(rawPublicKey)) {
            await _updateFirebasePublicKey();
          }
        } catch (e) {
          log("listenToPublicKeyInFirebase error: $e");
        }
      },
      onError: (error) {
        log("listenToPublicKeyInFirebase stream error: $error");
      },
    );
    log("EncryptionService: Started listening to public key updates.");
  }

  /// Initializes keys. Reads encryption details from secure storage.
  /// If details are missing or outdated, generates new keys.
  Future<Result<bool>> _initKeys() async {
    try {
      if (AppData.userId == null || AppData.userId!.isEmpty) {
        bool loaded = await tryLoadMyId();
        if (!loaded) {
          return Result.error("Unable to get userId... @EncryptionService => initKeys");
        }
      }
      log("EncryptionService: Inside _initKeys");
      _myId = AppData.userId;
      _fbPublicKeyDocRef = FirebaseFirestore.instance.collection("public_info").doc(_myId);

      final Map<int, String>? encDetails = await _getAesEncDetails();
      if (encDetails == null) {
        // No stored details: generate new keys.
        AsymmetricKeysModel newAsymmetricKeysModel = AsymmetricEncryption.generateAsymmetricKeys();
        final String newLastUpdated = DateTime.now().toIso8601String();
        final String extractPublicKey = CryptoUtils.encodeRSAPublicKeyToPem(newAsymmetricKeysModel.publicKey!);
        bool stored = await _setAesEncDetails(newLastUpdated, newAsymmetricKeysModel.toJson(), extractPublicKey);
        if (!stored) return Result.error("Unable to store encryption details");
        _currAsymmetricKeysModel = newAsymmetricKeysModel;
      } else {
        final DateTime lastUpdatedDT = DateTime.parse(encDetails[1]!);
        final AsymmetricKeysModel storedKeys = AsymmetricKeysModel.fromJson(encDetails[2]!);
        if (_isToday(lastUpdatedDT)) {
          _currAsymmetricKeysModel = storedKeys;
        } else {
          // Outdated: generate new keys.
          AsymmetricKeysModel newAsymmetricKeysModel = AsymmetricEncryption.generateAsymmetricKeys();
          final String newLastUpdated = DateTime.now().toIso8601String();
          final String extractPublicKey = CryptoUtils.encodeRSAPublicKeyToPem(newAsymmetricKeysModel.publicKey!);
          bool stored = await _setAesEncDetails(newLastUpdated, newAsymmetricKeysModel.toJson(), extractPublicKey);
          if (!stored) return Result.error("Unable to store encryption details");
          _currAsymmetricKeysModel = newAsymmetricKeysModel;
        }
      }
      // Update Firebase with our public key.
      bool updateSuccess = await _updateFirebasePublicKey();
      if (!updateSuccess) {
        return Result.unavailable("Unable to update firebase key. Try connecting...");
      }
      return Result.success(true);
    } catch (e) {
      log("EncryptionService _initKeys error: $e");
      return Result.error("EncryptionService _initKeys exception: $e");
    }
  }

  /// Updates the Firebase document with the current public key.
  Future<bool> _updateFirebasePublicKey() async {
    try {
      if (_currAsymmetricKeysModel == null) {
        log("_updateFirebasePublicKey: Keys are not yet initialized, skipping update.");
        return false;
      }
      final String encodedPublicKey = CryptoUtils.encodeRSAPublicKeyToPem(_currAsymmetricKeysModel!.publicKey!);
      await _fbPublicKeyDocRef.set({
        'publicKey': encodedPublicKey,
      }, SetOptions(merge: true));
      return true;
    } catch (e) {
      log("updateFirebasePublicKey error: $e");
      return false;
    }
  }

  /// Retrieves encryption details from secure storage.
  Future<Map<int, String>?> _getAesEncDetails() async {
    try {
      final String? lastUpdated = await _flutterSecureStorage.read(key: "$_aesEncPath/lastUpdated");
      final String? asymmetricKeys = await _flutterSecureStorage.read(key: "$_aesEncPath/asymmetricKeys");
      if (lastUpdated == null || asymmetricKeys == null) return null;
      return {
        1: lastUpdated,
        2: asymmetricKeys,
      };
    } catch (e) {
      log("Error in _getAesEncDetails: $e");
      return null;
    }
  }

  /// Stores encryption details into secure storage and Hive.
  Future<bool> _setAesEncDetails(String newLastUpdated, String jsonAsymmetricKeys, String extractPublicKey) async {
    try {
      final Map<String, dynamic> aesEncHiveMap = {
        'lastUpdated': newLastUpdated,
        'asymmetricKeys': jsonAsymmetricKeys,
      };

      await _flutterSecureStorage.write(key: "$_aesEncPath/lastUpdated", value: newLastUpdated);
      await _flutterSecureStorage.write(key: "$_aesEncPath/asymmetricKeys", value: jsonAsymmetricKeys);
      await _hiveData.setSecureData(key: "$_aesEncPath/${_hashPublicKey(extractPublicKey)}", value: aesEncHiveMap);
      return true;
    } catch (e) {
      log("Error in _setAesEncDetails: $e");
      return false;
    }
  }

  /// Checks if the given date is today.
  static bool _isToday(DateTime date) {
    final now = DateTime.now();
    return now.year == date.year && now.month == date.month && now.day == date.day;
  }

  /// Attempts to load the user ID if missing.
  Future<bool> tryLoadMyId() async {
    try {
      final Result<String> userIdRaw = await UserDataFunctions().getUserId();
      if (!userIdRaw.isSuccess || userIdRaw.value == null || userIdRaw.value!.isEmpty) {
        return false;
      }
      AppData.userId = userIdRaw.value;
      _myId = userIdRaw.value;
      _fbPublicKeyDocRef = FirebaseFirestore.instance.collection("public_info").doc(_myId);
      return true;
    } catch (e) {
      log("Error in tryLoadMyId: $e");
      return false;
    }
  }

  String _hashPublicKey(String publicKey) {
    final bytes = utf8.encode(publicKey);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// Public function to decrypt a symmetric key.
  Future<String?> decryptSymmetricKey(String data, {required String fallbackPublicKey}) async =>
      await _decryptSymmetricKeyFromStorage(fallbackPublicKey, data);

  Future<String?> _decryptSymmetricKeyFromStorage(String publicKeyToFind, String data) async {
    try {
      final rawData = await _hiveData.getSecureData(key: "$_aesEncPath/${_hashPublicKey(publicKeyToFind)}");
      if (rawData == null) return null;
      final Map<String, dynamic> gottenData = Map<String, dynamic>.from(rawData as Map);
      if (gottenData.isEmpty) return null;
      final AsymmetricKeysModel asymmetricKeysModel = AsymmetricKeysModel.fromJson(gottenData['asymmetricKeys']);
      return AsymmetricEncryption.asymmetricDecrypt(ToDecryptModel(data: data, privateKey: asymmetricKeysModel.privateKey!));
    } catch (e) {
      return null;
    }
  }

  /// Dispose function to cancel the Firestore subscription.
  void dispose() {
    _firebasePublicKeySub?.cancel();
  }
}
