class MessageModel {
  final int? id; // Auto-incremented ID for SQLite
  final String messageId;
  final String chatId;
  final String senderId;
  final String receiverId;
  final String content;
  final String? taggedMessageID;
  final String? mediaUrl; // URL for media like images, videos, etc.
  final String? mediaCaption; // Caption for media (e.g., image caption)
  final int mediaType; // Use an integer to represent MessageType
  final DateTime sentAt;
  final DateTime? deliveredAt;
  final DateTime? readAt;
  final DateTime? seenAt;
  final bool isStarred;
  final bool isDeleted;

  MessageModel({
    this.id,
    required this.messageId,
    required this.chatId,
    required this.senderId,
    required this.receiverId,
    required this.content,
    this.taggedMessageID,
    this.mediaUrl,
    this.mediaCaption,
    required this.mediaType,
    required this.sentAt,
    this.deliveredAt,
    this.readAt,
    this.seenAt,
    this.isStarred = false,
    this.isDeleted = false,
  });

  // Convert MessageModel to a map (for inserting into SQLite)
  Map<String, dynamic> toMap() {
    return {
      'messageId': messageId,
      'chatId': chatId,
      'senderId': senderId,
      'receiverId': receiverId,
      'content': content,
      'taggedMessageID': taggedMessageID,
      'mediaUrl': mediaUrl,
      'mediaCaption': mediaCaption,
      'mediaType': mediaType,
      'sentAt': sentAt.toIso8601String(),
      'deliveredAt': deliveredAt?.toIso8601String(),
      'readAt': readAt?.toIso8601String(),
      'seenAt': seenAt?.toIso8601String(),
      'isStarred': isStarred ? 1 : 0,
      'isDeleted': isDeleted ? 1 : 0,
    };
  }

  // Convert a Map to a MessageModel object (for reading from SQLite)
  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      id: map['id'],
      messageId: map['messageId'],
      chatId: map['chatId'],
      senderId: map['senderId'],
      receiverId: map['receiverId'],
      content: map['content'],
      taggedMessageID: map['taggedMessageID'] as String?,
      mediaUrl: map['mediaUrl'] as String?,
      mediaCaption: map['mediaCaption'] as String?,
      mediaType: map['mediaType'],
      sentAt: DateTime.parse(map['sentAt']),
      deliveredAt: map['deliveredAt'] != null ? DateTime.parse(map['deliveredAt'] as String) : null,
      readAt: map['readAt'] != null ? DateTime.parse(map['readAt']) : null,
      seenAt: map['readAt'] != null ? DateTime.parse(map['readAt']) : null,
      isStarred: map['isStarred'] == 1,
      isDeleted: map['isDeleted'] == 1,
    );
  }

  Map<String, dynamic> defaultMap() {
  return {
    'id': null, // SQLite auto-incremented ID
    'messageId': '', // Default empty string
    'chatId': '', // Default empty string
    'senderId': '', // Default empty string
    'receiverId': '', // Default empty string
    'content': '', // Default empty string
    'taggedMessageID': null,
    'mediaUrl': null, // Default null for optional fields
    'mediaCaption': null, // Default null for optional fields
    'mediaType': 0, // Default 0 for MessageType
    'sentAt': DateTime.now().toIso8601String(), // Default to the current timestamp
    'deliveredAt': null, // Default null for optional fields
    'readAt': null, // Default null for optional fields
    'seenAt': null,
    'isStarred': 0, // Default 0 (false)
    'isDeleted': 0, // Default 0 (false)
  };
}

}

enum MessageType {
  text,     // Regular text message
  image,    // Image message
  video,    // Video message
  document, // Document message
  audio,    // Audio message
  link,     // URL/Link message
  contact,  // Contact message
  location, // Location message
  sticker,  // Sticker message
  quote,    // Quoted message
}

extension MessageTypeExtension on MessageType {
  // Get the integer value of the enum
  int get value {
    return MessageType.values.indexOf(this);
  }

  // Get MessageType from an integer value
  static MessageType fromInt(int value) {
    return MessageType.values[value];
  }
}

enum MsgStatus {
  delivered,
  offline,
  read,
  loading,
}


