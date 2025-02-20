import 'package:drift/drift.dart';

class MessageTable extends Table {
  // Auto-incrementing primary key
  IntColumn get id => integer().autoIncrement()();

  // Other columns as per your MessageModel
  TextColumn get messageId => text()();
  TextColumn get chatId => text()(); // Foreign key: references Chats.chatId
  TextColumn get myId => text()();
  TextColumn get content => text()();
  TextColumn get taggedMessageID => text().nullable()();
  TextColumn get mediaUrl => text().nullable()();
  IntColumn get mediaType => integer()();
  DateTimeColumn get sentAt => dateTime().nullable()();
  DateTimeColumn get deliveredAt => dateTime().nullable()();
  DateTimeColumn get readAt => dateTime().nullable()();
  BoolColumn get isStarred => boolean().withDefault(const Constant(false))();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
}
