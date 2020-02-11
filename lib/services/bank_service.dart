import 'package:chic_wallet/models/db/bank.dart';
import 'package:chic_wallet/models/env.dart';
import 'package:chic_wallet/utils/sqlite.dart';
import 'package:http/http.dart';

class BankService {
  Client client = Client();
  final Env env;

  BankService({
    this.env,
  });

  Future<void> save(Bank bank) async {
    await addRow(Bank.tableName, bank.toMap());
  }

  Future<List<Bank>> getAll() async {
    var result = await getAllRows(Bank.tableName);

    return List.generate(result.length, (i) {
      var expirationDate = DateTime.parse(result[i]['expiration_date']);

      return Bank(
        id: result[i]['id'],
        bankName: result[i]['bank_name'],
        username: result[i]['username'],
        money: result[i]['money'],
        cardType: result[i]['card_type'],
        expirationDate: expirationDate,
        currency: result[i]['currency'],
      );
    });
  }
}
