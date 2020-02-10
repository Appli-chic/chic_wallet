import 'package:chic_wallet/models/db/bank.dart';
import 'package:flutter/material.dart';

class BankProvider with ChangeNotifier {
  List<Bank> _banks = [];
  Bank _selectedBank;
  int _index = 0;

  setBanks(List<Bank> banks) {
    _banks = banks;

    if (_index > _banks.length) {
      _index = 0;
    }

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

  List<Bank> get banks => _banks;

  Bank get selectedBank => _selectedBank;

  int get index => _index;
}
