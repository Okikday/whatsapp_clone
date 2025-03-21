import 'package:drift/drift.dart';

import 'dart:convert';

import '../../../../models/message_model.dart';
import '../../app_drift_database.dart';
import '../tables/message_table.dart';

class MessageRepository {
  final AppDriftDatabase _db = AppDriftDatabase.instance;

  // Helper: Convert MessageModel to a Drift companion
  MessageTableCompanion _toCompanion(MessageModel msg) {
    return MessageTableCompanion(
      messageId: Value(msg.messageId),
      chatId: Value(msg.chatId),
      myId: Value(msg.myId),
      content: Value(msg.content),
      taggedMessageId: Value(msg.taggedMessageId), // Updated field name
      mediaUrl: Value(msg.mediaUrl),
      reactions: Value(jsonEncode(msg.reactions)), // Serialize reactions to JSON
      metadata: Value(jsonEncode(msg.metadata)), // Serialize metadata to JSON
      messageType: Value(msg.messageType.index), // Store enum as index
      sentTime: Value(msg.sentTime), // New field
      sentAt: Value(msg.sentAt),
      deliveredAt: Value(msg.deliveredAt),
      readAt: Value(msg.readAt),
      editedAt: Value(msg.editedAt), // New field
      isStarred: Value(msg.isStarred),
      isDeleted: Value(msg.isDeleted),
      isForwarded: Value(msg.isForwarded), // New field
      isReported: Value(msg.isReported), // New field
    );
  }

  // Helper: Convert Drift data object to MessageModel
  MessageModel _fromData(MessageTableData data) {
    // Decode reactions
    final decodedReactions = (data.reactions != null && data.reactions!.isNotEmpty) ? jsonDecode(data.reactions!) : null;
    final reactions = (decodedReactions is Map) ? Map<String, String>.from(decodedReactions) : null;

// Decode metadata
    final decodedMetadata = (data.metadata != null && data.metadata!.isNotEmpty) ? jsonDecode(data.metadata!) : null;
    final metadata = (decodedMetadata is Map) ? Map<String, dynamic>.from(decodedMetadata) : null;

    return MessageModel(
      id: data.id,
      messageId: data.messageId,
      chatId: data.chatId,
      myId: data.myId,
      content: data.content,
      taggedMessageId: data.taggedMessageId, // Updated field name
      mediaUrl: data.mediaUrl,
      reactions: reactions,
      metadata: metadata,

      messageType: MessageType.values[data.messageType], // Convert index back to enum
      sentTime: data.sentTime, // New field
      sentAt: data.sentAt,
      deliveredAt: data.deliveredAt,
      readAt: data.readAt,
      editedAt: data.editedAt, // New field
      isStarred: data.isStarred,
      isDeleted: data.isDeleted,
      isForwarded: data.isForwarded, // New field
      isReported: data.isReported, // New field
    );
  }

  /// Checks if a message with the given [messageId] exists in the database.
  Future<bool> doesMsgIdExists(String messageId) async {
    final message = await _db.getSingle<MessageTable, MessageTableData>(
      _db.messageTable,
          (tbl) => tbl.messageId.equals(messageId),
    );
    return message != null;
  }

  /// Inserts a new message.
  Future<int> addMessage(MessageModel message) async {
    final companion = _toCompanion(message);
    return await _db.insertData<MessageTable, MessageTableCompanion, MessageTableData>(
      _db.messageTable,
      companion,
    );
  }

  /// Updates an existing message.
  Future<int> updateMessage(MessageModel message) async {
    final companion = _toCompanion(message);
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

  /// Retrieves messages for a given chat, optionally limiting the number returned.
  /// If [limit] is provided and greater than zero, only that number of messages is returned.
  Future<List<MessageModel>> getMessagesForChat(String chatId, {int? limit}) async {
    // Build a query to get messages for the given chatId.
    final query = _db.select(_db.messageTable)
      ..where((tbl) => tbl.chatId.equals(chatId))
      ..orderBy([
            (tbl) => OrderingTerm(expression: tbl.sentTime, mode: OrderingMode.desc)
      ]);

    // Apply the limit if provided.
    if (limit != null && limit > 0) {
      query.limit(limit);
    }

    // Get the data and convert it to MessageModel.
    final dataList = await query.get();
    return dataList.map(_fromData).toList();
  }

  /// Streams messages for a given chat, optionally limiting the number emitted.
  /// If [limit] is provided and greater than zero, the stream returns only that number of messages.
  /// Use [ascending] to sort messages in ascending order (by sentTime), or descending if false.
  Stream<List<MessageModel>> watchMessagesForChat(
      String chatId, {
        int? limit,
        bool ascending = false,
      }) {
    final query = _db.select(_db.messageTable)
      ..where((tbl) => tbl.chatId.equals(chatId))
      ..orderBy([
            (tbl) => OrderingTerm(
          expression: tbl.sentTime,
          mode: ascending ? OrderingMode.asc : OrderingMode.desc,
        )
      ]);

    if (limit != null && limit > 0) {
      query.limit(limit);
    }

    return query.watch().map((dataList) => dataList.map(_fromData).toList());
  }



  /// Returns a stream of messages whose content contains the search term.
  Stream<List<MessageModel>> searchMessagesStream(String searchTerm) {
    final searchQuery = '%$searchTerm%';
    final query = _db.select(_db.messageTable)..where((tbl) => tbl.content.like(searchQuery));
    return query.watch().map(
          (dataList) => dataList.map(_fromData).toList(),
    );
  }
}