import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:developer' as dev;

import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter/foundation.dart';
import 'package:pointycastle/asymmetric/api.dart';
import 'package:pointycastle/key_generators/rsa_key_generator.dart';
import 'package:pointycastle/random/fortuna_random.dart';
import 'package:pointycastle/pointycastle.dart' as pointy;
import 'package:whatsapp_clone/common/utilities/utilities.dart';
import 'package:whatsapp_clone/models/encrypt_model.dart';

class EncryptionLogic {
  // Singleton pattern
  static final EncryptionLogic _instance = EncryptionLogic._internal();
  factory EncryptionLogic() => _instance;
  EncryptionLogic._internal();

  // Keys for symmetric encryption
  late encrypt.Key _key;
  late encrypt.Encrypter _encrypter;


  /// Initialize symmetric encryption with a password.
  /// Pads/truncates the password to 32 characters for AES-256.
  void initSymmetric(String password) {
    final keyString = password.padRight(32, '0').substring(0, 32);
    _key = encrypt.Key.fromUtf8(keyString);

    _encrypter = encrypt.Encrypter(
      encrypt.AES(_key, mode: encrypt.AESMode.cbc),
    );
  }


  //
  // SYMMETRIC ENCRYPTION METHODS
  //

  /// Encrypt a string using symmetric encryption.
  EncryptModel encryptString(String plainText) {
    final encrypt.IV iv = encrypt.IV.fromSecureRandom(16);
    final encrypted = _encrypter.encrypt(plainText, iv: iv);
    return EncryptModel(content: encrypted.base64, iv: iv.base64, contentType: EncryptContentType.text);
  }

  /// Decrypt a string using symmetric encryption.
  Result<String> decryptString(EncryptModel encryptModel) {
    try {
      final encrypted = encrypt.Encrypted.fromBase64(encryptModel.content);
      final iv = encrypt.IV.fromBase64(encryptModel.iv);
      return Result.success(_encrypter.decrypt(encrypted, iv: iv));
    } catch (e) {
      dev.log("error decrypting String: $e");
    }
    if (encryptModel.contentType != EncryptContentType.text) return Result.error("Unable to decrypt non-String");
    return Result.error("Unable to decrypt -String");
  }

  /// Encrypt a Map by first encoding it to JSON, then encrypting.
  EncryptModel encryptMap(Map<String, dynamic> map) {
    final jsonString = jsonEncode(map);
    return encryptString(jsonString).copyWith(contentType: EncryptContentType.map);
  }

  /// Decrypt an encrypted Map.
  Result<Map<String, dynamic>> decryptMap(EncryptModel encryptModel) {
    try {
      final resultJsonString = decryptString(encryptModel.copyWith(contentType: EncryptContentType.text));
      if (resultJsonString.isSuccess) {
        return Result.success(Map<String, dynamic>.from(jsonDecode(resultJsonString.value!) as Map));
      }
    } catch (e) {
      dev.log("error: $e");
    }
    if (encryptModel.contentType != EncryptContentType.map) return Result.error("Type to decrypt is not type Map");
    return Result.error("Type to decrypt is not type Map");
  }

  /// Encrypt a file using symmetric encryption.
  Future<EncryptModel> encryptFile(File file) async {
    final encrypt.IV iv = encrypt.IV.fromSecureRandom(16);
    // Read file as bytes
    final bytes = await file.readAsBytes();

    // Encrypt bytes
    final encrypted = _encrypter.encryptBytes(bytes, iv: iv);

    // Save encrypted data to a new file
    final encryptedFile = File('${file.path}.enc');
    await encryptedFile.writeAsBytes(encrypted.bytes);

    return EncryptModel(content: encryptedFile, iv: iv.base64, contentType: EncryptContentType.file);
  }

  /// Decrypt a file using symmetric encryption.
  Future<Result<File>> decryptFile(EncryptModel encryptedModel, [String? outputPath]) async {
    try {
      final File encryptedFile = encryptedModel.content;
      // Read encrypted file as bytes
      final bytes = await encryptedFile.readAsBytes();

      // Decrypt bytes
      final encrypted = encrypt.Encrypted(bytes);
      final decryptedBytes = _encrypter.decryptBytes(encrypted, iv: encrypt.IV.fromBase64(encryptedModel.iv));

      // Determine output path with proper grouping of the conditional expression
      final String filePath = outputPath ??
          (encryptedFile.path.endsWith('.enc')
              ? encryptedFile.path.substring(0, encryptedFile.path.length - 4)
              : '${encryptedFile.path}.dec');

      // Save decrypted data to a new file
      final decryptedFile = File(filePath);
      await decryptedFile.writeAsBytes(decryptedBytes);

      return Result.success(decryptedFile);
    } catch (e) {
      dev.log("Error decrypting file: ");
      return Result.error(e.toString());
    }
  }


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


