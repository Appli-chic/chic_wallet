import 'package:chic_wallet/models/db/bank.dart';
import 'package:chic_wallet/models/db/transaction.dart' as t;
import 'package:chic_wallet/models/db/type_transaction.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'constants.dart';

Future<Database> openCWDatabase() async {
  return openDatabase(
    join(await getDatabasesPath(), DATABASE_NAME),
    version: 1,
    onCreate: (db, version) {
      return db.execute(
        // Create the structure of the database
        "CREATE TABLE ${Bank.tableName}(id INTEGER PRIMARY KEY, bank_name TEXT, username TEXT, money REAL, card_type TEXT, expiration_date DATETIME, currency TEXT); "
        "CREATE TABLE ${TypeTransaction.tableName}(id INTEGER PRIMARY KEY, title TEXT, color TEXT, icon_name TEXT); "
        "CREATE TABLE ${t.Transaction.tableName}(id INTEGER PRIMARY KEY, title TEXT, description TEXT, price REAL, date DATETIME, bank_id INTEGER, type_transaction_id INTEGER, FOREIGN KEY(bank_id) REFERENCES ${Bank.tableName}(id), FOREIGN KEY(type_transaction_id) REFERENCES ${TypeTransaction.tableName}(id)); "

        // Insert basic type transactions
        "INSERT INTO ${TypeTransaction.tableName}(title, icon_name) VALUES('Selling', 'Cart'); ",
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
