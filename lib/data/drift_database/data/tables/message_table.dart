import 'package:drift/drift.dart';

class MessageTable extends Table {
  // Auto-incrementing primary key
  IntColumn get id => integer().autoIncrement()();

  // Other columns as per your MessageModel
  TextColumn get messageId => text()();
  TextColumn get chatId => text()(); // Foreign key: references Chats.chatId
  TextColumn get myId => text()();
  TextColumn get content => text()();
  TextColumn get taggedMessageId => text().nullable()();
  TextColumn get mediaUrl => text().nullable()();
  TextColumn get reactions => text().nullable()(); // Store reactions as JSON
  TextColumn get metadata => text().nullable()(); // Store metadata as JSON
  IntColumn get messageType => integer()(); // Store MessageType as an integer index
  DateTimeColumn get sentTime => dateTime()();
  DateTimeColumn get sentAt => dateTime().nullable()();
  DateTimeColumn get deliveredAt => dateTime().nullable()();
  DateTimeColumn get readAt => dateTime().nullable()();
  DateTimeColumn get editedAt => dateTime().nullable()();
  BoolColumn get isStarred => boolean().withDefault(const Constant(false))();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  BoolColumn get isForwarded => boolean().withDefault(const Constant(false))();
  BoolColumn get isReported => boolean().withDefault(const Constant(false))();
}