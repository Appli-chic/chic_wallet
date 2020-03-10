import 'package:chic_wallet/localization/app_translations.dart';
import 'package:chic_wallet/models/db/bank.dart';
import 'package:chic_wallet/providers/bank_provider.dart';
import 'package:chic_wallet/providers/theme_provider.dart';
import 'package:chic_wallet/services/bank_service.dart';
import 'package:chic_wallet/services/transaction_service.dart';
import 'package:chic_wallet/utils/constants.dart';
import 'package:chic_wallet/utils/sqlite.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:local_auth/local_auth.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  ThemeProvider _themeProvider;
  BankProvider _bankProvider;
  BankService _bankService;
  TransactionService _transactionService;

  final LocalAuthentication auth = LocalAuthentication();
  final storage = new FlutterSecureStorage();

  didChangeDependencies() {
    super.didChangeDependencies();

    if (_bankProvider == null) {
      _bankProvider = Provider.of<BankProvider>(context, listen: true);
    }

    if (_transactionService == null) {
      _transactionService = Provider.of<TransactionService>(context);
    }

    if (_bankService == null) {
      _bankService = Provider.of<BankService>(context);
      _checkIdentity();
    }
  }

  _checkIdentity() async {
    await openCWDatabase();
    bool isAuthActivated = await storage.read(key: KEY_LOCAL_AUTH) == 'true';

    if (isAuthActivated) {
      // If auth is activated then we check
      bool canCheckBiometrics = await auth.canCheckBiometrics;
      bool _isAuthenticated = false;

      if (canCheckBiometrics) {
        var availableBiometrics = await auth.getAvailableBiometrics();

        if (availableBiometrics.contains(BiometricType.fingerprint)) {
          _isAuthenticated = await auth.authenticateWithBiometrics(
            localizedReason: AppTranslations.of(context).text("scan_finger"),
            useErrorDialogs: true,
          );
        } else {
          _isAuthenticated = true;
        }
      } else {
        _isAuthenticated = true;
      }

      if (_isAuthenticated) {
        _loadData();
      } else {
        _checkIdentity();
      }
    } else {
      _loadData();
    }
  }

  _loadData() async {
    var banks = await _loadAllBanks();
    await _addTransactionsFromSubscriptions(banks);
    await _loadTransactions();

    Navigator.pushReplacementNamed(context, '/');
  }

  _addTransactionsFromSubscriptions(List<Bank> banks) async {
    if (_bankProvider.selectedBank != null) {
      var transactionsAdded =
          await _transactionService.addTransactionsFromSubscriptions(banks);

      for (var transaction in transactionsAdded) {
        var bank = _bankProvider.banks
            .where((b) => b.id == transaction.bank.id)
            .toList()[0];
        bank.money += transaction.price;
        await _bankService.update(bank);
      }
    }
  }

  _loadTransactions() async {
    if (_bankProvider.selectedBank != null) {
      _bankProvider.setTransactions(await _transactionService
          .getAllByBankIdPaged(_bankProvider.selectedBank.id, 0));
    }
  }

  Future<List<Bank>> _loadAllBanks() async {
    var banks = await _bankService.getAll();
    _bankProvider.setBanks(banks);

    if (_bankProvider.selectedBank == null && banks.isNotEmpty) {
      _bankProvider.selectBank(banks[0].id);
    }

    return banks;
  }

  /// Displays Chic Wallet's logo in the top of this page
  Widget _displayLogo() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 150,
          height: 150,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset('assets/logo.png'),
          ),
        ),
        Theme(
          data: ThemeData(
            cupertinoOverrideTheme:
                CupertinoThemeData(brightness: Brightness.dark),
          ),
          child: Container(
            margin: EdgeInsets.only(top: 20),
            child: CupertinoActivityIndicator(animating: true, radius: 20),
          ),
        ),
      ],
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
