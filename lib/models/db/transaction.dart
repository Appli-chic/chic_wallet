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

  Transaction({
    this.id,
    this.title,
    this.description,
    this.price,
    this.date,
    this.typeTransaction,
    this.bank,
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
    return data;
  }

  Map<String, dynamic> toMap() {
    var dateFormatter = new DateFormat('yyyy-MM-dd HH:mm:ss');
    String dateString = dateFormatter.format(this.date);

    return {
      'id': this.id,
      'title': this.title,
      'description': this.description,
      'price': this.price,
      'date': dateString,
      'type_transaction_id': this.typeTransaction.id,
      'bank_id': this.bank.id,
    };
  }
}
