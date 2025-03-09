class ChatModel {
  final String chatId; // Unique ID for the chat (e.g., UUID)
  final String contactId; // ID of the contact
  final String chatName; // Name of the chat (contact's name)
  final String? chatProfilePhoto; // URL or path to the contact's profile photo
  final String? lastMsg; // The last message sent or received
  final DateTime? lastUpdated; // Timestamp of the last activity in the chat
  final bool isMuted; // Indicates if notifications for this chat are muted
  final bool isArchived; // Indicates if this chat is archived
  final bool isPinned; // Indicates if this chat is pinned to the top
  final bool isReported; // Indicates if this chat is reported
  final bool isBlocked; // Indicates if this chat is blocked
  final int? unreadMsgs; // Number of unread messages
  final bool? hasStatusUpdate; // Indicates if the contact has a status update
  final String profileInfo; // Additional profile information
  final DateTime? creationTime;

  ChatModel({
    required this.chatId,
    required this.contactId,
    required this.chatName,
    this.chatProfilePhoto,
    this.lastMsg,
    this.lastUpdated,
    this.isMuted = false,
    this.isArchived = false,
    this.isPinned = false,
    this.isReported = false,
    this.isBlocked = false,
    this.unreadMsgs,
    this.hasStatusUpdate,
    this.profileInfo = '',
    this.creationTime
  });

  // Converts a ChatModel instance to a Map
  Map<String, dynamic> toMap() {
    return {
      'chatId': chatId,
      'contactId': contactId,
      'chatName': chatName,
      'chatProfilePhoto': chatProfilePhoto,
      'lastMsg': lastMsg?.toString(),
      'lastUpdated': lastUpdated?.toIso8601String(),
      'isMuted': isMuted,
      'isArchived': isArchived,
      'isPinned': isPinned,
      'isReported': isReported,
      'isBlocked': isBlocked,
      'unreadMsgs': unreadMsgs,
      'hasStatusUpdate': hasStatusUpdate,
      'profileInfo': profileInfo,
      'creationTime': creationTime?.toIso8601String(),
    };
  }

  // Creates a ChatModel instance from a Map
  factory ChatModel.fromMap(Map<String, dynamic> map) {
    return ChatModel(
        chatId: map['chatId'] as String,
        contactId: map['contactId'] as String,
        chatName: map['chatName'] as String,
        chatProfilePhoto: map['chatProfilePhoto'] as String?,
        lastMsg: map['lastMsg'] as String?,
        lastUpdated: map['lastUpdated'] != null ? DateTime.parse(map['lastUpdated']) : null,
        isMuted: map['isMuted'] as bool? ?? false,
        isArchived: map['isArchived'] as bool? ?? false,
        isPinned: map['isPinned'] as bool? ?? false,
        isReported: map['isReported'] as bool? ?? false,
        isBlocked: map['isBlocked'] as bool? ?? false,
        unreadMsgs: map['unreadMsgs'] as int?,
        hasStatusUpdate: map['hasStatusUpdate'] as bool?,
        profileInfo: map['profileInfo'] as String,
        creationTime: map['creationTime'] != null ? DateTime.parse(map['creationTime']) : null
    );
  }

  // copyWith method
  ChatModel copyWith({
    String? chatId,
    String? contactId,
    String? chatName,
    String? chatProfilePhoto,
    String? lastMsg,
    DateTime? lastUpdated,
    bool? isMuted,
    bool? isArchived,
    bool? isPinned,
    bool? isReported,
    bool? isBlocked,
    int? unreadMsgs,
    bool? hasStatusUpdate,
    String? profileInfo,
    DateTime? creationTime,
  }) {
    return ChatModel(
        chatId: chatId ?? this.chatId,
        contactId: contactId ?? this.contactId,
        chatName: chatName ?? this.chatName,
        chatProfilePhoto: chatProfilePhoto ?? this.chatProfilePhoto,
        lastMsg: lastMsg ?? this.lastMsg,
        lastUpdated: lastUpdated ?? this.lastUpdated,
        isMuted: isMuted ?? this.isMuted,
        isArchived: isArchived ?? this.isArchived,
        isPinned: isPinned ?? this.isPinned,
        isReported: isReported ?? this.isReported,
        isBlocked: isBlocked ?? this.isBlocked,
        unreadMsgs: unreadMsgs ?? this.unreadMsgs,
        hasStatusUpdate: hasStatusUpdate ?? this.hasStatusUpdate,
        profileInfo: profileInfo ?? this.profileInfo,
        creationTime: creationTime ?? this.creationTime
    );
  }

  // A default map structure for initialization
  static Map<String, dynamic> defaultMap() {
    return {
      'chatId': '',
      'contactId': '',
      'chatName': '',
      'chatProfilePhoto': null,
      'lastMsg': null,
      'lastUpdated': null,
      'isMuted': false,
      'isArchived': false,
      'isPinned': false,
      'isReported': false,
      'isBlocked': false,
      'unreadMsgs': null,
      'hasStatusUpdate': null,
      'profileInfo': '',
      'creationTime': null
    };
  }
}