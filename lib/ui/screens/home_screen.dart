import 'package:chic_wallet/localization/app_translations.dart';
import 'package:chic_wallet/models/db/transaction.dart';
import 'package:chic_wallet/providers/bank_provider.dart';
import 'package:chic_wallet/providers/theme_provider.dart';
import 'package:chic_wallet/services/transaction_service.dart';
import 'package:chic_wallet/ui/components/bank_body.dart';
import 'package:chic_wallet/ui/components/transaction_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ThemeProvider _themeProvider;
  List<Transaction> _transactions = [];
  TransactionService _transactionService;
  BankProvider _bankProvider;

  didChangeDependencies() {
    super.didChangeDependencies();

    if (_bankProvider == null) {
      _bankProvider = Provider.of<BankProvider>(context, listen: true);
    }

    if (_transactionService == null) {
      _transactionService =
          Provider.of<TransactionService>(context, listen: true);
    }

    if (_bankProvider.needsToLoadTransactions) {
      _loadTransactions();
    }
  }

  _loadTransactions() async {
    _bankProvider.askToReloadTransactions(false);
    _transactions = await _transactionService.getAll();
    setState(() {});
  }

  Widget _displaysTransactions() {
    if (_transactions.isNotEmpty) {
      return ListView.builder(
        padding: EdgeInsets.only(top: 0, bottom: 20),
        physics: NeverScrollableScrollPhysics(),
        itemCount: _transactions.length,
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          return TransactionCard(
            transaction: _transactions[index],
          );
        },
      );
    } else {
      return Container(
        margin: EdgeInsets.only(top: 60),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Image(
                image: AssetImage('assets/empty.png'),
                color: _themeProvider.textColor,
              ),
              Text(
                AppTranslations.of(context).text("home_screen_no_transactions"),
                style: TextStyle(
                  color: _themeProvider.textColor,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    _themeProvider = Provider.of<ThemeProvider>(context, listen: true);

    return BankBody(
      child: Container(
        margin: EdgeInsets.only(top: 450, left: 16, right: 16),
        child: _displaysTransactions(),
      ),
      label: Container(
        margin: EdgeInsets.only(bottom: 40, left: 16),
        child: Text(
          AppTranslations.of(context).text("home_screen_transactions"),
          style: TextStyle(
            color: _themeProvider.textColor,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
