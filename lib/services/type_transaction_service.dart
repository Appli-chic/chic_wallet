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
      return TypeTransaction(
        id: result[i]['id'],
        title: result[i]['title'],
        color: result[i]['color'],
        iconName: result[i]['icon_name'],
      );
    });
  }
}
