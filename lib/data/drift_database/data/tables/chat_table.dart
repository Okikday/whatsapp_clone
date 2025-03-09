import 'package:drift/drift.dart';

class ChatTable extends Table {
  // Use text as the primary key (assuming chatId is a unique string)
  TextColumn get chatId => text()();

  // Other columns as per your ChatModel
  TextColumn get contactId => text()();
  TextColumn get chatName => text()();
  TextColumn get chatProfilePhoto => text().nullable()();
  TextColumn get lastMsg => text().nullable()();
  DateTimeColumn get lastUpdated => dateTime().nullable()();
  BoolColumn get isMuted => boolean().withDefault(const Constant(false))();
  BoolColumn get isArchived => boolean().withDefault(const Constant(false))();
  BoolColumn get isPinned => boolean().withDefault(const Constant(false))();
  BoolColumn get isReported => boolean().withDefault(const Constant(false))();
  BoolColumn get isBlocked => boolean().withDefault(const Constant(false))();
  IntColumn get unreadMsgs => integer().nullable()();
  BoolColumn get hasStatusUpdate => boolean().nullable()();
  TextColumn get profileInfo => text().withDefault(const Constant(''))();
  DateTimeColumn get creationTime => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {chatId};
}