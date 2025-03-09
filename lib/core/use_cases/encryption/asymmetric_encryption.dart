
import 'dart:math';
import 'dart:typed_data';

import 'package:basic_utils/basic_utils.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter/foundation.dart';
import 'package:pointycastle/asymmetric/api.dart';
import 'package:pointycastle/key_generators/rsa_key_generator.dart';
import 'package:pointycastle/random/fortuna_random.dart';
import 'package:pointycastle/pointycastle.dart' as pointy;
import 'package:whatsapp_clone/models/asymmetric_encrypt_model.dart';

class AsymmetricEncryption {

  static AsymmetricKeysModel generateAsymmetricKeys({int bitLength = 2048}) {
    final secureRandom = _getSecureRandom();
    final keyGen = RSAKeyGenerator()
      ..init(
        pointy.ParametersWithRandom(
          pointy.RSAKeyGeneratorParameters(
            BigInt.parse('65537'), // public exponent
            bitLength, // bit length
            64, // certainty
          ),
          secureRandom,
        ),
      );
    final pair = keyGen.generateKeyPair();

    return AsymmetricKeysModel(
        publicKey: pair.publicKey as RSAPublicKey,
        privateKey: pair.privateKey as RSAPrivateKey
    );
  }


  /// Encrypt a string using asymmetric encryption with the public key.
  static String asymmetricEncrypt(ToEncryptModel toEncryptModel) {
    final encrypted = encrypt.Encrypter(encrypt.RSA(publicKey: toEncryptModel.publicKey)).encrypt(toEncryptModel.data);
    return encrypted.base64;
  }

  /// Decrypt a string using asymmetric encryption with the private key.
  static String asymmetricDecrypt(ToDecryptModel toDecryptModel) {
    final encrypter = encrypt.Encrypter(encrypt.RSA(privateKey: toDecryptModel.privateKey));
    final encrypted = encrypt.Encrypted.fromBase64(toDecryptModel.data);
    try {
      return encrypter.decrypt(encrypted);
    } catch (e) {
      throw Exception("Failed to decrypt: $e");
    }
  }

  /// Hybrid encryption (symmetric + asymmetric) for large data.
  /// Encrypts data with a random symmetric key, then encrypts that key with the public key.
  Map<String, String> hybridEncrypt(String data, RSAPublicKey publicKey) {
    final secureRandom = _getSecureRandom();
    final keyBytes = Uint8List.fromList(secureRandom.nextBytes(32));
    final ivBytes = Uint8List.fromList(secureRandom.nextBytes(16));

    final symKey = encrypt.Key(keyBytes);
    final iv = encrypt.IV(ivBytes);

    final encryptedData = encrypt.Encrypter(
      encrypt.AES(symKey, mode: encrypt.AESMode.cbc),
    ).encrypt(data, iv: iv);

    // Encrypt the symmetric key with the public key
    final rsaEncrypter = encrypt.Encrypter(encrypt.RSA(publicKey: publicKey));
    final encryptedKey = rsaEncrypter.encrypt(symKey.base64);
    final encryptedIV = rsaEncrypter.encrypt(iv.base64);

    return {
      'data': encryptedData.base64,
      'key': encryptedKey.base64,
      'iv': encryptedIV.base64,
      'type': "hybrid"
    };
  }

  /// Hybrid decryption (symmetric + asymmetric) for large data.
  /// Decrypts the symmetric key with the private key, then uses it to decrypt the data.
  String? hybridDecrypt(Map<String, String> encryptedPackage, RSAPrivateKey privateKey) {
    if(encryptedPackage['type'] != "hybrid") return null;
    // Decrypt the symmetric key and IV using the private key
    final rsaEncrypter = encrypt.Encrypter(encrypt.RSA(privateKey: privateKey));
    final encryptedKey = encrypt.Encrypted.fromBase64(encryptedPackage['key']!);
    final encryptedIV = encrypt.Encrypted.fromBase64(encryptedPackage['iv']!);

    final symKeyBase64 = rsaEncrypter.decrypt(encryptedKey);
    final ivBase64 = rsaEncrypter.decrypt(encryptedIV);

    final symKey = encrypt.Key.fromBase64(symKeyBase64);
    final iv = encrypt.IV.fromBase64(ivBase64);

    // Decrypt data with the symmetric key
    final symEncrypter = encrypt.Encrypter(
      encrypt.AES(symKey, mode: encrypt.AESMode.cbc),
    );
    final encryptedData = encrypt.Encrypted.fromBase64(encryptedPackage['data']!);

    return symEncrypter.decrypt(encryptedData, iv: iv);
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
