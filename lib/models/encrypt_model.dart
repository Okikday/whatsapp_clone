import 'dart:convert';

class EncryptModel<T> {
  /// The encrypted content. This might be a String (for text data) or a List<int> (for binary data).
  final T content;

  /// The IV used during encryption (stored as a Base64 string).
  final String iv;

  final EncryptContentType contentType;

  /// (Optional) You could add additional fields here, for example, encryption algorithm, keyId, etc.
  // final String algorithm;

  EncryptModel({
    required this.content,
    required this.iv,
    required this.contentType,
    // this.algorithm = 'AES/CBC/PKCS7', // Example default value
  });

  /// Convert the model to a Map.
  Map<String, dynamic> toMap() {
    return {
      'content': content,
      'iv': iv,
      'contentType': contentType.index
      // 'algorithm': algorithm,
    };
  }

  /// Create a model instance from a Map.
  factory EncryptModel.fromMap(Map<String, dynamic> map) {
    return EncryptModel(
      content: map['content'],
      iv: map['iv'] as String,
      contentType: EncryptContentType.values[map['contentType'] as int],
      // algorithm: map['algorithm'] ?? 'AES/CBC/PKCS7',
    );
  }

  /// Convert the model to a JSON string.
  String toJson() => json.encode(toMap());

  /// Create a model instance from a JSON string.
  factory EncryptModel.fromJson(String source) => EncryptModel.fromMap(json.decode(source));

  EncryptModel<T> copyWith({
    T? content,
    String? iv,
    EncryptContentType? contentType,
  }) {
    return EncryptModel(
      content: content ?? this.content,
      iv: iv ?? this.iv,
      contentType: contentType ?? this.contentType,
    );
  }
}

enum EncryptContentType { text, map, file, hybrid } // tmfh

extension EncryptContentTypeExtension on EncryptContentType {
  int get value => EncryptContentType.values.indexOf(this);
}


