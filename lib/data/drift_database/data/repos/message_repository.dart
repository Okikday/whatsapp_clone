import 'package:drift/drift.dart';

import 'package:whatsapp_clone/models/message_model.dart';
import '../../app_drift_database.dart';
import '../tables/message_table.dart';

class MessageRepository {
  final AppDriftDatabase _db = AppDriftDatabase.instance;

  // late final AppDriftDatabase _db;
  //
  // Future<void> init() async => _db = await AppDriftDatabase.getEncryptedInstance();

  // Helper: Convert MessageModel to a Drift companion
  MessageTableCompanion _toCompanion(MessageModel msg) {
    return MessageTableCompanion(
      // The auto-incremented ID is typically omitted during insert.
      messageId: Value(msg.messageId),
      chatId: Value(msg.chatId),
      senderId: Value(msg.senderId),
      receiverId: Value(msg.receiverId),
      content: Value(msg.content),
      taggedMessageID: Value(msg.taggedMessageID),
      mediaUrl: Value(msg.mediaUrl),
      mediaType: Value(msg.mediaType),
      sentAt: Value(msg.sentAt),
      deliveredAt: Value(msg.deliveredAt),
      readAt: Value(msg.readAt),
      seenAt: Value(msg.seenAt),
      isStarred: Value(msg.isStarred),
      isDeleted: Value(msg.isDeleted),
    );
  }

  // Helper: Convert Drift data object to MessageModel
  MessageModel _fromData(MessageTableData data) {
    return MessageModel(
      id: data.id,
      messageId: data.messageId,
      chatId: data.chatId,
      senderId: data.senderId,
      receiverId: data.receiverId,
      content: data.content,
      taggedMessageID: data.taggedMessageID,
      mediaUrl: data.mediaUrl,
      mediaType: data.mediaType,
      sentAt: data.sentAt,
      deliveredAt: data.deliveredAt,
      readAt: data.readAt,
      seenAt: data.seenAt,
      isStarred: data.isStarred,
      isDeleted: data.isDeleted,
    );
  }

  /// Inserts a new message.
  Future<int> addMessage(MessageModel message) async {
    final companion = _toCompanion(message);
    return await _db.insertData<MessageTable, MessageTableCompanion, MessageTableData>(
      _db.messageTable,
      companion,
    );
  }

  /// Retrieves all messages for a given chat.
  Future<List<MessageModel>> getMessagesForChat(String chatId) async {
    final dataList = await _db.queryData<MessageTable, MessageTableData>(
      _db.messageTable,
          (tbl) => tbl.chatId.equals(chatId),
    );
    return dataList.map(_fromData).toList();
  }

  /// Updates an existing message.
  Future<int> updateMessage(MessageModel message) async {
    final companion = _toCompanion(message);
    // Assuming messageId is unique for identifying a message.
    return await _db.updateData<MessageTable, MessageTableCompanion, MessageTableData>(
      _db.messageTable,
      companion,
          (tbl) => tbl.messageId.equals(message.messageId),
    );
  }

  /// Deletes a message by its unique messageId.
  Future<int> deleteMessage(String messageId) async {
    return await _db.deleteData<MessageTable, MessageTableData>(
      _db.messageTable,
          (tbl) => tbl.messageId.equals(messageId),
    );
  }

  /// Streams messages for a given chat.
  Stream<List<MessageModel>> watchMessagesForChat(String chatId) {
    return _db.watchQueryData<MessageTable, MessageTableData>(
      _db.messageTable,
          (tbl) => tbl.chatId.equals(chatId),
    ).map((dataList) => dataList.map(_fromData).toList());
  }

  /// Returns a stream of messages whose content contains the search term.
  Stream<List<MessageModel>> searchMessagesStream(String searchTerm) {
    final searchQuery = '%$searchTerm%';
    final query = _db.select(_db.messageTable)
      ..where((tbl) => tbl.content.like(searchQuery));
    return query.watch().map(
          (dataList) => dataList.map(_fromData).toList(),
    );
  }

}
