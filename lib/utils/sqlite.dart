import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'constants.dart';

Future<Database> openCWDatabase() async {
  return openDatabase(
    join(await getDatabasesPath(), DATABASE_NAME),
    version: 1,
    onCreate: (db, version) {
      return db.execute(
        "CREATE TABLE banks(id INTEGER PRIMARY KEY, bankName TEXT, username TEXT, money REAL, cardType TEXT, expirationDate DATETIME, currency TEXT)",
      );
    },
  );
}

/// Add a [row] in the specified [tableName] in the database.
/// A row should be an entity transformed into a map using the
/// function called 'toMap()'.
Future<void> addRow(String tableName, Map<String, dynamic> row) async {
  final Database db = await openCWDatabase();

  await db.insert(
    tableName,
    row,
    conflictAlgorithm: ConflictAlgorithm.replace,
  );

  await db.close();
}

Future<List<dynamic>> getAllRows(String tableName) async {
  final Database db = await openCWDatabase();

  var result = await db.query(tableName);

  await db.close();

  return result;
}
