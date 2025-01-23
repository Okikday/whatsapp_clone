class ChatModel {
  final String chatId; // Unique ID for the chat (e.g., UUID)
  final String contactId; // ID of the contact
  final String chatName; // Name of the chat (contact's name)
  final String? chatProfilePhoto; // URL or path to the contact's profile photo
  final String lastMsg; // The last message sent or received
  final DateTime lastUpdated; // Timestamp of the last activity in the chat
  final bool isMuted; // Indicates if notifications for this chat are muted
  final bool isArchived; // Indicates if this chat is archived
  final bool isPinned; // Indicates if this chat is pinned to the top
  final int? unreadMsgs;
  final bool? hasStatusUpdate;
  final String profileInfo;
  

  ChatModel({
    required this.chatId,
    required this.contactId,
    required this.chatName,
    this.chatProfilePhoto,
    required this.lastMsg,
    required this.lastUpdated,
    this.isMuted = false,
    this.isArchived = false,
    this.isPinned = false,
    this.unreadMsgs,
    this.hasStatusUpdate,
    this.profileInfo = ''
  });

  // Converts a ChatModel instance to a Map
  Map<String, dynamic> toMap() {
    return {
      'chatId': chatId,
      'contactId': contactId,
      'chatName': chatName,
      'chatProfilePhoto': chatProfilePhoto,
      'lastMsg': lastMsg,
      'lastUpdated': lastUpdated.toIso8601String(),
      'isMuted': isMuted,
      'isArchived': isArchived,
      'isPinned': isPinned,
      'unreadMsgs': unreadMsgs,
      'hasStatusUpdate': hasStatusUpdate,
      'profileInfo': profileInfo
    };
  }

  // Creates a ChatModel instance from a Map
  factory ChatModel.fromMap(Map<String, dynamic> map) {
    return ChatModel(
      chatId: map['chatId'] as String,
      contactId: map['contactId'] as String,
      chatName: map['chatName'] as String,
      chatProfilePhoto: map['chatProfilePhoto'] as String?,
      lastMsg: map['lastMsg'] as String,
      lastUpdated: DateTime.parse(map['lastUpdated'] as String),
      isMuted: map['isMuted'] as bool? ?? false,
      isArchived: map['isArchived'] as bool? ?? false,
      isPinned: map['isPinned'] as bool? ?? false,
      unreadMsgs: map['unreadMsgs'] as int?,
      hasStatusUpdate: map['hasStatusUpdate'] as bool?,
      profileInfo: map['profileInfo'] as String,
    );
  }

  // A default map structure for initialization
  static Map<String, dynamic> defaultMap() {
    return {
      'chatId': '',
      'contactId': '',
      'chatName': '',
      'chatProfilePhoto': null,
      'lastMsg': '',
      'lastUpdated': DateTime.now().toIso8601String(),
      'isMuted': false,
      'isArchived': false,
      'isPinned': false,
      'unreadMsgs': null,
      'hasStatusUpdate': null,
      'profileInfo': ''
    };
  }
}
