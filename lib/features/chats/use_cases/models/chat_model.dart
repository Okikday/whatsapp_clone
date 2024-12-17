class ChatModel {
  final String chatId; // Unique ID for the chat (e.g., UUID)
  final String contactId;
  final String chatName; // Name of the chat (contact's name)
  final String chatProfilePhoto; // URL or path to the contact's profile photo
  final String lastMsg; // The last message sent or received
  final DateTime lastUpdated; // Timestamp of the last activity in the chat
  final bool isMuted; // Indicates if notifications for this chat are muted
  final bool isArchived; // Indicates if this chat is archived
  final bool isPinned; // Indicates if this chat is pinned to the top

  ChatModel({
    required this.chatId,
    required this.contactId,
    required this.chatName,
    required this.chatProfilePhoto,
    required this.lastMsg,
    required this.lastUpdated,
    required this.isMuted,
    required this.isArchived,
    required this.isPinned,
  });
}
