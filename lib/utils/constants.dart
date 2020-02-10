import 'package:chic_wallet/models/db/bank.dart';
import 'package:flutter/material.dart';

const String KEY_THEME = "THEME";
const String DATABASE_NAME = "chic_wallet.db";

const List<String> LIST_CARD_TYPES = ["Visa", "Mastercard"];

const List<String> LIST_CURRENCIES_NAMES = ["Dollar", "Euro"];
const List<String> LIST_CURRENCIES = ["\$", "€"];

const IconData BASKET_ICON = const IconData(0xe800, fontFamily: 'Cart');

String displaysCurrency(Bank bank) {
  var index = LIST_CURRENCIES_NAMES.indexOf(bank.currency);
  return LIST_CURRENCIES[index];
}