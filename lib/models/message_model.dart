import 'dart:convert';

class MessageModel {
  final int? id; // Auto-incremented ID for SQLite
  final String messageId;
  final String chatId;
  final String myId;
  final Map<String, String>? reactions; //
  final String content; // Default message text; acts as a caption if media exists
  final String? taggedMessageId;
  final String? mediaUrl; // URL or local file reference for the media
  final Map<String, dynamic>? metadata; // Extra details, e.g., file size, duration, etc.
  final MessageType messageType; // Represents media type; 0 means text by default
  final DateTime sentTime;
  final DateTime? sentAt;
  final DateTime? deliveredAt;
  final DateTime? readAt;
  final DateTime? editedAt;
  final bool isStarred; // not needed
  final bool isDeleted;
  final bool isForwarded; // not needed or can be changed to int
  final bool isReported;

  MessageModel({
    this.id,
    required this.messageId,
    required this.chatId,
    required this.myId,
    this.reactions,
    required this.content,
    this.taggedMessageId,
    this.mediaUrl,
    this.metadata,
    required this.messageType,
    required this.sentTime,
    this.sentAt,
    this.deliveredAt,
    this.readAt,
    this.editedAt,
    this.isStarred = false,
    this.isDeleted = false,
    this.isForwarded = false,
    this.isReported = false,
  });

  // Convert MessageModel to a map (for inserting into SQLite)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'messageId': messageId,
      'chatId': chatId,
      'myId': myId,
      'reactions': reactions != null ? json.encode(reactions) : null,
      'content': content,
      'taggedMessageId': taggedMessageId,
      'mediaUrl': mediaUrl,
      'metadata': metadata != null ? json.encode(metadata) : null,
      'messageType': messageType.index, // Store enum as index
      'sentTime': sentTime.toIso8601String(),
      'sentAt': sentAt?.toIso8601String(),
      'deliveredAt': deliveredAt?.toIso8601String(),
      'readAt': readAt?.toIso8601String(),
      'editedAt': editedAt?.toIso8601String(),
      'isStarred': isStarred ? 1 : 0,
      'isDeleted': isDeleted ? 1 : 0,
      'isForwarded': isForwarded ? 1 : 0,
      'isReported': isReported ? 1 : 0,
    };
  }

  /// Create a MessageModel from a map (for reading from SQLite or Firestore)
  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      id: map['id'] as int?,
      messageId: map['messageId'] as String,
      chatId: map['chatId'] as String,
      myId: map['myId'] as String,
      reactions: map['reactions'] != null
          ? (json.decode(map['reactions']) as Map).map((key, value) => MapEntry(key.toString(), value.toString()))
          : null,
      content: map['content'] as String,
      taggedMessageId: map['taggedMessageId'] as String?,
      mediaUrl: map['mediaUrl'] as String?,
      metadata: map['metadata'] != null ? Map<String, dynamic>.from(jsonDecode(map['metadata'])) : null,
      messageType: MessageType.values[map['messageType'] as int], // Convert index back to enum
      sentTime: DateTime.parse(map['sentTime'] as String),
      sentAt: map['sentAt'] != null ? DateTime.parse(map['sentAt'] as String) : null,
      deliveredAt: map['deliveredAt'] != null ? DateTime.parse(map['deliveredAt'] as String) : null,
      readAt: map['readAt'] != null ? DateTime.parse(map['readAt'] as String) : null,
      editedAt: map['editedAt'] != null ? DateTime.parse(map['editedAt'] as String) : null,
      isStarred: map['isStarred'] == 1,
      isDeleted: map['isDeleted'] == 1,
      isForwarded: map['isForwarded'] == 1,
      isReported: map['isReported'] == 1,
    );
  }

  MessageModel copyWith({
    int? id,
    String? messageId,
    String? chatId,
    String? myId,
    Map<String, String>? reactions,
    String? content,
    String? taggedMessageId,
    String? mediaUrl,
    Map<String, dynamic>? metadata,
    MessageType? messageType,
    DateTime? sentTime,
    DateTime? sentAt,
    DateTime? deliveredAt,
    DateTime? readAt,
    DateTime? editedAt,
    bool? isStarred,
    bool? isDeleted,
    bool? isForwarded,
    bool? isReported,
  }) {
    return MessageModel(
      id: id ?? this.id,
      messageId: messageId ?? this.messageId,
      chatId: chatId ?? this.chatId,
      myId: myId ?? this.myId,
      reactions: reactions ?? this.reactions,
      content: content ?? this.content,
      taggedMessageId: taggedMessageId ?? this.taggedMessageId,
      mediaUrl: mediaUrl ?? this.mediaUrl,
      metadata: metadata ?? this.metadata,
      messageType: messageType ?? this.messageType,
      sentTime: sentTime ?? this.sentTime,
      sentAt: sentAt ?? this.sentAt,
      deliveredAt: deliveredAt ?? this.deliveredAt,
      readAt: readAt ?? this.readAt,
      editedAt: editedAt ?? this.editedAt,
      isStarred: isStarred ?? this.isStarred,
      isDeleted: isDeleted ?? this.isDeleted,
      isForwarded: isForwarded ?? this.isForwarded,
      isReported: isReported ?? this.isReported,
    );
  }


  /// Provides a default map for MessageModel.
  /// Useful as a template when creating new entries.
  static Map<String, dynamic> get defaultMap {
    return {
      'id': null, // SQLite auto-incremented ID
      'messageId': '',
      'chatId': '',
      'myId': '',
      'reactions': null,
      'content': '',
      'taggedMessageId': null,
      'mediaUrl': null,
      'metadata': null,
      'messageType': MessageType.text.index, // Default to text
      'sentTime': DateTime.now().toIso8601String(),
      'sentAt': null,
      'deliveredAt': null,
      'readAt': null,
      'editedAt': null,
      'isStarred': 0,
      'isDeleted': 0,
      'isForwarded': 0,
      'isReported': 0,
    };
  }

}


enum MsgStatus {
  delivered,
  offline,
  read,
  loading,
}

enum MessageType {
  text, // 1. Regular text message
  image, // 2. Image message
  video, // 3. Video message
  document, // 4. Document message
  audio, // 5. Audio message
  link, // 6. URL/Link message
  contact, // 7. Contact message
  location, // 8. Location message
  sticker, // 9. Sticker message
  quote, // 10. Quoted message
}

extension MessageTypeExtension on MessageType {
  // Get the integer value of the enum
  int get value => MessageType.values.indexOf(this);
}
