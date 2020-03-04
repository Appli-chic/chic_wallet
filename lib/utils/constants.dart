import 'package:chic_wallet/models/db/bank.dart';
import 'package:flutter/material.dart';

const String KEY_THEME = "THEME";
const String KEY_LOCAL_AUTH = "LOCAL_AUTH";
const String DATABASE_NAME = "chic_wallet.db";

const List<String> LIST_CARD_TYPES = ["Visa", "Mastercard"];

const List<String> LIST_CURRENCIES_NAMES = [
  "Dollar",
  "Euro",
  "Pound",
  "Japanese yen",
  "Chinese yuan",
  "Korean won",
  "Russian ruble",
  "Indian rupee",
  "peso",
  "Afghan afghani",
  "Thai baht",
  "Ghanaian cedi",
  "Costa Rican colón",
  "Algerian dinar",
  "Bahraini dinar",
  "Iraqi dinar",
  "Jordanian dinar",
  "Libyan dinar",
  "Tunisian dinar",
  "Moroccan dirham",
  "United Arab Emirates dirham",
  "Franc",
  "Ukrainian hryvnia",
  "Faroese króna",
  "Icelandic króna",
  "Swedish krona",
  "Danish krone",
  "Norwegian krone",
  "Croatian kuna",
  "Turkish lira",
  "Nigerian naira",
];
const List<String> LIST_CURRENCIES = [
  "\$",
  "€",
  "£",
  "¥",
  "¥",
  "₩",
  "₽",
  "₹",
  "\$",
  "؋",
  "฿",
  "₵",
  "₡",
  "د.ج",
  ".د.ب",
  "ع.د",
  "د.ا",
  "ل.د",
  "د.ت",
  "د.م.",
  "د.إ",
  "Fr",
  "₴",
  "kr",
  "kr",
  "kr",
  "kr",
  "kr",
  "kn",
  "₺",
  "₦",
];

const List<int> LIST_REPEAT_VALUE = [0, 1];
const List<String> LIST_REPEAT_NAMES = ['months', 'years'];

const IconData BASKET_ICON = const IconData(0xe800, fontFamily: 'Cart');

String displaysCurrency(Bank bank) {
  var index = LIST_CURRENCIES_NAMES.indexOf(bank.currency);
  return LIST_CURRENCIES[index];
}
