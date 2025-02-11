import 'package:whatsapp_clone/models/chat_model.dart';

class TestChatsData {
  static final List<ChatModel> chatList = [
    ChatModel(
  chatId: '1',
  contactId: '101',
  chatName: 'Alice',
  chatProfilePhoto: 'https://randomuser.me/api/portraits/women/1.jpg',
  lastMsg: 'Hey, how are you?',
  lastUpdated: DateTime.now().subtract(const Duration(minutes: 10)),
  isMuted: false,
  isArchived: false,
  isPinned: true,
  profileInfo: 'Living my best life 🌟',
),
ChatModel(
  chatId: '2',
  contactId: '102',
  chatName: 'Bob',
  chatProfilePhoto: 'https://randomuser.me/api/portraits/men/2.jpg',
  lastMsg: 'Meeting at 3 PM?',
  lastUpdated: DateTime.now().subtract(const Duration(hours: 1)),
  isMuted: false,
  isArchived: true,
  isPinned: false,
  profileInfo: 'Busy building the future 🚀',
),
ChatModel(
  chatId: '3',
  contactId: '103',
  chatName: 'Charlie',
  chatProfilePhoto: 'https://randomuser.me/api/portraits/men/3.jpg',
  lastMsg: 'Can you send me the file?',
  lastUpdated: DateTime.now().subtract(const Duration(days: 1)),
  isMuted: true,
  isArchived: false,
  isPinned: false,
  profileInfo: 'HIM. God over everything 🙏',
),
ChatModel(
  chatId: '4',
  contactId: '104',
  chatName: 'Daisy',
  chatProfilePhoto: 'https://randomuser.me/api/portraits/women/4.jpg',
  lastMsg: 'Great, see you soon!. I bet it\'s gonna be a wonderful time over there',
  lastUpdated: DateTime.now().subtract(const Duration(days: 2)),
  isMuted: false,
  isArchived: false,
  isPinned: false,
  profileInfo: 'Life is a surprise 🎁',
),
ChatModel(
  chatId: '5',
  contactId: '105',
  chatName: 'Eva',
  chatProfilePhoto: 'https://randomuser.me/api/portraits/women/5.jpg',
  lastMsg: 'Did you finish the report?',
  lastUpdated: DateTime.now().subtract(const Duration(hours: 5)),
  isMuted: false,
  isArchived: false,
  isPinned: true,
  profileInfo: 'Always on the grind 💼',
),
ChatModel(
  chatId: '6',
  contactId: '106',
  chatName: 'Frank',
  chatProfilePhoto: 'https://randomuser.me/api/portraits/men/6.jpg',
  lastMsg: 'Let’s catch up this weekend!',
  lastUpdated: DateTime.now().subtract(const Duration(days: 3)),
  isMuted: false,
  isArchived: false,
  isPinned: false,
  profileInfo: 'Chasing dreams, not people 🌌',
),
ChatModel(
  chatId: '7',
  contactId: '107',
  chatName: 'Grace',
  chatProfilePhoto: 'https://randomuser.me/api/portraits/women/7.jpg',
  lastMsg: 'I’ll send you the details soon.',
  lastUpdated: DateTime.now().subtract(const Duration(minutes: 30)),
  isMuted: true,
  isArchived: false,
  isPinned: false,
  profileInfo: 'Queen of my own world 👑',
),
ChatModel(
  chatId: '8',
  contactId: '108',
  chatName: 'Henry',
  chatProfilePhoto: 'https://randomuser.me/api/portraits/men/8.jpg',
  lastMsg: 'Thanks for your help!',
  lastUpdated: DateTime.now().subtract(const Duration(hours: 12)),
  isMuted: false,
  isArchived: true,
  isPinned: false,
  profileInfo: 'Living simply, dreaming big 🌠',
),
ChatModel(
  chatId: '9',
  contactId: '109',
  chatName: 'Ivy',
  chatProfilePhoto: 'https://randomuser.me/api/portraits/women/9.jpg',
  lastMsg: 'Let’s plan the trip!',
  lastUpdated: DateTime.now().subtract(const Duration(days: 4)),
  isMuted: false,
  isArchived: false,
  isPinned: true,
  profileInfo: 'Adventure is out there 🌍',
),
ChatModel(
  chatId: '10',
  contactId: '110',
  chatName: 'Jack',
  chatProfilePhoto: 'https://randomuser.me/api/portraits/men/10.jpg',
  lastMsg: 'I’ll call you later.',
  lastUpdated: DateTime.now().subtract(const Duration(minutes: 45)),
  isMuted: false,
  isArchived: false,
  isPinned: false,
  profileInfo: 'Hustle in silence 🤫',
),
ChatModel(
  chatId: '11',
  contactId: '111',
  chatName: 'Karen',
  chatProfilePhoto: 'https://randomuser.me/api/portraits/women/11.jpg',
  lastMsg: 'Can you review the document?',
  lastUpdated: DateTime.now().subtract(const Duration(hours: 2)),
  isMuted: false,
  isArchived: false,
  isPinned: false,
  profileInfo: 'Focused and fearless 💪',
),
ChatModel(
  chatId: '12',
  contactId: '112',
  chatName: 'Leo',
  chatProfilePhoto: 'https://randomuser.me/api/portraits/men/12.jpg',
  lastMsg: 'Let’s meet for coffee tomorrow.',
  lastUpdated: DateTime.now().subtract(const Duration(days: 1)),
  isMuted: false,
  isArchived: false,
  isPinned: true,
  profileInfo: 'Living life one cup at a time ☕',
),
ChatModel(
  chatId: '13',
  contactId: '113',
  chatName: 'Mia',
  chatProfilePhoto: 'https://randomuser.me/api/portraits/women/13.jpg',
  lastMsg: 'I’ll send you the invoice shortly.',
  lastUpdated: DateTime.now().subtract(const Duration(minutes: 15)),
  isMuted: true,
  isArchived: false,
  isPinned: false,
  profileInfo: 'Busy creating my legacy 📜',
),
ChatModel(
  chatId: '14',
  contactId: '114',
  chatName: 'Noah',
  chatProfilePhoto: 'https://randomuser.me/api/portraits/men/14.jpg',
  lastMsg: 'Did you get my email?',
  lastUpdated: DateTime.now().subtract(const Duration(hours: 3)),
  isMuted: false,
  isArchived: true,
  isPinned: false,
  profileInfo: 'Tech enthusiast 🖥️',
),
ChatModel(
  chatId: '15',
  contactId: '115',
  chatName: 'Olivia',
  chatProfilePhoto: 'https://randomuser.me/api/portraits/women/15.jpg',
  lastMsg: 'Let’s finalize the plan today.',
  lastUpdated: DateTime.now().subtract(const Duration(days: 2)),
  isMuted: false,
  isArchived: false,
  isPinned: true,
  profileInfo: 'Dreamer and doer ✨',
),
ChatModel(
  chatId: '16',
  contactId: '116',
  chatName: 'Paul',
  chatProfilePhoto: 'https://randomuser.me/api/portraits/men/16.jpg',
  lastMsg: 'I’ll be there in 10 minutes.',
  lastUpdated: DateTime.now().subtract(const Duration(minutes: 5)),
  isMuted: false,
  isArchived: false,
  isPinned: false,
  profileInfo: 'Always on time ⏰',
),
ChatModel(
  chatId: '17',
  contactId: '117',
  chatName: 'Quinn',
  chatProfilePhoto: 'https://randomuser.me/api/portraits/women/17.jpg',
  lastMsg: 'Can you help me with this task?',
  lastUpdated: DateTime.now().subtract(const Duration(hours: 6)),
  isMuted: false,
  isArchived: false,
  isPinned: false,
  profileInfo: 'Team player 🤝',
),
ChatModel(
  chatId: '18',
  contactId: '118',
  chatName: 'Ryan',
  chatProfilePhoto: 'https://randomuser.me/api/portraits/men/18.jpg',
  lastMsg: 'Let’s reschedule the meeting.',
  lastUpdated: DateTime.now().subtract(const Duration(days: 1)),
  isMuted: false,
  isArchived: true,
  isPinned: false,
  profileInfo: 'Always adapting 🔄',
),
ChatModel(
  chatId: '19',
  contactId: '119',
  chatName: 'Sophia',
  chatProfilePhoto: 'https://randomuser.me/api/portraits/women/19.jpg',
  lastMsg: 'I’ll call you in the evening.',
  lastUpdated: DateTime.now().subtract(const Duration(minutes: 20)),
  isMuted: false,
  isArchived: false,
  isPinned: false,
  profileInfo: 'Living with purpose 🌸',
),
ChatModel(
  chatId: '20',
  contactId: '120',
  chatName: 'Tom',
  chatProfilePhoto: 'https://randomuser.me/api/portraits/men/20.jpg',
  lastMsg: 'Thanks for the update!',
  lastUpdated: DateTime.now().subtract(const Duration(hours: 1)),
  isMuted: false,
  isArchived: false,
  isPinned: false,
  profileInfo: 'Grateful and grounded 🙌',
),
    ChatModel(
  chatId: '21',
  contactId: '121',
  chatName: 'Uma',
  chatProfilePhoto: 'https://randomuser.me/api/portraits/women/21.jpg',
  lastMsg: 'Can you share the meeting notes?',
  lastUpdated: DateTime.now().subtract(const Duration(hours: 4)),
  isMuted: false,
  isArchived: false,
  isPinned: false,
  profileInfo: 'Organized and always prepared 📋',
),
ChatModel(
  chatId: '22',
  contactId: '122',
  chatName: 'Victor',
  chatProfilePhoto: 'https://randomuser.me/api/portraits/men/22.jpg',
  lastMsg: 'Let’s discuss the project tomorrow.',
  lastUpdated: DateTime.now().subtract(const Duration(days: 1)),
  isMuted: false,
  isArchived: false,
  isPinned: true,
  profileInfo: 'Innovator at heart 💡',
),
ChatModel(
  chatId: '23',
  contactId: '123',
  chatName: 'Wendy',
  chatProfilePhoto: 'https://randomuser.me/api/portraits/women/23.jpg',
  lastMsg: 'I’ll send you the details by EOD.',
  lastUpdated: DateTime.now().subtract(const Duration(minutes: 30)),
  isMuted: true,
  isArchived: false,
  isPinned: false,
  profileInfo: 'Efficiency is my superpower ⚡',
),
ChatModel(
  chatId: '24',
  contactId: '124',
  chatName: 'Xander',
  chatProfilePhoto: 'https://randomuser.me/api/portraits/men/24.jpg',
  lastMsg: 'Did you get a chance to review the proposal?',
  lastUpdated: DateTime.now().subtract(const Duration(hours: 5)),
  isMuted: false,
  isArchived: true,
  isPinned: false,
  profileInfo: 'Always thinking ahead 🧠',
),
ChatModel(
  chatId: '25',
  contactId: '125',
  chatName: 'Yara',
  chatProfilePhoto: 'https://randomuser.me/api/portraits/women/25.jpg',
  lastMsg: 'Let’s finalize the budget today.',
  lastUpdated: DateTime.now().subtract(const Duration(days: 2)),
  isMuted: false,
  isArchived: false,
  isPinned: true,
  profileInfo: 'Numbers and nature lover 🌿',
),
ChatModel(
  chatId: '26',
  contactId: '126',
  chatName: 'Zack',
  chatProfilePhoto: 'https://randomuser.me/api/portraits/men/26.jpg',
  lastMsg: 'I’ll be there in 15 minutes.',
  lastUpdated: DateTime.now().subtract(const Duration(minutes: 10)),
  isMuted: false,
  isArchived: false,
  isPinned: false,
  profileInfo: 'Always on the move 🏃‍♂️',
),
ChatModel(
  chatId: '27',
  contactId: '127',
  chatName: 'Aria',
  chatProfilePhoto: 'https://randomuser.me/api/portraits/women/27.jpg',
  lastMsg: 'Can you help me with the presentation?',
  lastUpdated: DateTime.now().subtract(const Duration(hours: 3)),
  isMuted: false,
  isArchived: false,
  isPinned: false,
  profileInfo: 'Creative soul 🎨',
),
ChatModel(
  chatId: '28',
  contactId: '128',
  chatName: 'Ben',
  chatProfilePhoto: 'https://randomuser.me/api/portraits/men/28.jpg',
  lastMsg: 'Let’s reschedule the call.',
  lastUpdated: DateTime.now().subtract(const Duration(days: 1)),
  isMuted: false,
  isArchived: true,
  isPinned: false,
  profileInfo: 'Flexible and focused 🎯',
),
ChatModel(
  chatId: '29',
  contactId: '129',
  chatName: 'Chloe',
  chatProfilePhoto: 'https://randomuser.me/api/portraits/women/29.jpg',
  lastMsg: 'I’ll call you in the morning.',
  lastUpdated: DateTime.now().subtract(const Duration(minutes: 25)),
  isMuted: false,
  isArchived: false,
  isPinned: false,
  profileInfo: 'Early bird 🌅',
),
ChatModel(
  chatId: '30',
  contactId: '130',
  chatName: 'David',
  chatProfilePhoto: 'https://randomuser.me/api/portraits/men/30.jpg',
  lastMsg: 'Thanks for the quick response!',
  lastUpdated: DateTime.now().subtract(const Duration(hours: 1)),
  isMuted: false,
  isArchived: false,
  isPinned: false,
  profileInfo: 'Grateful and driven 🙏',
),
ChatModel(
  chatId: '31',
  contactId: '131',
  chatName: 'Ella',
  chatProfilePhoto: 'https://randomuser.me/api/portraits/women/31.jpg',
  lastMsg: 'Can you send me the report?',
  lastUpdated: DateTime.now().subtract(const Duration(hours: 2)),
  isMuted: false,
  isArchived: false,
  isPinned: false,
  profileInfo: 'Detail-oriented perfectionist 📊',
),
ChatModel(
  chatId: '32',
  contactId: '132',
  chatName: 'Finn',
  chatProfilePhoto: 'https://randomuser.me/api/portraits/men/32.jpg',
  lastMsg: 'Let’s meet for lunch tomorrow.',
  lastUpdated: DateTime.now().subtract(const Duration(days: 1)),
  isMuted: false,
  isArchived: false,
  isPinned: true,
  profileInfo: 'Foodie and fun-seeker 🍴',
),
ChatModel(
  chatId: '33',
  contactId: '133',
  chatName: 'Gina',
  chatProfilePhoto: 'https://randomuser.me/api/portraits/women/33.jpg',
  lastMsg: 'I’ll send you the details soon.',
  lastUpdated: DateTime.now().subtract(const Duration(minutes: 45)),
  isMuted: true,
  isArchived: false,
  isPinned: false,
  profileInfo: 'Always on top of things 📌',
),
ChatModel(
  chatId: '34',
  contactId: '134',
  chatName: 'Hank',
  chatProfilePhoto: 'https://randomuser.me/api/portraits/men/34.jpg',
  lastMsg: 'Did you get my message?',
  lastUpdated: DateTime.now().subtract(const Duration(hours: 6)),
  isMuted: false,
  isArchived: true,
  isPinned: false,
  profileInfo: 'Old-school and reliable 📞',
),
ChatModel(
  chatId: '35',
  contactId: '135',
  chatName: 'Isla',
  chatProfilePhoto: 'https://randomuser.me/api/portraits/women/35.jpg',
  lastMsg: 'Let’s finalize the schedule today.',
  lastUpdated: DateTime.now().subtract(const Duration(days: 2)),
  isMuted: false,
  isArchived: false,
  isPinned: true,
  profileInfo: 'Planner and dreamer 📅',
),
ChatModel(
  chatId: '36',
  contactId: '136',
  chatName: 'Jake',
  chatProfilePhoto: 'https://randomuser.me/api/portraits/men/36.jpg',
  lastMsg: 'I’ll be there in 20 minutes.',
  lastUpdated: DateTime.now().subtract(const Duration(minutes: 15)),
  isMuted: false,
  isArchived: false,
  isPinned: false,
  profileInfo: 'Punctual and precise ⏱️',
),
ChatModel(
  chatId: '37',
  contactId: '137',
  chatName: 'Kara',
  chatProfilePhoto: 'https://randomuser.me/api/portraits/women/37.jpg',
  lastMsg: 'Can you review the document?',
  lastUpdated: DateTime.now().subtract(const Duration(hours: 3)),
  isMuted: false,
  isArchived: false,
  isPinned: false,
  profileInfo: 'Critical thinker and problem solver 🧩',
),
ChatModel(
  chatId: '38',
  contactId: '138',
  chatName: 'Liam',
  chatProfilePhoto: 'https://randomuser.me/api/portraits/men/38.jpg',
  lastMsg: 'Let’s reschedule the meeting.',
  lastUpdated: DateTime.now().subtract(const Duration(days: 1)),
  isMuted: false,
  isArchived: true,
  isPinned: false,
  profileInfo: 'Adaptable and calm under pressure 🧘‍♂️',
),
ChatModel(
  chatId: '39',
  contactId: '139',
  chatName: 'Maya',
  chatProfilePhoto: 'https://randomuser.me/api/portraits/women/39.jpg',
  lastMsg: 'I’ll call you in the evening.',
  lastUpdated: DateTime.now().subtract(const Duration(minutes: 20)),
  isMuted: false,
  isArchived: false,
  isPinned: false,
  profileInfo: 'Night owl and deep thinker 🌙',
),
ChatModel(
  chatId: '40',
  contactId: '140',
  chatName: 'Nate',
  chatProfilePhoto: 'https://randomuser.me/api/portraits/men/40.jpg',
  lastMsg: 'Thanks for the update!',
  lastUpdated: DateTime.now().subtract(const Duration(hours: 1)),
  isMuted: false,
  isArchived: false,
  isPinned: false,
  profileInfo: 'Always learning, always growing 🌱',
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
      'taggedMessageID': "This is a tagged message."
    },
    {
      'id': 2,
      'messageId': 'msg2',
      'chatId': '2',
      'senderId': '102',
      'receiverId': '202',
      'content': 'Meeting at 3PM.',
      'mediaUrl': null,
      'mediaCaption': null,
      'mediaType': 0, // Text message
      'sentAt': DateTime.now().subtract(const Duration(hours: 2)).toIso8601String(),
      'deliveredAt': DateTime.now().subtract(const Duration(hours: 1, minutes: 50)).toIso8601String(),
      'readAt': null,
      'isStarred': 0,
      'isDeleted': 0,
      'taggedMessageID': "Hello"
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
      'mediaType': 2, // File message
      'sentAt': DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
      'deliveredAt': null,
      'readAt': null,
      'isStarred': 1,
      'isDeleted': 0,
      'taggedMessageID': "How are you feeling?"
    },
    {
      'id': 4,
      'messageId': 'msg4',
      'chatId': '4',
      'senderId': '104',
      'receiverId': '204',
      'content': 'Great, see you soon! I bet it\'s gonna be a wonderful time over there',
      'mediaUrl': 'https://plus.unsplash.com/premium_photo-1664474619075-644dd191935f?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8aW1hZ2V8ZW58MHx8MHx8fDA%3D',
      'mediaType': 1, // Image message
      'sentAt': DateTime.now().subtract(const Duration(days: 2)).toIso8601String(),
      'deliveredAt': DateTime.now().subtract(const Duration(days: 2, hours: 23)).toIso8601String(),
      'readAt': DateTime.now().subtract(const Duration(days: 2, hours: 22)).toIso8601String(),
      'isStarred': 0,
      'isDeleted': 0,
      'taggedMessageID': "Hello boss"
    },
    {
      'id': 5,
      'messageId': 'msg5',
      'chatId': '5',
      'senderId': '105',
      'receiverId': '205',
      'content': 'Did you finish the report?',
      'mediaUrl': null,
      'mediaCaption': null,
      'mediaType': 0, // Text message
      'sentAt': DateTime.now().subtract(const Duration(hours: 5)).toIso8601String(),
      'deliveredAt': DateTime.now().subtract(const Duration(hours: 4, minutes: 30)).toIso8601String(),
      'readAt': DateTime.now().subtract(const Duration(hours: 4)).toIso8601String(),
      'isStarred': 0,
      'isDeleted': 0,
      'taggedMessageID': "I'm just testing."
    },
    {
      'id': 6,
      'messageId': 'msg6',
      'chatId': '6',
      'senderId': '106',
      'receiverId': '206',
      'content': '',
      'mediaUrl': 'https://images.unsplash.com/photo-1504674900247-0877df9cc836?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8Zm9vZHxlbnwwfHwwfHx8MA%3D%3D&auto=format&fit=crop&w=800&q=60',
      'mediaCaption': 'Dinner plans?',
      'mediaType': 1, // Image message
      'sentAt': DateTime.now().subtract(const Duration(days: 3)).toIso8601String(),
      'deliveredAt': DateTime.now().subtract(const Duration(days: 3, hours: 23)).toIso8601String(),
      'readAt': DateTime.now().subtract(const Duration(days: 3, hours: 22)).toIso8601String(),
      'isStarred': 0,
      'isDeleted': 0,
      'taggedMessageID': "How've you been?\nGlad to have met you today tbh"
    },
    {
      'id': 7,
      'messageId': 'msg7',
      'chatId': '7',
      'senderId': '107',
      'receiverId': '207',
      'content': 'I’ll send you the details soon.',
      'mediaUrl': null,
      'mediaCaption': null,
      'mediaType': 0, // Text message
      'sentAt': DateTime.now().subtract(const Duration(minutes: 30)).toIso8601String(),
      'deliveredAt': DateTime.now().subtract(const Duration(minutes: 25)).toIso8601String(),
      'readAt': null,
      'isStarred': 0,
      'isDeleted': 0,
    },
    {
      'id': 8,
      'messageId': 'msg8',
      'chatId': '8',
      'senderId': '108',
      'receiverId': '208',
      'content': 'Thanks for your help!',
      'mediaUrl': null,
      'mediaCaption': null,
      'mediaType': 0, // Text message
      'sentAt': DateTime.now().subtract(const Duration(hours: 12)).toIso8601String(),
      'deliveredAt': DateTime.now().subtract(const Duration(hours: 11, minutes: 50)).toIso8601String(),
      'readAt': DateTime.now().subtract(const Duration(hours: 11)).toIso8601String(),
      'isStarred': 0,
      'isDeleted': 0,
    },
    {
      'id': 9,
      'messageId': 'msg9',
      'chatId': '9',
      'senderId': '109',
      'receiverId': '209',
      'content': 'Let’s plan the trip!',
      'mediaUrl': 'https://images.unsplash.com/photo-1500835556837-99ac94a94552?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8dHJhdmVsfGVufDB8fDB8fHww&auto=format&fit=crop&w=800&q=60',
      'mediaCaption': 'Travel destination ideas',
      'mediaType': 1, // Image message
      'sentAt': DateTime.now().subtract(const Duration(days: 4)).toIso8601String(),
      'deliveredAt': DateTime.now().subtract(const Duration(days: 4, hours: 23)).toIso8601String(),
      'readAt': DateTime.now().subtract(const Duration(days: 4, hours: 22)).toIso8601String(),
      'isStarred': 1,
      'isDeleted': 0,
    },
    {
      'id': 10,
      'messageId': 'msg10',
      'chatId': '10',
      'senderId': '110',
      'receiverId': '210',
      'content': 'I’ll call you later.',
      'mediaUrl': null,
      'mediaCaption': null,
      'mediaType': 0, // Text message
      'sentAt': DateTime.now().subtract(const Duration(minutes: 45)).toIso8601String(),
      'deliveredAt': DateTime.now().subtract(const Duration(minutes: 40)).toIso8601String(),
      'readAt': null,
      'isStarred': 0,
      'isDeleted': 0,
    },
        {
      'id': 11,
      'messageId': 'msg11',
      'chatId': '11',
      'senderId': '111',
      'receiverId': '211',
      'content': 'Can you review the document?',
      'mediaUrl': 'https://example.com/document.pdf',
      'mediaCaption': 'Project report',
      'mediaType': 2, // File message
      'sentAt': DateTime.now().subtract(const Duration(hours: 2)).toIso8601String(),
      'deliveredAt': DateTime.now().subtract(const Duration(hours: 1, minutes: 50)).toIso8601String(),
      'readAt': DateTime.now().subtract(const Duration(hours: 1)).toIso8601String(),
      'isStarred': 0,
      'isDeleted': 0,
    },
    {
      'id': 12,
      'messageId': 'msg12',
      'chatId': '12',
      'senderId': '112',
      'receiverId': '212',
      'content': 'Let’s meet for coffee tomorrow.',
      'mediaUrl': 'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NHx8Y29mZmVlfGVufDB8fDB8fHww&auto=format&fit=crop&w=800&q=60',
      'mediaCaption': 'Coffee shop',
      'mediaType': 1, // Image message
      'sentAt': DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
      'deliveredAt': DateTime.now().subtract(const Duration(days: 1, hours: 23)).toIso8601String(),
      'readAt': DateTime.now().subtract(const Duration(days: 1, hours: 22)).toIso8601String(),
      'isStarred': 0,
      'isDeleted': 0,
    },
    {
      'id': 13,
      'messageId': 'msg13',
      'chatId': '13',
      'senderId': '113',
      'receiverId': '213',
      'content': 'I’ll send you the invoice shortly.',
      'mediaUrl': null,
      'mediaCaption': null,
      'mediaType': 0, // Text message
      'sentAt': DateTime.now().subtract(const Duration(minutes: 15)).toIso8601String(),
      'deliveredAt': DateTime.now().subtract(const Duration(minutes: 10)).toIso8601String(),
      'readAt': null,
      'isStarred': 0,
      'isDeleted': 0,
    },
    {
      'id': 14,
      'messageId': 'msg14',
      'chatId': '14',
      'senderId': '114',
      'receiverId': '214',
      'content': 'Did you get my email?',
      'mediaUrl': null,
      'mediaCaption': null,
      'mediaType': 0, // Text message
      'sentAt': DateTime.now().subtract(const Duration(hours: 3)).toIso8601String(),
      'deliveredAt': DateTime.now().subtract(const Duration(hours: 2, minutes: 50)).toIso8601String(),
      'readAt': DateTime.now().subtract(const Duration(hours: 2)).toIso8601String(),
      'isStarred': 0,
      'isDeleted': 0,
    },
    {
      'id': 15,
      'messageId': 'msg15',
      'chatId': '15',
      'senderId': '115',
      'receiverId': '215',
      'content': 'Let’s finalize the plan today.',
      'mediaUrl': 'https://example.com/plan.pdf',
      'mediaCaption': 'Project plan',
      'mediaType': 2, // File message
      'sentAt': DateTime.now().subtract(const Duration(days: 2)).toIso8601String(),
      'deliveredAt': DateTime.now().subtract(const Duration(days: 2, hours: 23)).toIso8601String(),
      'readAt': DateTime.now().subtract(const Duration(days: 2, hours: 22)).toIso8601String(),
      'isStarred': 1,
      'isDeleted': 0,
    },
    {
      'id': 16,
      'messageId': 'msg16',
      'chatId': '16',
      'senderId': '116',
      'receiverId': '216',
      'content': 'I’ll be there in 10 minutes.',
      'mediaUrl': null,
      'mediaCaption': null,
      'mediaType': 0, // Text message
      'sentAt': DateTime.now().subtract(const Duration(minutes: 5)).toIso8601String(),
      'deliveredAt': DateTime.now().subtract(const Duration(minutes: 4)).toIso8601String(),
      'readAt': null,
      'isStarred': 0,
      'isDeleted': 0,
    },
    {
      'id': 17,
      'messageId': 'msg17',
      'chatId': '17',
      'senderId': '117',
      'receiverId': '217',
      'content': 'Can you help me with this task?',
      'mediaUrl': null,
      'mediaCaption': null,
      'mediaType': 0, // Text message
      'sentAt': DateTime.now().subtract(const Duration(hours: 6)).toIso8601String(),
      'deliveredAt': DateTime.now().subtract(const Duration(hours: 5, minutes: 50)).toIso8601String(),
      'readAt': DateTime.now().subtract(const Duration(hours: 5)).toIso8601String(),
      'isStarred': 0,
      'isDeleted': 0,
    },
    {
      'id': 18,
      'messageId': 'msg18',
      'chatId': '18',
      'senderId': '118',
      'receiverId': '218',
      'content': 'Let’s reschedule the meeting.',
      'mediaUrl': null,
      'mediaCaption': null,
      'mediaType': 0, // Text message
      'sentAt': DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
      'deliveredAt': DateTime.now().subtract(const Duration(days: 1, hours: 23)).toIso8601String(),
      'readAt': DateTime.now().subtract(const Duration(days: 1, hours: 22)).toIso8601String(),
      'isStarred': 0,
      'isDeleted': 0,
    },
    {
      'id': 19,
      'messageId': 'msg19',
      'chatId': '19',
      'senderId': '119',
      'receiverId': '219',
      'content': 'I’ll call you in the evening.',
      'mediaUrl': null,
      'mediaCaption': null,
      'mediaType': 0, // Text message
      'sentAt': DateTime.now().subtract(const Duration(minutes: 20)).toIso8601String(),
      'deliveredAt': DateTime.now().subtract(const Duration(minutes: 15)).toIso8601String(),
      'readAt': null,
      'isStarred': 0,
      'isDeleted': 0,
    },
    {
      'id': 20,
      'messageId': 'msg20',
      'chatId': '20',
      'senderId': '120',
      'receiverId': '220',
      'content': 'Thanks for the update!',
      'mediaUrl': null,
      'mediaCaption': null,
      'mediaType': 0, // Text message
      'sentAt': DateTime.now().subtract(const Duration(hours: 1)).toIso8601String(),
      'deliveredAt': DateTime.now().subtract(const Duration(minutes: 50)).toIso8601String(),
      'readAt': DateTime.now().subtract(const Duration(minutes: 40)).toIso8601String(),
      'isStarred': 0,
      'isDeleted': 0,
    },
    {
      'id': 21,
      'messageId': 'msg21',
      'chatId': '21',
      'senderId': '121',
      'receiverId': '221',
      'content': 'Can you share the meeting notes?',
      'mediaUrl': 'https://example.com/notes.pdf',
      'mediaCaption': 'Meeting notes',
      'mediaType': 2, // File message
      'sentAt': DateTime.now().subtract(const Duration(hours: 4)).toIso8601String(),
      'deliveredAt': DateTime.now().subtract(const Duration(hours: 3, minutes: 50)).toIso8601String(),
      'readAt': DateTime.now().subtract(const Duration(hours: 3)).toIso8601String(),
      'isStarred': 0,
      'isDeleted': 0,
    },
    {
      'id': 22,
      'messageId': 'msg22',
      'chatId': '22',
      'senderId': '122',
      'receiverId': '222',
      'content': 'Let’s discuss the project tomorrow.',
      'mediaUrl': null,
      'mediaCaption': null,
      'mediaType': 0, // Text message
      'sentAt': DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
      'deliveredAt': DateTime.now().subtract(const Duration(days: 1, hours: 23)).toIso8601String(),
      'readAt': DateTime.now().subtract(const Duration(days: 1, hours: 22)).toIso8601String(),
      'isStarred': 0,
      'isDeleted': 0,
    },
    {
      'id': 23,
      'messageId': 'msg23',
      'chatId': '23',
      'senderId': '123',
      'receiverId': '223',
      'content': 'I’ll send you the details by EOD.',
      'mediaUrl': null,
      'mediaCaption': null,
      'mediaType': 0, // Text message
      'sentAt': DateTime.now().subtract(const Duration(minutes: 30)).toIso8601String(),
      'deliveredAt': DateTime.now().subtract(const Duration(minutes: 25)).toIso8601String(),
      'readAt': null,
      'isStarred': 0,
      'isDeleted': 0,
    },
    {
      'id': 24,
      'messageId': 'msg24',
      'chatId': '24',
      'senderId': '124',
      'receiverId': '224',
      'content': 'Did you get a chance to review the proposal?',
      'mediaUrl': 'https://example.com/proposal.pdf',
      'mediaCaption': 'Project proposal',
      'mediaType': 2, // File message
      'sentAt': DateTime.now().subtract(const Duration(hours: 5)).toIso8601String(),
      'deliveredAt': DateTime.now().subtract(const Duration(hours: 4, minutes: 50)).toIso8601String(),
      'readAt': DateTime.now().subtract(const Duration(hours: 4)).toIso8601String(),
      'isStarred': 1,
      'isDeleted': 0,
    },
    {
      'id': 25,
      'messageId': 'msg25',
      'chatId': '25',
      'senderId': '125',
      'receiverId': '225',
      'content': 'Let’s finalize the budget today.',
      'mediaUrl': 'https://example.com/budget.xlsx',
      'mediaCaption': 'Budget spreadsheet',
      'mediaType': 2, // File message
      'sentAt': DateTime.now().subtract(const Duration(days: 2)).toIso8601String(),
      'deliveredAt': DateTime.now().subtract(const Duration(days: 2, hours: 23)).toIso8601String(),
      'readAt': DateTime.now().subtract(const Duration(days: 2, hours: 22)).toIso8601String(),
      'isStarred': 0,
      'isDeleted': 0,
    },
    {
      'id': 26,
      'messageId': 'msg26',
      'chatId': '26',
      'senderId': '126',
      'receiverId': '226',
      'content': 'I’ll be there in 15 minutes.',
      'mediaUrl': null,
      'mediaCaption': null,
      'mediaType': 0, // Text message
      'sentAt': DateTime.now().subtract(const Duration(minutes: 10)).toIso8601String(),
      'deliveredAt': DateTime.now().subtract(const Duration(minutes: 5)).toIso8601String(),
      'readAt': null,
      'isStarred': 0,
      'isDeleted': 0,
    },
    {
      'id': 27,
      'messageId': 'msg27',
      'chatId': '27',
      'senderId': '127',
      'receiverId': '227',
      'content': 'Can you help me with the presentation?',
      'mediaUrl': 'https://example.com/presentation.pptx',
      'mediaCaption': 'Project presentation',
      'mediaType': 2, // File message
      'sentAt': DateTime.now().subtract(const Duration(hours: 3)).toIso8601String(),
      'deliveredAt': DateTime.now().subtract(const Duration(hours: 2, minutes: 50)).toIso8601String(),
      'readAt': DateTime.now().subtract(const Duration(hours: 2)).toIso8601String(),
      'isStarred': 0,
      'isDeleted': 0,
    },
    {
      'id': 28,
      'messageId': 'msg28',
      'chatId': '28',
      'senderId': '128',
      'receiverId': '228',
      'content': 'Let’s reschedule the call.',
      'mediaUrl': null,
      'mediaCaption': null,
      'mediaType': 0, // Text message
      'sentAt': DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
      'deliveredAt': DateTime.now().subtract(const Duration(days: 1, hours: 23)).toIso8601String(),
      'readAt': DateTime.now().subtract(const Duration(days: 1, hours: 22)).toIso8601String(),
      'isStarred': 0,
      'isDeleted': 0,
    },
    {
      'id': 29,
      'messageId': 'msg29',
      'chatId': '29',
      'senderId': '129',
      'receiverId': '229',
      'content': 'I’ll call you in the morning.',
      'mediaUrl': null,
      'mediaCaption': null,
      'mediaType': 0, // Text message
      'sentAt': DateTime.now().subtract(const Duration(minutes: 25)).toIso8601String(),
      'deliveredAt': DateTime.now().subtract(const Duration(minutes: 20)).toIso8601String(),
      'readAt': null,
      'isStarred': 0,
      'isDeleted': 0,
    },
    {
      'id': 30,
      'messageId': 'msg30',
      'chatId': '30',
      'senderId': '130',
      'receiverId': '230',
      'content': 'Thanks for the quick response!',
      'mediaUrl': null,
      'mediaCaption': null,
      'mediaType': 0, // Text message
      'sentAt': DateTime.now().subtract(const Duration(hours: 1)).toIso8601String(),
      'deliveredAt': DateTime.now().subtract(const Duration(minutes: 50)).toIso8601String(),
      'readAt': DateTime.now().subtract(const Duration(minutes: 40)).toIso8601String(),
      'isStarred': 0,
      'isDeleted': 0,
    },
    {
      'id': 31,
      'messageId': 'msg31',
      'chatId': '31',
      'senderId': '131',
      'receiverId': '231',
      'content': 'Can you send me the report?',
      'mediaUrl': 'https://example.com/report.pdf',
      'mediaCaption': 'Monthly report',
      'mediaType': 2, // File message
      'sentAt': DateTime.now().subtract(const Duration(hours: 2)).toIso8601String(),
      'deliveredAt': DateTime.now().subtract(const Duration(hours: 1, minutes: 50)).toIso8601String(),
      'readAt': DateTime.now().subtract(const Duration(hours: 1)).toIso8601String(),
      'isStarred': 0,
      'isDeleted': 0,
    },
        {
      'id': 32,
      'messageId': 'msg32',
      'chatId': '32',
      'senderId': '132',
      'receiverId': '232',
      'content': 'Let’s meet for lunch tomorrow.',
      'mediaUrl': 'https://images.unsplash.com/photo-1514933651103-005eec06c04b?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8bHVuY2h8ZW58MHx8MHx8fDA%3D&auto=format&fit=crop&w=800&q=60',
      'mediaCaption': 'Lunch plans',
      'mediaType': 1, // Image message
      'sentAt': DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
      'deliveredAt': DateTime.now().subtract(const Duration(days: 1, hours: 23)).toIso8601String(),
      'readAt': DateTime.now().subtract(const Duration(days: 1, hours: 22)).toIso8601String(),
      'isStarred': 0,
      'isDeleted': 0,
    },
    {
      'id': 33,
      'messageId': 'msg33',
      'chatId': '33',
      'senderId': '133',
      'receiverId': '233',
      'content': 'I’ll send you the details soon.',
      'mediaUrl': null,
      'mediaCaption': null,
      'mediaType': 0, // Text message
      'sentAt': DateTime.now().subtract(const Duration(minutes: 45)).toIso8601String(),
      'deliveredAt': DateTime.now().subtract(const Duration(minutes: 40)).toIso8601String(),
      'readAt': null,
      'isStarred': 0,
      'isDeleted': 0,
    },
    {
      'id': 34,
      'messageId': 'msg34',
      'chatId': '34',
      'senderId': '134',
      'receiverId': '234',
      'content': 'Did you get my message?',
      'mediaUrl': null,
      'mediaCaption': null,
      'mediaType': 0, // Text message
      'sentAt': DateTime.now().subtract(const Duration(hours: 6)).toIso8601String(),
      'deliveredAt': DateTime.now().subtract(const Duration(hours: 5, minutes: 50)).toIso8601String(),
      'readAt': DateTime.now().subtract(const Duration(hours: 5)).toIso8601String(),
      'isStarred': 0,
      'isDeleted': 0,
    },
    {
      'id': 35,
      'messageId': 'msg35',
      'chatId': '35',
      'senderId': '135',
      'receiverId': '235',
      'content': 'Let’s finalize the schedule today.',
      'mediaUrl': 'https://example.com/schedule.pdf',
      'mediaCaption': 'Project schedule',
      'mediaType': 2, // File message
      'sentAt': DateTime.now().subtract(const Duration(days: 2)).toIso8601String(),
      'deliveredAt': DateTime.now().subtract(const Duration(days: 2, hours: 23)).toIso8601String(),
      'readAt': DateTime.now().subtract(const Duration(days: 2, hours: 22)).toIso8601String(),
      'isStarred': 1,
      'isDeleted': 0,
    },
    {
      'id': 36,
      'messageId': 'msg36',
      'chatId': '36',
      'senderId': '136',
      'receiverId': '236',
      'content': 'I’ll be there in 20 minutes.',
      'mediaUrl': null,
      'mediaCaption': null,
      'mediaType': 0, // Text message
      'sentAt': DateTime.now().subtract(const Duration(minutes: 15)).toIso8601String(),
      'deliveredAt': DateTime.now().subtract(const Duration(minutes: 10)).toIso8601String(),
      'readAt': null,
      'isStarred': 0,
      'isDeleted': 0,
    },
    {
      'id': 37,
      'messageId': 'msg37',
      'chatId': '37',
      'senderId': '137',
      'receiverId': '237',
      'content': 'Can you review the document?',
      'mediaUrl': 'https://example.com/document.pdf',
      'mediaCaption': 'Project document',
      'mediaType': 2, // File message
      'sentAt': DateTime.now().subtract(const Duration(hours: 3)).toIso8601String(),
      'deliveredAt': DateTime.now().subtract(const Duration(hours: 2, minutes: 50)).toIso8601String(),
      'readAt': DateTime.now().subtract(const Duration(hours: 2)).toIso8601String(),
      'isStarred': 0,
      'isDeleted': 0,
    },
    {
      'id': 38,
      'messageId': 'msg38',
      'chatId': '38',
      'senderId': '138',
      'receiverId': '238',
      'content': 'Let’s reschedule the meeting.',
      'mediaUrl': null,
      'mediaCaption': null,
      'mediaType': 0, // Text message
      'sentAt': DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
      'deliveredAt': DateTime.now().subtract(const Duration(days: 1, hours: 23)).toIso8601String(),
      'readAt': DateTime.now().subtract(const Duration(days: 1, hours: 22)).toIso8601String(),
      'isStarred': 0,
      'isDeleted': 0,
    },
    {
      'id': 39,
      'messageId': 'msg39',
      'chatId': '39',
      'senderId': '139',
      'receiverId': '239',
      'content': 'I’ll call you in the evening.',
      'mediaUrl': null,
      'mediaCaption': null,
      'mediaType': 0, // Text message
      'sentAt': DateTime.now().subtract(const Duration(minutes: 20)).toIso8601String(),
      'deliveredAt': DateTime.now().subtract(const Duration(minutes: 15)).toIso8601String(),
      'readAt': null,
      'isStarred': 0,
      'isDeleted': 0,
    },
    {
      'id': 40,
      'messageId': 'msg40',
      'chatId': '40',
      'senderId': '140',
      'receiverId': '240',
      'content': 'Thanks for the update!',
      'mediaUrl': null,
      'mediaCaption': null,
      'mediaType': 0, // Text message
      'sentAt': DateTime.now().subtract(const Duration(hours: 1)).toIso8601String(),
      'deliveredAt': DateTime.now().subtract(const Duration(minutes: 50)).toIso8601String(),
      'readAt': DateTime.now().subtract(const Duration(minutes: 40)).toIso8601String(),
      'isStarred': 0,
      'isDeleted': 0,
    },
  
  ];
}
