import 'package:whatsapp_clone/app/data/sqflite_database/data/db_strings.dart';
import 'package:whatsapp_clone/app/data/sqflite_database/sqflite_database.dart';

class AppDatabase {
  AppDatabase._init();
  static final AppDatabase instance = AppDatabase._init();

  Future<void> initAppDb() async => await SqfliteDatabase.initDatabase(DbStrings.dbName, 1, [DbStrings.createChatDB, DbStrings.createMsgDB]);

  
}
