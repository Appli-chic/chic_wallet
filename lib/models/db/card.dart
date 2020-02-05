class CWCard {
  int id;
  String bankName;
  String username;
  double money;
  String cardType;
  DateTime expirationDate;

  CWCard({
    this.id,
    this.bankName,
    this.username,
    this.money,
    this.cardType,
    this.expirationDate,
  });

  factory CWCard.fromJson(Map<String, dynamic> json) {
    return CWCard(
      id: json['id'],
      bankName: json['bank_mame'],
      username: json['username'],
      money: json['money'],
      cardType: json['card_type'],
      expirationDate: json['expiration_date'],
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
    return data;
  }
}