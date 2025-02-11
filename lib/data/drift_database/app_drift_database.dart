import 'dart:convert';
import 'dart:math';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'data/tables/chat_table.dart';
import 'data/tables/message_table.dart';

part 'app_drift_database.g.dart';

@DriftDatabase(tables: [ChatTable, MessageTable])
class AppDriftDatabase extends _$AppDriftDatabase {
  AppDriftDatabase._() : super(_openConnection());

  static final AppDriftDatabase instance = AppDriftDatabase._();

  // static const FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  // Singleton instance holder.
  // static AppDriftDatabase? _instance;

  // /// Returns the singleton instance of [AppDriftDatabase] using the provided [encryptionKey].
  // /// If the instance hasn't been created yet, it creates one using the encrypted connection.
  // static Future<AppDriftDatabase> getInstance(String encryptionKey) async {
  //   if (_instance == null) {
  //     final executor = await _openEncryptedConnection(encryptionKey);
  //     _instance = AppDriftDatabase._(executor);
  //   }
  //   return _instance!;
  // }

  /// Returns the singleton instance of the encrypted database, using a stored encryption key.
  /// If no key exists, it generates a new 32-byte key, encodes it in Base64, stores it securely, and uses it.
  // static Future<AppDriftDatabase> getEncryptedInstance() async {
  //   final String? savedKey = await _secureStorage.read(key: 'driftEncryptionKey');
  //   String encryptionKey;
  //   if (savedKey != null) {
  //     encryptionKey = savedKey;
  //   } else {
  //     // Generate a new 32-byte key.
  //     final List<int> keyBytes = List<int>.generate(32, (i) => Random.secure().nextInt(256));
  //     encryptionKey = base64Url.encode(keyBytes);
  //     await _secureStorage.write(key: 'driftEncryptionKey', value: encryptionKey);
  //   }
  //   return await getInstance(encryptionKey);
  // }


  @override
  int get schemaVersion => 1;

  /// Execute a custom SQL statement
  Future<void> executeCustom(String statement) async {
    try {
      await customStatement(statement);
    } catch (e) {
      throw Exception("Failed to execute custom statement: $e");
    }
  }

  /// Insert data into a table using a type-safe companion
  Future<int> insertData<T extends Table, C extends UpdateCompanion<D>, D>(
      TableInfo<T, D> table,
      C companion,
      ) async {
    return into(table).insert(companion);
  }

  /// Retrieve all data from a table using proper typing
  Future<List<D>> getAllData<T extends Table, D>(
      TableInfo<T, D> table,
      ) async {
    return select(table).get();
  }

  /// Query data with conditions
  Future<List<D>> queryData<T extends Table, D>(
      TableInfo<T, D> table,
      Expression<bool> Function(T tbl) whereClause,
      ) async {
    return (select(table)..where(whereClause)).get();
  }

  /// Update data in a table using proper companion
  Future<Future<int>> updateData<T extends Table, C extends UpdateCompanion<D>, D>(
      TableInfo<T, D> table,
      C companion,
      Expression<bool> Function(T tbl) whereClause,
      ) async {
    return (update(table)..where(whereClause)).write(companion);
  }

  /// Delete data from a table based on a condition
  Future<int> deleteData<T extends Table, D>(
      TableInfo<T, D> table,
      Expression<bool> Function(T tbl) whereClause,
      ) async {
    return (delete(table)..where(whereClause)).go();
  }

  /// Clear all data from a table
  Future<int> clearTable<T extends Table, D>(TableInfo<T, D> table) async {
    return delete(table).go();
  }

  /// Stream all data from a table
  Stream<List<D>> watchAllData<T extends Table, D>(
      TableInfo<T, D> table,
      ) {
    return select(table).watch();
  }

  /// Stream data with conditions
  Stream<List<D>> watchQueryData<T extends Table, D>(
      TableInfo<T, D> table,
      Expression<bool> Function(T tbl) whereClause,
      ) {
    return (select(table)..where(whereClause)).watch();
  }

  /// Get a single record by condition
  Future<D?> getSingle<T extends Table, D>(
      TableInfo<T, D> table,
      Expression<bool> Function(T tbl) whereClause,
      ) async {
    return (select(table)..where(whereClause)).getSingleOrNull();
  }

  /// Close the database connection
  Future<void> closeDb() async => close();
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'app_database.sqlite'));
    return NativeDatabase(file);
  });
}

// Future<QueryExecutor> _openEncryptedConnection(String encryptionKey) async {
//   return LazyDatabase(() async {
//     final dbFolder = await getApplicationDocumentsDirectory();
//     final file = File(p.join(dbFolder.path, 'app_database_enc.sqlite'));
//     return NativeDatabase(
//       file,
//       logStatements: true,
//       setup: (database) {
//         // This applies the encryption key to the database using SQLCipher.
//         database.execute("PRAGMA key = '$encryptionKey'");
//       },
//     );
//   });
// }

// Future<QueryExecutor> _openEncryptedConnection(String encryptionKey) async {
//   return LazyDatabase(() async {
//
//
//     final dbFolder = await getApplicationDocumentsDirectory();
//     final file = File(p.join(dbFolder.path, 'app_database_enc.sqlite'));
//
//     return NativeDatabase(
//       file,
//       logStatements: true,
//       setup: (database) {
//         database.execute("PRAGMA key = '$encryptionKey'");
//       },
//     );
//   });
// }
