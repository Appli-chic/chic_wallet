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

  Future<List<Transaction>> getAllByBankId(int bankId) async {
    var result = await sqlQuery(
        "SELECT ${Transaction.tableName}.id, ${Transaction.tableName}.title, ${Transaction.tableName}.description, "
        "${Transaction.tableName}.price, ${Transaction.tableName}.price, ${Transaction.tableName}.date, "
        "${TypeTransaction.tableName}.id as tt_id, ${TypeTransaction.tableName}.title as tt_title, ${TypeTransaction.tableName}.color as tt_color, "
        "${TypeTransaction.tableName}.icon_name as tt_icon_name, ${Bank.tableName}.id as bank_id, ${Bank.tableName}.currency as bank_currency "
        "FROM ${Transaction.tableName} "
        "left join ${TypeTransaction.tableName} ON ${TypeTransaction.tableName}.id = ${Transaction.tableName}.type_transaction_id "
        "left join ${Bank.tableName} ON ${Bank.tableName}.id = ${Transaction.tableName}.bank_id "
        "where ${Bank.tableName}.id = $bankId ");

    return List.generate(result.length, (i) {
      var date = DateTime.parse(result[i]['date']);

      return Transaction(
        id: result[i]['id'],
        title: result[i]['title'],
        description: result[i]['description'],
        price: result[i]['price'],
        date: date,
        typeTransaction: TypeTransaction(
          id: result[i]['tt_id'],
          title: result[i]['tt_title'],
          color: result[i]['tt_color'],
          iconName: result[i]['tt_icon_name'],
        ),
        bank: Bank(
          id: result[i]['bank_id'],
          currency: result[i]['bank_currency'],
        ),
      );
    });
  }
}
