import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter/foundation.dart';
import 'package:pointycastle/asymmetric/api.dart';
import 'package:pointycastle/key_generators/rsa_key_generator.dart';
import 'package:pointycastle/random/fortuna_random.dart';
import 'package:pointycastle/pointycastle.dart' as pointy;

class EncryptionLogic {
  // Singleton pattern
  static final EncryptionLogic _instance = EncryptionLogic._internal();
  factory EncryptionLogic() => _instance;
  EncryptionLogic._internal();

  // Keys for symmetric encryption
  late encrypt.Key _key;
  late encrypt.IV _iv;
  late encrypt.Encrypter _encrypter;

  // Keys for asymmetric encryption
  RSAPublicKey? _publicKey;
  RSAPrivateKey? _privateKey;

  Future<RSAPublicKey?> generateAndGetPublicKey({int bitLength = 2048}) async {
    await generateAsymmetricKeys(bitLength: bitLength);
    return _publicKey;
  }




  /// Initialize symmetric encryption with a password.
  /// Pads/truncates the password to 32 characters for AES-256.
  void initSymmetric(String password) {
    final keyString = password.padRight(32, '0').substring(0, 32);
    _key = encrypt.Key.fromUtf8(keyString);

    _iv = encrypt.IV.fromSecureRandom(16);

    _encrypter = encrypt.Encrypter(
      encrypt.AES(_key, mode: encrypt.AESMode.cbc),
    );
  }

  // /// Initialize symmetric encryption with specific key and IV in Base64 format.
  // void initSymmetricWithKeyIV(String keyBase64, String ivBase64) {
  //   _key = encrypt.Key.fromBase64(keyBase64);
  //   _iv = encrypt.IV.fromBase64(ivBase64);
  //   _encrypter = encrypt.Encrypter(
  //     encrypt.AES(_key, mode: encrypt.AESMode.cbc),
  //   );
  // }

  /// Generate a secure random key and IV for symmetric encryption.
  Map<String, String> generateSymmetricKeyIV() {
    final secureRandom = _getSecureRandom();
    // Generate a list of 32 random bytes and convert to Uint8List.
    final keyBytes = Uint8List.fromList(secureRandom.nextBytes(32));
    // Generate a list of 16 random bytes and convert to Uint8List.
    final ivBytes = Uint8List.fromList(secureRandom.nextBytes(16));

    final key = encrypt.Key(keyBytes);
    final iv = encrypt.IV(ivBytes);

    return {
      'key': key.base64,
      'iv': iv.base64,
    };
  }

  /// Generate an RSA key pair asynchronously.
  Future<void> generateAsymmetricKeys({int bitLength = 2048}) async {
    final secureRandom = _getSecureRandom();
    final keyGen = RSAKeyGenerator()
      ..init(
        pointy.ParametersWithRandom(
          pointy.RSAKeyGeneratorParameters(
            BigInt.parse('65537'), // public exponent
            bitLength,             // bit length
            64,                    // certainty
          ),
          secureRandom,
        ),
      );

    final pair = keyGen.generateKeyPair();
    _publicKey = pair.publicKey as RSAPublicKey;
    _privateKey = pair.privateKey as RSAPrivateKey;
  }

  /// Initialize asymmetric encryption with existing keys.
  void initAsymmetricWithKeys(RSAPublicKey publicKey, RSAPrivateKey? privateKey) {
    _publicKey = publicKey;
    _privateKey = privateKey;
  }



  //
  // SYMMETRIC ENCRYPTION METHODS
  //

  /// Encrypt a string using symmetric encryption.
  String encryptString(String plainText) {
    final encrypted = _encrypter.encrypt(plainText, iv: _iv);
    return encrypted.base64;
  }

  /// Decrypt a string using symmetric encryption.
  String decryptString(String encryptedText) {
    final encrypted = encrypt.Encrypted.fromBase64(encryptedText);
    return _encrypter.decrypt(encrypted, iv: _iv);
  }

  /// Encrypt a Map by first encoding it to JSON, then encrypting.
  String encryptMap(Map<String, dynamic> map) {
    final jsonString = jsonEncode(map);
    return encryptString(jsonString);
  }

  /// Decrypt an encrypted Map.
  Map<String, dynamic> decryptMap(String encryptedText) {
    final jsonString = decryptString(encryptedText);
    return jsonDecode(jsonString) as Map<String, dynamic>;
  }

  /// Encrypt a file using symmetric encryption.
  Future<File> encryptFile(File file) async {
    // Read file as bytes
    final bytes = await file.readAsBytes();

    // Encrypt bytes
    final encrypted = _encrypter.encryptBytes(bytes, iv: _iv);

    // Save encrypted data to a new file
    final encryptedFile = File('${file.path}.enc');
    await encryptedFile.writeAsBytes(encrypted.bytes);

    return encryptedFile;
  }

  /// Decrypt a file using symmetric encryption.
  Future<File> decryptFile(File encryptedFile, [String? outputPath]) async {
    // Read encrypted file as bytes
    final bytes = await encryptedFile.readAsBytes();

    // Decrypt bytes
    final encrypted = encrypt.Encrypted(bytes);
    final decryptedBytes = _encrypter.decryptBytes(encrypted, iv: _iv);

    // Determine output path with proper grouping of the conditional expression
    final String filePath = outputPath ??
        (encryptedFile.path.endsWith('.enc')
            ? encryptedFile.path.substring(0, encryptedFile.path.length - 4)
            : '${encryptedFile.path}.dec');

    // Save decrypted data to a new file
    final decryptedFile = File(filePath);
    await decryptedFile.writeAsBytes(decryptedBytes);

    return decryptedFile;
  }

  //
  // ASYMMETRIC ENCRYPTION METHODS
  //

  /// Encrypt a string using asymmetric encryption with the public key.
  String asymmetricEncrypt(String plainText) {
    if (_publicKey == null) {
      throw Exception(
          "Public key not initialized. Call generateAsymmetricKeys or initAsymmetricWithKeys first.");
    }

    final encrypter = encrypt.Encrypter(encrypt.RSA(publicKey: _publicKey));
    final encrypted = encrypter.encrypt(plainText);
    return encrypted.base64;
  }

  /// Decrypt a string using asymmetric encryption with the private key.
  String asymmetricDecrypt(String encryptedText) {
    if (_privateKey == null) {
      throw Exception(
          "Private key not initialized. Call generateAsymmetricKeys or initAsymmetricWithKeys first.");
    }

    final encrypter = encrypt.Encrypter(encrypt.RSA(privateKey: _privateKey));
    final encrypted = encrypt.Encrypted.fromBase64(encryptedText);

    try {
      return encrypter.decrypt(encrypted);
    } catch (e) {
      throw Exception("Failed to decrypt: $e");
    }
  }

  //
  // HYBRID ENCRYPTION METHODS
  //

  /// Hybrid encryption (symmetric + asymmetric) for large data.
  /// Encrypts data with a random symmetric key, then encrypts that key with the public key.
  Map<String, String> hybridEncrypt(String data) {
    if (_publicKey == null) {
      throw Exception("Public key not initialized");
    }

    final secureRandom = _getSecureRandom();
    final keyBytes = Uint8List.fromList(secureRandom.nextBytes(32));
    final ivBytes = Uint8List.fromList(secureRandom.nextBytes(16));

    final symKey = encrypt.Key(keyBytes);
    final iv = encrypt.IV(ivBytes);

    // Encrypt data with symmetric key
    final symEncrypter = encrypt.Encrypter(
      encrypt.AES(symKey, mode: encrypt.AESMode.cbc),
    );
    final encryptedData = symEncrypter.encrypt(data, iv: iv);

    // Encrypt the symmetric key with the public key
    final rsaEncrypter = encrypt.Encrypter(encrypt.RSA(publicKey: _publicKey));
    final encryptedKey = rsaEncrypter.encrypt(symKey.base64);
    final encryptedIV = rsaEncrypter.encrypt(iv.base64);

    return {
      'data': encryptedData.base64,
      'key': encryptedKey.base64,
      'iv': encryptedIV.base64,
    };
  }

  /// Hybrid decryption (symmetric + asymmetric) for large data.
  /// Decrypts the symmetric key with the private key, then uses it to decrypt the data.
  String hybridDecrypt(Map<String, String> encryptedPackage) {
    if (_privateKey == null) {
      throw Exception("Private key not initialized");
    }

    // Decrypt the symmetric key and IV using the private key
    final rsaEncrypter =
    encrypt.Encrypter(encrypt.RSA(privateKey: _privateKey));
    final encryptedKey =
    encrypt.Encrypted.fromBase64(encryptedPackage['key']!);
    final encryptedIV =
    encrypt.Encrypted.fromBase64(encryptedPackage['iv']!);

    final symKeyBase64 = rsaEncrypter.decrypt(encryptedKey);
    final ivBase64 = rsaEncrypter.decrypt(encryptedIV);

    final symKey = encrypt.Key.fromBase64(symKeyBase64);
    final iv = encrypt.IV.fromBase64(ivBase64);

    // Decrypt data with the symmetric key
    final symEncrypter = encrypt.Encrypter(
      encrypt.AES(symKey, mode: encrypt.AESMode.cbc),
    );
    final encryptedData =
    encrypt.Encrypted.fromBase64(encryptedPackage['data']!);

    return symEncrypter.decrypt(encryptedData, iv: iv);
  }

  /// Creates a secure random generator using FortunaRandom.
  pointy.SecureRandom _getSecureRandom() {
    final secureRandom = FortunaRandom();
    final seedSource = Random.secure();
    final seeds = <int>[];
    for (var i = 0; i < 32; i++) {
      seeds.add(seedSource.nextInt(256)); // 256 allows values 0-255
    }
    secureRandom.seed(pointy.KeyParameter(Uint8List.fromList(seeds)));
    return secureRandom;
  }
}
