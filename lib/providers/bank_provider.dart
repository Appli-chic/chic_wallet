import 'package:chic_wallet/models/db/bank.dart';
import 'package:chic_wallet/models/db/transaction.dart';
import 'package:flutter/material.dart';

class BankProvider with ChangeNotifier {
  List<Bank> _banks = [];
  List<Transaction> _transactions = [];
  Bank _selectedBank;
  int _index = 0;

  bool _needsToLoadTransactions = false;

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

  askToReloadTransactions(bool hasToReload) {
    _needsToLoadTransactions = hasToReload;
  }

  List<Bank> get banks => _banks;

  List<Transaction> get transactions => _transactions;

  Bank get selectedBank => _selectedBank;

  int get index => _index;

  bool get needsToLoadTransactions => _needsToLoadTransactions;
}
