import 'package:intl/intl.dart';

class Bank {
  static const tableName = "banks";

  int id;
  String bankName;
  String username;
  double money;
  String cardType;
  DateTime expirationDate;
  String currency;

  Bank({
    this.id,
    this.bankName,
    this.username,
    this.money,
    this.cardType,
    this.expirationDate,
    this.currency,
  });

  factory Bank.fromJson(Map<String, dynamic> json) {
    return Bank(
      id: json['id'],
      bankName: json['bank_mame'],
      username: json['username'],
      money: json['money'],
      cardType: json['card_type'],
      expirationDate: json['expiration_date'],
      currency: json['currency'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['bank_mame'] = this.bankName;
    data['username'] = this.username;
    data['money'] = this.money;
    data['card_type'] = this.cardType;
    data['expiration_date'] = this.expirationDate;
    data['currency'] = this.currency;
    return data;
  }

  Map<String, dynamic> toMap() {
    var dateFormatter = new DateFormat('yyyy-MM-dd HH:mm:ss');
    String expirationDateString = dateFormatter.format(this.expirationDate);

    return {
      'id': this.id,
      'bankName': this.bankName,
      'username': this.username,
      'money': this.money,
      'cardType': this.cardType,
      'expirationDate': expirationDateString,
      'currency': currency,
    };
  }
}
