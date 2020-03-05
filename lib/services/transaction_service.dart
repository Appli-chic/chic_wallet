import 'package:chic_wallet/models/db/bank.dart';
import 'package:chic_wallet/models/db/transaction.dart';
import 'package:chic_wallet/models/db/type_transaction.dart';
import 'package:chic_wallet/models/env.dart';
import 'package:chic_wallet/utils/sqlite.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';

const GENERAL_SELECT = "SELECT t1.id, t1.title, t1.description, "
    "t1.price, t1.price, t1.date, "
    "${TypeTransaction.tableName}.id as tt_id, ${TypeTransaction.tableName}.title as tt_title, ${TypeTransaction.tableName}.color as tt_color, "
    "${TypeTransaction.tableName}.icon_name as tt_icon_name, ${Bank.tableName}.id as bank_id, ${Bank.tableName}.currency as bank_currency, "
    "t1.nb_day_repeat, t1.index_type_repeat, t1.start_subscription_date, "
    "t1.transaction_id, t2.nb_day_repeat as t_nb_day_repeat, t2.index_type_repeat as t_index_type_repeat, t2.start_subscription_date as t_start_subscription_date "
    "FROM ${Transaction.tableName} as t1 "
    "left join ${TypeTransaction.tableName} ON ${TypeTransaction.tableName}.id = t1.type_transaction_id "
    "left join ${Transaction.tableName} as t2 ON t1.transaction_id = t2.id "
    "left join ${Bank.tableName} ON ${Bank.tableName}.id = t1.bank_id ";

class TransactionService {
  static final int pagination = 10;

  Client client = Client();
  final Env env;

  TransactionService({
    this.env,
  });

  Future<void> update(Transaction transaction) async {
    var dateFormatter = new DateFormat('yyyy-MM-dd HH:mm:ss');
    String dateString = dateFormatter.format(transaction.date);
    String startSubscriptionDateString;
    int transactionId;

    if (transaction.transaction != null) {
      transactionId = transaction.transaction.id;
    }

    if (transaction.startSubscriptionDate != null) {
      startSubscriptionDateString =
          dateFormatter.format(transaction.startSubscriptionDate);
    }

    await sqlQuery("UPDATE ${Transaction.tableName} "
        "SET title = '${transaction.title}', description = '${transaction.description}', "
        "price = ${transaction.price}, date = '$dateString', "
        "nb_day_repeat = ${transaction.nbDayRepeat}, index_type_repeat = ${transaction.indexTypeRepeat},"
        "start_subscription_date = '$startSubscriptionDateString', bank_id = ${transaction.bank.id}, "
        "type_transaction_id = ${transaction.typeTransaction.id}, transaction_id = $transactionId "
        "WHERE ${Transaction.tableName}.id = ${transaction.id} ");
  }

  Future<void> delete(Transaction transaction) async {
    await sqlQuery(
        "DELETE FROM ${Transaction.tableName} WHERE ${Transaction.tableName}.id = ${transaction.id}");
  }

  Future<List<Transaction>> getSubscriptionsByBankId(Bank bank) async {
    var result = await sqlQuery(GENERAL_SELECT +
        "where ${Bank.tableName}.id = ${bank.id} "
            "and t1.nb_day_repeat IS NOT NULL ");

    return List.generate(result.length, (i) {
      return _fromJsonQuery(result[i]);
    });
  }

  Future<List<Transaction>> getTransactionsLinkedToSubscription(
      int transactionId) async {
    var result = await sqlQuery(
        GENERAL_SELECT + "where t1.transaction_id = $transactionId ");

    return List.generate(result.length, (i) {
      return _fromJsonQuery(result[i]);
    });
  }

  Future<List<Transaction>> addTransactionsFromSubscriptions(
      List<Bank> banks) async {
    var transactionsAdded = List<Transaction>();

    for (var bank in banks) {
      var subscriptions = await getSubscriptionsByBankId(bank);

      for (var subscription in subscriptions) {
        var transactions =
            await getTransactionsLinkedToSubscription(subscription.id);

        var result = await _createTransactionsFromSubscription(
            subscription, transactions);
        transactionsAdded.addAll(result);
      }
    }

    return transactionsAdded;
  }

  Future<List<Transaction>> addTransactionsFromSubscription(
      Transaction subscription) async {
    var transactions =
        await getTransactionsLinkedToSubscription(subscription.id);

    return await _createTransactionsFromSubscription(
        subscription, transactions);
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
    var subscriptionDate2;

    if (json['start_subscription_date'] != null &&
        json['start_subscription_date'] != "null") {
      subscriptionDate = DateTime.parse(json['start_subscription_date']);
    }

    if (json['t_start_subscription_date'] != null &&
        json['t_start_subscription_date'] != "null") {
      subscriptionDate2 = DateTime.parse(json['t_start_subscription_date']);
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
        nbDayRepeat: json['t_nb_day_repeat'],
        indexTypeRepeat: json['t_index_type_repeat'],
        startSubscriptionDate: subscriptionDate2,
      ),
    );
  }

  Future<List<Transaction>> getSubscriptionsForTheMonth(
      int bankId, DateTime date) async {
    var result = await sqlQuery(GENERAL_SELECT +
        "where ${Bank.tableName}.id = $bankId "
            "and t1.transaction_id IS NOT NULL "
            "and t1.price < 0 "
            "and strftime('%m', t1.date) = '${date.month < 10 ? "0${date.month}" : date.month}' "
            "and strftime('%Y', t1.date) = '${date.year}' ");

    return List.generate(result.length, (i) {
      return _fromJsonQuery(result[i]);
    });
  }

  Future<List<Transaction>> getTransactionsForTheMonth(
      int bankId, DateTime date) async {
    var result = await sqlQuery(GENERAL_SELECT +
        "where ${Bank.tableName}.id = $bankId "
            "and t1.nb_day_repeat IS NULL "
            "and t1.price < 0 "
            "and strftime('%m', t1.date) = '${date.month < 10 ? "0${date.month}" : date.month}' "
            "and strftime('%Y', t1.date) = '${date.year}' ");

    return List.generate(result.length, (i) {
      return _fromJsonQuery(result[i]);
    });
  }

  Future<List<Transaction>> getAllByBankIdPaged(int bankId, int page) async {
    var result = await sqlQuery(GENERAL_SELECT +
        "where ${Bank.tableName}.id = $bankId "
            "and t1.nb_day_repeat IS NULL "
            "order by t1.date desc "
            "limit $pagination "
            "offset ${page * pagination}");

    return List.generate(result.length, (i) {
      return _fromJsonQuery(result[i]);
    });
  }

  Future<List<Transaction>> getAllByBankIdAndTypeTransactionId(
      int bankId, int typeTransactionId) async {
    var result = await sqlQuery(GENERAL_SELECT +
        "where ${Bank.tableName}.id = $bankId "
            "and tt_id = $typeTransactionId "
            "order by t1.date asc ");

    return List.generate(result.length, (i) {
      return _fromJsonQuery(result[i]);
    });
  }

  Future<List<Transaction>> getAllByBankId(int bankId) async {
    var result = await sqlQuery(GENERAL_SELECT +
        "where ${Bank.tableName}.id = $bankId "
            "and t1.nb_day_repeat IS NULL "
            "order by t1.date asc ");

    return List.generate(result.length, (i) {
      return _fromJsonQuery(result[i]);
    });
  }

  Future<List<Transaction>> getAllFromSubscriptionAndTheSubscription(
      int subscriptionId) async {
    var result = await sqlQuery(GENERAL_SELECT +
        "where t2.id = $subscriptionId "
            "or t1.id = $subscriptionId "
            "order by t1.date asc ");

    return List.generate(result.length, (i) {
      return _fromJsonQuery(result[i]);
    });
  }
}
