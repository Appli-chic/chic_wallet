import 'package:chic_wallet/models/db/type_transaction.dart';
import 'package:chic_wallet/models/env.dart';
import 'package:chic_wallet/utils/sqlite.dart';
import 'package:http/http.dart';

class TypeTransactionService {
  Client client = Client();
  final Env env;

  TypeTransactionService({
    this.env,
  });

  TypeTransaction _fromJsonQuery(dynamic json) {
    return TypeTransaction(
      id: json['id'],
      title: json['title'],
      color: json['color'],
      iconName: json['icon_name'],
    );
  }

  Future<void> delete(TypeTransaction typeTransaction) async {
    await sqlQuery(
        "DELETE FROM ${TypeTransaction.tableName} WHERE ${TypeTransaction.tableName}.id = ${typeTransaction.id}");
  }

  Future<void> update(TypeTransaction typeTransaction) async {
    await sqlQuery("UPDATE ${TypeTransaction.tableName} "
        "SET title = '${typeTransaction.title}', color = '${typeTransaction.color}', icon_name = '${typeTransaction.iconName}' "
        "WHERE ${TypeTransaction.tableName}.id = ${typeTransaction.id}");
  }

  Future<void> save(TypeTransaction typeTransaction) async {
    await addRow(TypeTransaction.tableName, typeTransaction.toMap());
  }

  Future<List<TypeTransaction>> getAll() async {
    var result = await getAllRows(TypeTransaction.tableName);

    return List.generate(result.length, (i) {
      return _fromJsonQuery(result[i]);
    });
  }

  Future<List<TypeTransaction>> getAllFromTitle(String title) async {
    var result = await sqlQuery("SELECT * "
            "FROM ${TypeTransaction.tableName} " +
        "where ${TypeTransaction.tableName}.title = '$title' ");

    return List.generate(result.length, (i) {
      return _fromJsonQuery(result[i]);
    });
  }

  Future<List<TypeTransaction>> getAllFromColor(String color) async {
    var result = await sqlQuery("SELECT * "
            "FROM ${TypeTransaction.tableName} " +
        "where ${TypeTransaction.tableName}.color = '$color' ");

    return List.generate(result.length, (i) {
      return _fromJsonQuery(result[i]);
    });
  }

  Future<List<TypeTransaction>> getAllFromIcon(String icon) async {
    var result = await sqlQuery("SELECT * "
            "FROM ${TypeTransaction.tableName} " +
        "where ${TypeTransaction.tableName}.icon_name = '$icon' ");

    return List.generate(result.length, (i) {
      return _fromJsonQuery(result[i]);
    });
  }
}
