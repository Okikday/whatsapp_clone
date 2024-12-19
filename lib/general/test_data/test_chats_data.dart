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
}
