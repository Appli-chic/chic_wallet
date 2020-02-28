import 'package:chic_wallet/models/db/bank.dart';
import 'package:chic_wallet/models/db/transaction.dart';
import 'package:chic_wallet/models/db/type_transaction.dart';
import 'package:chic_wallet/models/env.dart';
import 'package:chic_wallet/utils/sqlite.dart';
import 'package:http/http.dart';

class TransactionService {
  static final int pagination = 10;

  Client client = Client();
  final Env env;

  TransactionService({
    this.env,
  });

  Future<List<Transaction>> getSubscriptionsByBankId(Bank bank) async {
    var result = await sqlQuery(
        "SELECT ${Transaction.tableName}.id, ${Transaction.tableName}.title, ${Transaction.tableName}.description, "
        "${Transaction.tableName}.price, ${Transaction.tableName}.price, ${Transaction.tableName}.date, "
        "${TypeTransaction.tableName}.id as tt_id, ${TypeTransaction.tableName}.title as tt_title, ${TypeTransaction.tableName}.color as tt_color, "
        "${TypeTransaction.tableName}.icon_name as tt_icon_name, ${Bank.tableName}.id as bank_id, ${Bank.tableName}.currency as bank_currency, "
        "${Transaction.tableName}.nb_day_repeat, ${Transaction.tableName}.index_type_repeat, ${Transaction.tableName}.start_subscription_date, "
        "${Transaction.tableName}.transaction_id "
        "FROM ${Transaction.tableName} "
        "left join ${TypeTransaction.tableName} ON ${TypeTransaction.tableName}.id = ${Transaction.tableName}.type_transaction_id "
        "left join ${Bank.tableName} ON ${Bank.tableName}.id = ${Transaction.tableName}.bank_id "
        "where ${Bank.tableName}.id = ${bank.id} "
        "and nb_day_repeat IS NOT NULL ");

    return List.generate(result.length, (i) {
      return _fromJsonQuery(result[i]);
    });
  }

  Future<List<Transaction>> getTransactionsLinkedToSubscription(
      int transactionId) async {
    var result = await sqlQuery(
        "SELECT ${Transaction.tableName}.id, ${Transaction.tableName}.title, ${Transaction.tableName}.description, "
        "${Transaction.tableName}.price, ${Transaction.tableName}.price, ${Transaction.tableName}.date, "
        "${TypeTransaction.tableName}.id as tt_id, ${TypeTransaction.tableName}.title as tt_title, ${TypeTransaction.tableName}.color as tt_color, "
        "${TypeTransaction.tableName}.icon_name as tt_icon_name, ${Bank.tableName}.id as bank_id, ${Bank.tableName}.currency as bank_currency, "
        "${Transaction.tableName}.nb_day_repeat, ${Transaction.tableName}.index_type_repeat, ${Transaction.tableName}.start_subscription_date, "
        "${Transaction.tableName}.transaction_id "
        "FROM ${Transaction.tableName} "
        "left join ${TypeTransaction.tableName} ON ${TypeTransaction.tableName}.id = ${Transaction.tableName}.type_transaction_id "
        "left join ${Bank.tableName} ON ${Bank.tableName}.id = ${Transaction.tableName}.bank_id "
        "where ${Transaction.tableName}.transaction_id = $transactionId ");

    return List.generate(result.length, (i) {
      return _fromJsonQuery(result[i]);
    });
  }

  Future<List<Transaction>> addTransactionsFromSubscriptions(List<Bank> banks) async {
    var transactionsAdded = List<Transaction>();

    for (var bank in banks) {
      var subscriptions = await getSubscriptionsByBankId(bank);

      for (var subscription in subscriptions) {
        var transactions =
            await getTransactionsLinkedToSubscription(subscription.id);

        var result = await _createTransactionsFromSubscription(subscription, transactions);
        transactionsAdded.addAll(result);
      }
    }

    return transactionsAdded;
  }

  Future<List<Transaction>> addTransactionsFromSubscription(Transaction subscription) async {
    var transactions =
        await getTransactionsLinkedToSubscription(subscription.id);

    return await _createTransactionsFromSubscription(subscription, transactions);
  }

  Future<List<Transaction>> _createTransactionsFromSubscription(
      Transaction subscription, List<Transaction> transactions) async {
    var transactionAdded = List<Transaction>();
    var date = subscription.startSubscriptionDate;
    var today = DateTime.now();

    do {
      var doTransactionExist = false;

      for (var transaction in transactions) {
        if (transaction.date.year == date.year &&
            transaction.date.month == date.month &&
            transaction.date.day == date.day) {
          doTransactionExist = true;
        }
      }

      if (!doTransactionExist) {
        // Add a transaction
        var newTransaction = Transaction(
          title: subscription.title,
          description: subscription.description,
          price: subscription.price,
          date: date,
          typeTransaction: subscription.typeTransaction,
          bank: subscription.bank,
          transaction: subscription,
        );

        await save(newTransaction);
        transactionAdded.add(newTransaction);
      }

      // Add the time to repeat
      if (subscription.indexTypeRepeat == 0) {
        date = date.add(Duration(days: subscription.nbDayRepeat));
      } else if (subscription.indexTypeRepeat == 1) {
        date = date.add(Duration(days: subscription.nbDayRepeat * 7));
      } else if (subscription.indexTypeRepeat == 2) {
        date = DateTime(
            date.year, date.month + subscription.nbDayRepeat, date.day);
      } else if (subscription.indexTypeRepeat == 3) {
        date = DateTime(
            date.year + subscription.nbDayRepeat, date.month, date.day);
      }
    } while (date.millisecondsSinceEpoch < today.millisecondsSinceEpoch);

    return transactionAdded;
  }

  Future<int> save(Transaction transaction) async {
    return await addRow(Transaction.tableName, transaction.toMap());
  }

  Transaction _fromJsonQuery(dynamic json) {
    var date = DateTime.parse(json['date']);
    var subscriptionDate;

    if (json['start_subscription_date'] != null) {
      subscriptionDate = DateTime.parse(json['start_subscription_date']);
    }

    return Transaction(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      price: json['price'],
      date: date,
      nbDayRepeat: json['nb_day_repeat'],
      indexTypeRepeat: json['index_type_repeat'],
      startSubscriptionDate: subscriptionDate,
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
      transaction: Transaction(
        id: json['transaction_id'],
      ),
    );
  }

  Future<List<Transaction>> getTransactionsForTheMonth(
      int bankId, DateTime date) async {
    var result = await sqlQuery(
        "SELECT ${Transaction.tableName}.id, ${Transaction.tableName}.title, ${Transaction.tableName}.description, "
        "${Transaction.tableName}.price, ${Transaction.tableName}.price, ${Transaction.tableName}.date, "
        "${TypeTransaction.tableName}.id as tt_id, ${TypeTransaction.tableName}.title as tt_title, ${TypeTransaction.tableName}.color as tt_color, "
        "${TypeTransaction.tableName}.icon_name as tt_icon_name, ${Bank.tableName}.id as bank_id, ${Bank.tableName}.currency as bank_currency, "
        "${Transaction.tableName}.nb_day_repeat, ${Transaction.tableName}.index_type_repeat, ${Transaction.tableName}.start_subscription_date, "
        "${Transaction.tableName}.transaction_id "
        "FROM ${Transaction.tableName} "
        "left join ${TypeTransaction.tableName} ON ${TypeTransaction.tableName}.id = ${Transaction.tableName}.type_transaction_id "
        "left join ${Bank.tableName} ON ${Bank.tableName}.id = ${Transaction.tableName}.bank_id "
        "where ${Bank.tableName}.id = $bankId "
        "and nb_day_repeat IS NULL "
        "and ${Transaction.tableName}.price < 0 "
        "and strftime('%m', ${Transaction.tableName}.date) = '${date.month < 10 ? "0${date.month}" : date.month}' "
        "and strftime('%Y', ${Transaction.tableName}.date) = '${date.year}' ");

    return List.generate(result.length, (i) {
      return _fromJsonQuery(result[i]);
    });
  }

  Future<List<Transaction>> getAllByBankIdPaged(int bankId, int page) async {
    var result = await sqlQuery(
        "SELECT ${Transaction.tableName}.id, ${Transaction.tableName}.title, ${Transaction.tableName}.description, "
        "${Transaction.tableName}.price, ${Transaction.tableName}.price, ${Transaction.tableName}.date, "
        "${TypeTransaction.tableName}.id as tt_id, ${TypeTransaction.tableName}.title as tt_title, ${TypeTransaction.tableName}.color as tt_color, "
        "${TypeTransaction.tableName}.icon_name as tt_icon_name, ${Bank.tableName}.id as bank_id, ${Bank.tableName}.currency as bank_currency, "
        "${Transaction.tableName}.nb_day_repeat, ${Transaction.tableName}.index_type_repeat, ${Transaction.tableName}.start_subscription_date, "
        "${Transaction.tableName}.transaction_id "
        "FROM ${Transaction.tableName} "
        "left join ${TypeTransaction.tableName} ON ${TypeTransaction.tableName}.id = ${Transaction.tableName}.type_transaction_id "
        "left join ${Bank.tableName} ON ${Bank.tableName}.id = ${Transaction.tableName}.bank_id "
        "where ${Bank.tableName}.id = $bankId "
        "and nb_day_repeat IS NULL "
        "order by ${Transaction.tableName}.date desc "
        "limit $pagination "
        "offset ${page * pagination}");

    return List.generate(result.length, (i) {
      return _fromJsonQuery(result[i]);
    });
  }
}
