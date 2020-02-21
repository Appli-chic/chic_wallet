import 'package:chic_wallet/models/db/bank.dart';
import 'package:chic_wallet/models/db/transaction.dart';
import 'package:chic_wallet/models/db/type_transaction.dart';
import 'package:chic_wallet/models/env.dart';
import 'package:chic_wallet/utils/sqlite.dart';
import 'package:http/http.dart';

class TransactionService {
  Client client = Client();
  final Env env;

  TransactionService({
    this.env,
  });

  Future<void> save(Transaction transaction) async {
    await addRow(Transaction.tableName, transaction.toMap());
  }

  Transaction _fromJsonQuery(dynamic json) {
    var date = DateTime.parse(json['date']);

    return Transaction(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      price: json['price'],
      date: date,
      typeTransaction: TypeTransaction(
        id: json['tt_id'],
        title: json['tt_title'],
        color: json['tt_color'],
        iconName: json['tt_icon_name'],
      ),
      bank: Bank(
        id: json['bank_id'],
        currency: json['bank_currency'],
      ),
    );
  }

  Future<List<Transaction>> getTransactionsForTheMonth(
      int bankId, DateTime date) async {
    var result = await sqlQuery(
        "SELECT ${Transaction.tableName}.id, ${Transaction.tableName}.title, ${Transaction.tableName}.description, "
        "${Transaction.tableName}.price, ${Transaction.tableName}.price, ${Transaction.tableName}.date, "
        "${TypeTransaction.tableName}.id as tt_id, ${TypeTransaction.tableName}.title as tt_title, ${TypeTransaction.tableName}.color as tt_color, "
        "${TypeTransaction.tableName}.icon_name as tt_icon_name, ${Bank.tableName}.id as bank_id, ${Bank.tableName}.currency as bank_currency "
        "FROM ${Transaction.tableName} "
        "left join ${TypeTransaction.tableName} ON ${TypeTransaction.tableName}.id = ${Transaction.tableName}.type_transaction_id "
        "left join ${Bank.tableName} ON ${Bank.tableName}.id = ${Transaction.tableName}.bank_id "
        "where ${Bank.tableName}.id = $bankId "
        "and ${Transaction.tableName}.price < 0 "
        "and strftime('%m', ${Transaction.tableName}.date) = '${date.month < 10 ? "0${date.month}" : date.month}' "
        "and strftime('%Y', ${Transaction.tableName}.date) = '${date.year}' ");

    return List.generate(result.length, (i) {
      return _fromJsonQuery(result[i]);
    });
  }

  Future<List<Transaction>> getAllByBankId(int bankId) async {
    var result = await sqlQuery(
        "SELECT ${Transaction.tableName}.id, ${Transaction.tableName}.title, ${Transaction.tableName}.description, "
        "${Transaction.tableName}.price, ${Transaction.tableName}.price, ${Transaction.tableName}.date, "
        "${TypeTransaction.tableName}.id as tt_id, ${TypeTransaction.tableName}.title as tt_title, ${TypeTransaction.tableName}.color as tt_color, "
        "${TypeTransaction.tableName}.icon_name as tt_icon_name, ${Bank.tableName}.id as bank_id, ${Bank.tableName}.currency as bank_currency "
        "FROM ${Transaction.tableName} "
        "left join ${TypeTransaction.tableName} ON ${TypeTransaction.tableName}.id = ${Transaction.tableName}.type_transaction_id "
        "left join ${Bank.tableName} ON ${Bank.tableName}.id = ${Transaction.tableName}.bank_id "
        "where ${Bank.tableName}.id = $bankId "
        "order by ${Transaction.tableName}.date desc ");

    return List.generate(result.length, (i) {
      return _fromJsonQuery(result[i]);
    });
  }
}
