import 'package:drift/drift.dart';

import '../../../../models/chat_model.dart';
import '../../app_drift_database.dart';
import '../tables/chat_table.dart';

class ChatRepository {
  final AppDriftDatabase _db = AppDriftDatabase.instance;

  // late final AppDriftDatabase _db;
  //
  // Future<void> init() async => _db = await AppDriftDatabase.getEncryptedInstance();

  // Helper: Convert ChatModel to a Drift companion
  ChatTableCompanion _toCompanion(ChatModel chat) {
    return ChatTableCompanion(
      chatId: Value(chat.chatId),
      contactId: Value(chat.contactId),
      chatName: Value(chat.chatName),
      chatProfilePhoto: Value(chat.chatProfilePhoto),
      lastMsg: Value(chat.lastMsg),
      lastUpdated: Value(chat.lastUpdated),
      isMuted: Value(chat.isMuted),
      isArchived: Value(chat.isArchived),
      isPinned: Value(chat.isPinned),
      unreadMsgs: Value(chat.unreadMsgs),
      hasStatusUpdate: Value(chat.hasStatusUpdate),
      profileInfo: Value(chat.profileInfo),
    );
  }

  // Helper: Convert Drift data object to ChatModel
  ChatModel _fromData(ChatTableData data) {
    return ChatModel(
      chatId: data.chatId,
      contactId: data.contactId,
      chatName: data.chatName,
      chatProfilePhoto: data.chatProfilePhoto,
      lastMsg: data.lastMsg,
      lastUpdated: data.lastUpdated,
      isMuted: data.isMuted,
      isArchived: data.isArchived,
      isPinned: data.isPinned,
      unreadMsgs: data.unreadMsgs,
      hasStatusUpdate: data.hasStatusUpdate,
      profileInfo: data.profileInfo,
    );
  }

  /// Inserts a new chat.
  Future<int> addChat(ChatModel chat) async {
    final companion = _toCompanion(chat);
    return await _db.insertData<ChatTable, ChatTableCompanion, ChatTableData>(
      _db.chatTable,
      companion,
    );
  }

  /// Retrieves all chats.
  Future<List<ChatModel>> getAllChats() async {
    final dataList = await _db.getAllData<ChatTable, ChatTableData>(_db.chatTable);
    return dataList.map(_fromData).toList();
  }

  Future<int> getChatCount() async => (await getAllChats()).length;

  Stream<int> streamChatCount() =>
      _db.watchAllData<ChatTable, ChatTableData>(_db.chatTable).map((dataList) => dataList.map(_fromData).toList().length);

  /// Retrieves a single chat by its ID.
  Future<ChatModel?> getChatById(String chatId) async {
    final data = await _db.getSingle<ChatTable, ChatTableData>(
      _db.chatTable,
      (tbl) => tbl.chatId.equals(chatId),
    );
    return data != null ? _fromData(data) : null;
  }

  /// Updates an existing chat.
  Future<int> updateChat(ChatModel chat) async {
    final companion = _toCompanion(chat);
    return await _db.updateData<ChatTable, ChatTableCompanion, ChatTableData>(
      _db.chatTable,
      companion,
      (tbl) => tbl.chatId.equals(chat.chatId),
    );
  }

  /// Deletes a chat by its ID.
  Future<int> deleteChat(String chatId) async {
    return await _db.deleteData<ChatTable, ChatTableData>(
      _db.chatTable,
      (tbl) => tbl.chatId.equals(chatId),
    );
  }

  /// Streams all chats.
  Stream<List<ChatModel>> watchAllChats() {
    return _db.watchAllData<ChatTable, ChatTableData>(_db.chatTable).map(
          (dataList) => dataList.map(_fromData).toList(),
        );
  }

  /// Returns a stream of chats matching the search term.
  Stream<List<ChatModel>> searchChatsStream(String searchTerm) {
    final searchQuery = '%$searchTerm%';
    final query = _db.select(_db.chatTable)..where((tbl) => tbl.chatName.like(searchQuery) | tbl.contactId.like(searchQuery));
    return query.watch().map(
          (dataList) => dataList.map(_fromData).toList(),
        );
  }
}
