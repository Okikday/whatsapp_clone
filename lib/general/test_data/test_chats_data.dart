import 'package:whatsapp_clone/features/chats/use_cases/models/chat_model.dart';

class TestChatsData {
  static final List<ChatModel> chatList = [
    ChatModel(
      chatId: '1',
      contactId: '101',
      chatName: 'Alice',
      chatProfilePhoto: 'https://randomuser.me/api/portraits/women/1.jpg', // Example profile photo URL
      lastMsg: 'Hey, how are you?',
      lastUpdated: DateTime.now().subtract(const Duration(minutes: 10)),
      isMuted: false,
      isArchived: false,
      isPinned: true,
    ),
    ChatModel(
      chatId: '2',
      contactId: '102',
      chatName: 'Bob',
      chatProfilePhoto: 'https://randomuser.me/api/portraits/men/2.jpg', // Example profile photo URL
      lastMsg: 'Meeting at 3 PM?',
      lastUpdated: DateTime.now().subtract(const Duration(hours: 1)),
      isMuted: false,
      isArchived: true,
      isPinned: false,
    ),
    ChatModel(
      chatId: '3',
      contactId: '103',
      chatName: 'Charlie',
      chatProfilePhoto: 'https://randomuser.me/api/portraits/men/3.jpg', // Example profile photo URL
      lastMsg: 'Can you send me the file?',
      lastUpdated: DateTime.now().subtract(const Duration(days: 1)),
      isMuted: true,
      isArchived: false,
      isPinned: false,
    ),
    ChatModel(
      chatId: '4',
      contactId: '104',
      chatName: 'Daisy',
      chatProfilePhoto: 'https://randomuser.me/api/portraits/women/4.jpg', // Example profile photo URL
      lastMsg: 'Great, see you soon!. I bet it\'s gonna be a wonderful time over there',
      lastUpdated: DateTime.now().subtract(const Duration(days: 2)),
      isMuted: false,
      isArchived: false,
      isPinned: false,
    ),
  ];

  static final List<Map<String, dynamic>> messageList = [
  {
    'id': 1,
    'messageId': 'msg1',
    'chatId': '1',
    'senderId': '101',
    'receiverId': '201',
    'content': 'Hey, how are you?',
    'mediaUrl': null,
    'mediaCaption': null,
    'mediaType': 0, // Text message
    'sentAt': DateTime.now().subtract(const Duration(minutes: 15)).toIso8601String(),
    'deliveredAt': DateTime.now().subtract(const Duration(minutes: 10)).toIso8601String(),
    'readAt': DateTime.now().subtract(const Duration(minutes: 5)).toIso8601String(),
    'isStarred': 0,
    'isDeleted': 0,
  },
  {
    'id': 2,
    'messageId': 'msg2',
    'chatId': '2',
    'senderId': '102',
    'receiverId': '202',
    'content': 'Meeting at 3 PM?',
    'mediaUrl': null,
    'mediaCaption': null,
    'mediaType': 0, // Text message
    'sentAt': DateTime.now().subtract(const Duration(hours: 2)).toIso8601String(),
    'deliveredAt': DateTime.now().subtract(const Duration(hours: 1, minutes: 50)).toIso8601String(),
    'readAt': null,
    'isStarred': 0,
    'isDeleted': 0,
  },
  {
    'id': 3,
    'messageId': 'msg3',
    'chatId': '3',
    'senderId': '103',
    'receiverId': '203',
    'content': 'Can you send me the file?',
    'mediaUrl': 'https://example.com/file.pdf',
    'mediaCaption': 'Important file',
    'mediaType': 1, // File message
    'sentAt': DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
    'deliveredAt': null,
    'readAt': null,
    'isStarred': 1,
    'isDeleted': 0,
  },
  {
    'id': 4,
    'messageId': 'msg4',
    'chatId': '4',
    'senderId': '104',
    'receiverId': '204',
    'content': 'Great, see you soon! I bet it\'s gonna be a wonderful time over there',
    'mediaUrl': 'https://example.com/image.jpg',
    'mediaCaption': 'Excited for the event!',
    'mediaType': 2, // Image message
    'sentAt': DateTime.now().subtract(const Duration(days: 2)).toIso8601String(),
    'deliveredAt': DateTime.now().subtract(const Duration(days: 2, hours: 23)).toIso8601String(),
    'readAt': DateTime.now().subtract(const Duration(days: 2, hours: 22)).toIso8601String(),
    'isStarred': 0,
    'isDeleted': 0,
  },
];

}
