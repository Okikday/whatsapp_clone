class DbStrings {
  static const dbName = "chat_app.db";
  static const chatsTableName = "Chats";
  static const msgsTableName = "Messages";

  static const createChatDB = "CREATE TABLE $chatsTableName ("
  "chatId TEXT PRIMARY KEY,"
  "contactId TEXT NOT NULL,"
  "chatName TEXT NOT NULL,"
  "chatProfilePhoto TEXT,"
  "lastMsg TEXT NOT NULL,"
  "lastUpdated TEXT NOT NULL,"
  "isMuted INTEGER NOT NULL DEFAULT 0,"
  "isArchived INTEGER NOT NULL DEFAULT 0,"
  "isPinned INTEGER NOT NULL DEFAULT 0,"
  "unreadMsgs INTEGER,"
  "hasStatusUpdate INTEGER);";


  static const createMsgDB = "CREATE TABLE $msgsTableName ("
  "id INTEGER PRIMARY KEY AUTOINCREMENT,"
  "messageId TEXT NOT NULL,"
  "chatId TEXT NOT NULL,"
  "senderId TEXT NOT NULL,"
  "receiverId TEXT NOT NULL,"
  "content TEXT NOT NULL,"
  "mediaUrl TEXT,"
  "mediaCaption TEXT,"
  "mediaType INTEGER NOT NULL,"
  "sentAt TEXT NOT NULL,"
  "deliveredAt TEXT,"
  "readAt TEXT,"
  "isStarred INTEGER DEFAULT 0,"
  "isDeleted INTEGER DEFAULT 0,"
  "FOREIGN KEY (chatId) REFERENCES Chats (chatId) ON DELETE CASCADE);";
}