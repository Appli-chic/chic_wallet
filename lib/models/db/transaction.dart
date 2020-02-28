import 'package:intl/intl.dart';

import 'bank.dart';
import 'type_transaction.dart';

class Transaction {
  static const tableName = "transactions";

  int id;
  String title;
  String description;
  double price;
  DateTime date;
  TypeTransaction typeTransaction;
  Bank bank;
  int nbDayRepeat;
  int indexTypeRepeat;
  DateTime startSubscriptionDate;
  Transaction transaction;

  Transaction({
    this.id,
    this.title,
    this.description,
    this.price,
    this.date,
    this.typeTransaction,
    this.bank,
    this.nbDayRepeat,
    this.indexTypeRepeat,
    this.startSubscriptionDate,
    this.transaction,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      price: json['price'],
      date: json['date'],
      typeTransaction: json['type_transaction'],
      bank: json['bank'],
      nbDayRepeat: json['nb_day_repeat'],
      indexTypeRepeat: json['index_type_repeat'],
      startSubscriptionDate: json['start_subscription_date'],
      transaction: json['transaction'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['price'] = this.price;
    data['date'] = this.date;
    data['type_transaction'] = this.typeTransaction;
    data['bank'] = this.bank;
    data['nb_day_repeat'] = this.nbDayRepeat;
    data['index_type_repeat'] = this.indexTypeRepeat;
    data['start_subscription_date'] = this.startSubscriptionDate;
    data['transaction'] = this.transaction;
    return data;
  }

  Map<String, dynamic> toMap() {
    var dateFormatter = new DateFormat('yyyy-MM-dd HH:mm:ss');
    String dateString = dateFormatter.format(this.date);
    String startSubscriptionDateString;
    int transactionId;

    if(this.transaction != null) {
      transactionId = this.transaction.id;
    }

    if(this.startSubscriptionDate != null) {
      startSubscriptionDateString = dateFormatter.format(this.startSubscriptionDate);
    }

    return {
      'id': this.id,
      'title': this.title,
      'description': this.description,
      'price': this.price,
      'date': dateString,
      'type_transaction_id': this.typeTransaction.id,
      'bank_id': this.bank.id,
      'nb_day_repeat': this.nbDayRepeat,
      'index_type_repeat': this.indexTypeRepeat,
      'start_subscription_date': startSubscriptionDateString,
      'transaction_id': transactionId,
    };
  }
}
