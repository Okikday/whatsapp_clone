import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:basic_utils/basic_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:pointycastle/asymmetric/api.dart';
import 'package:pointycastle/key_generators/rsa_key_generator.dart';
import 'package:pointycastle/random/fortuna_random.dart';
import 'package:pointycastle/pointycastle.dart' as pointy;

class AsymmetricKeysModel {
  final RSAPublicKey? publicKey;
  final RSAPrivateKey? privateKey;

  AsymmetricKeysModel({this.publicKey, this.privateKey});

  /// Creates an instance from a Map.
  factory AsymmetricKeysModel.fromMap(Map<String, dynamic> map) {
    return AsymmetricKeysModel(
      publicKey: map['publicKey'] != null ? CryptoUtils.rsaPublicKeyFromPem(map['publicKey'] as String) : null,
      privateKey: map['privateKey'] != null ? CryptoUtils.rsaPrivateKeyFromPem(map['privateKey'] as String) : null,
    );
  }

  /// Converts this instance into a Map.
  Map<String, dynamic> toMap() {
    return {
      'publicKey': publicKey != null ? CryptoUtils.encodeRSAPublicKeyToPem(publicKey!) : null,
      'privateKey': privateKey != null ? CryptoUtils.encodeRSAPrivateKeyToPem(privateKey!) : null,
    };
  }

  /// Converts this instance to a JSON string.
  String toJson() => json.encode(toMap());

  /// Creates an instance from a JSON string.
  factory AsymmetricKeysModel.fromJson(String source) => AsymmetricKeysModel.fromMap(json.decode(source));

  /// Returns a copy of this instance with the given fields replaced with new values.
  AsymmetricKeysModel copyWith({
    RSAPublicKey? publicKey,
    RSAPrivateKey? privateKey,
  }) {
    return AsymmetricKeysModel(
      publicKey: publicKey ?? this.publicKey,
      privateKey: privateKey ?? this.privateKey,
    );
  }
}


/// Model for encrypting data that requires a recipient's public key.
class ToEncryptModel {
  /// Data to encrypt.
  final String data;

  /// Other person's public key.
  final RSAPublicKey publicKey;

  ToEncryptModel({
    required this.data,
    required this.publicKey,
  });

  /// Creates a new instance with values from a Map.
  factory ToEncryptModel.fromMap(Map<String, dynamic> map) {
    return ToEncryptModel(
      data: map['data'] as String,
      // Convert stored PEM string back to RSAPublicKey.
      publicKey: CryptoUtils.rsaPublicKeyFromPem(map['publicKey'] as String),
    );
  }

  /// Converts this model to a Map.
  Map<String, dynamic> toMap() {
    return {
      'data': data,
      // Convert RSAPublicKey to PEM string for storage.
      'publicKey': CryptoUtils.encodeRSAPublicKeyToPem(publicKey),
      'type': "to_encrypt",
    };
  }

  /// Creates a copy of this model with optional new values.
  ToEncryptModel copyWith({
    String? data,
    RSAPublicKey? publicKey,
  }) {
    return ToEncryptModel(
      data: data ?? this.data,
      publicKey: publicKey ?? this.publicKey,
    );
  }

  /// Creates a new instance from a JSON string.
  factory ToEncryptModel.fromJson(String source) => ToEncryptModel.fromMap(json.decode(source));

  /// Converts this model to a JSON string.
  String toJson() => json.encode(toMap());
}

/// Model for decrypting data that requires the recipient's private key.
class ToDecryptModel {
  /// Encrypted data to decrypt.
  final String data;

  /// The recipient's private key.
  final RSAPrivateKey privateKey;

  ToDecryptModel({
    required this.data,
    required this.privateKey,
  });

  /// Creates a new instance from a Map.
  factory ToDecryptModel.fromMap(Map<String, dynamic> map) {
    return ToDecryptModel(
      data: map['data'] as String,
      // Convert stored PEM string back to RSAPrivateKey.
      privateKey: CryptoUtils.rsaPrivateKeyFromPem(map['privateKey'] as String),
    );
  }

  /// Converts this model to a Map.
  Map<String, dynamic> toMap() {
    return {
      'data': data,
      // Convert RSAPrivateKey to PEM string for storage.
      'privateKey': CryptoUtils.encodeRSAPrivateKeyToPem(privateKey),
      'type': "to_decrypt",
    };
  }

  /// Creates a copy of this model with optional new values.
  ToDecryptModel copyWith({
    String? data,
    RSAPrivateKey? privateKey,
  }) {
    return ToDecryptModel(
      data: data ?? this.data,
      privateKey: privateKey ?? this.privateKey,
    );
  }

  /// Creates a new instance from a JSON string.
  factory ToDecryptModel.fromJson(String source) => ToDecryptModel.fromMap(json.decode(source));

  /// Converts this model to a JSON string.
  String toJson() => json.encode(toMap());
}