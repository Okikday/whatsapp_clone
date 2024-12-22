import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:whatsapp_clone/common/utilities/utilities.dart';

class SqfliteDatabase {
  static Database? _database;

  // Initialize the database
  static Future<Result<void>> initDatabase(String dbName, int version, List<String> createTableQueries, {String? path}) async {
    try {
      final dbPath = path ?? await getDatabasesPath();
      final fullPath = join(dbPath, dbName);

      _database = await openDatabase(
        fullPath,
        version: version,
        onCreate: (db, version) async {
          for (String query in createTableQueries) {
            await db.execute(query);
          }
        },
      );

      return Result.success(null);
    } catch (e) {
      return Result.error("Failed to initialize database: \$e");
    }
  }

  // Add a new table dynamically
  static Future<Result<bool>> addTable(String createTableQuery) async {
    try {
      if (_database == null) {
        return Result.error("Database is not initialized. Call initDatabase first.");
      }
      await _database!.execute(createTableQuery);
      return Result.success(true);
    } catch (e) {
      return Result.error("Failed to add table: \$e");
    }
  }

  // Insert data into a table
  static Future<Result<int>> insertData(String table, Map<String, dynamic> values) async {
    try {
      if (_database == null) {
        return Result.error("Database is not initialized. Call initDatabase first.");
      }
      final id = await _database!.insert(table, values);
      return Result.success(id);
    } catch (e) {
      return Result.error("Failed to insert data: \$e");
    }
  }

  // Retrieve data from a table
  static Future<Result<List<Map<String, dynamic>>>> getData(String table, {String? where, List<Object?>? whereArgs}) async {
    try {
      if (_database == null) {
        return Result.error("Database is not initialized. Call initDatabase first.");
      }
      final data = await _database!.query(table, where: where, whereArgs: whereArgs);
      return Result.success(data);
    } catch (e) {
      return Result.error("Failed to retrieve data: \$e");
    }
  }

  // Update data in a table
  static Future<Result<int>> updateData(String table, Map<String, dynamic> values, {String? where, List<Object?>? whereArgs}) async {
    try {
      if (_database == null) {
        return Result.error("Database is not initialized. Call initDatabase first.");
      }
      final count = await _database!.update(table, values, where: where, whereArgs: whereArgs);
      return Result.success(count);
    } catch (e) {
      return Result.error("Failed to update data: \$e");
    }
  }

  // Delete data from a table
  static Future<Result<int>> deleteData(String table, {String? where, List<Object?>? whereArgs}) async {
    try {
      if (_database == null) {
        return Result.error("Database is not initialized. Call initDatabase first.");
      }
      final count = await _database!.delete(table, where: where, whereArgs: whereArgs);
      return Result.success(count);
    } catch (e) {
      return Result.error("Failed to delete data: \$e");
    }
  }

  // Close the database
  static Future<Result<void>> closeDatabase() async {
    try {
      if (_database != null) {
        await _database!.close();
        _database = null;
      }
      return Result.success(null);
    } catch (e) {
      return Result.error("Failed to close database: \$e");
    }
  }
}