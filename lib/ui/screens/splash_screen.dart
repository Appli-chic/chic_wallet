import 'package:chic_wallet/providers/bank_provider.dart';
import 'package:chic_wallet/providers/theme_provider.dart';
import 'package:chic_wallet/services/bank_service.dart';
import 'package:chic_wallet/services/transaction_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  ThemeProvider _themeProvider;
  BankProvider _bankProvider;
  BankService _bankService;
  TransactionService _transactionService;

  didChangeDependencies() {
    super.didChangeDependencies();

    if (_bankProvider == null) {
      _bankProvider = Provider.of<BankProvider>(context, listen: true);
    }

    if (_transactionService == null) {
      _transactionService =
          Provider.of<TransactionService>(context, listen: true);
    }

    if (_bankService == null) {
      _bankService = Provider.of<BankService>(context);

      _loadAllBanks().then((_) async {
        _bankProvider.askToReloadData(true);
        await _loadTransactions();

        Navigator.pushReplacementNamed(context, '/');
      });
    }
  }

  _loadTransactions() async {
    _bankProvider.askToReloadData(false);

    if (_bankProvider.selectedBank != null) {
      _bankProvider.setTransactions(await _transactionService
          .getAllByBankId(_bankProvider.selectedBank.id));
    }
  }

  Future<void> _loadAllBanks() async {
    var banks = await _bankService.getAll();
    _bankProvider.setBanks(banks);

    if (_bankProvider.selectedBank == null && banks.isNotEmpty) {
      _bankProvider.selectBank(banks[0].id);
    }
  }

  /// Displays Chic Wallet's logo in the top of this page
  Widget _displayLogo() {
    return Center(
      child: Container(
        width: 150,
        height: 150,
        child: Placeholder(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    _themeProvider = Provider.of<ThemeProvider>(context, listen: true);

    return Container(
      color: _themeProvider.backgroundColor,
      child: _displayLogo(),
    );
  }
}
