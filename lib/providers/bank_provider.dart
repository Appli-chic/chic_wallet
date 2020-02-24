import 'package:chic_wallet/models/db/bank.dart';
import 'package:chic_wallet/models/db/transaction.dart';
import 'package:flutter/material.dart';

class BankProvider with ChangeNotifier {
  List<Bank> _banks = [];
  List<Transaction> _transactions = [];
  Bank _selectedBank;
  int _index = 0;
  bool _needToReloadHome = false;
  bool _needToReloadChart = false;

  setBanks(List<Bank> banks) {
    _banks = banks;

    if (_index > _banks.length) {
      _index = 0;
      selectBank(banks[_index].id);
    }

    notifyListeners();
  }

  setTransactions(List<Transaction> transactions) {
    _transactions = transactions;
    notifyListeners();
  }

  selectBank(int bankId) {
    var banks = _banks.where((bank) => bank.id == bankId).toList();

    if (banks.isNotEmpty) {
      _selectedBank = banks[0];
      _index = _banks.indexOf(banks[0]);
    }

    notifyListeners();
  }

  askReloadData() {
    _needToReloadHome = true;
    _needToReloadChart = true;
    notifyListeners();
  }

  homePageReloaded() {
    _needToReloadHome = false;
  }

  chartPageReloaded() {
    _needToReloadChart = false;
  }

  List<Bank> get banks => _banks;

  List<Transaction> get transactions => _transactions;

  Bank get selectedBank => _selectedBank;

  bool get needToReloadHome => _needToReloadHome;

  bool get needToReloadChart => _needToReloadChart;

  int get index => _index;
}
