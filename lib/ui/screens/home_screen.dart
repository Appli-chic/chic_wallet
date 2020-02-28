import 'package:chic_wallet/localization/app_translations.dart';
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

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin<HomeScreen> {
  ThemeProvider _themeProvider;
  TransactionService _transactionService;
  BankProvider _bankProvider;
  int _page = 0;

  _loadTransactions() async {
    if (_bankProvider.selectedBank != null) {
      var transactions = await _transactionService
          .getAllByBankIdPaged(_bankProvider.selectedBank.id, _page);
      _bankProvider.setTransactions(transactions);
    }
  }

  _loadMoreTransactions() async {
    if (_bankProvider.selectedBank != null) {
      var transactions = _bankProvider.transactions;
      var newTransactions = await _transactionService.getAllByBankIdPaged(
          _bankProvider.selectedBank.id, _page);

      transactions.addAll(newTransactions);
      _bankProvider.setTransactions(transactions);
    }
  }

  Widget _displaysTransactions() {
    if (_bankProvider.transactions.isNotEmpty) {
      return ListView.builder(
        padding: EdgeInsets.only(top: 0, bottom: 20),
        physics: NeverScrollableScrollPhysics(),
        itemCount: _bankProvider.transactions.length,
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          return TransactionCard(
            transaction: _bankProvider.transactions[index],
          );
        },
      );
    } else {
      return Container(
        margin: EdgeInsets.only(top: 45),
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
    _transactionService = Provider.of<TransactionService>(context);
    _bankProvider = Provider.of<BankProvider>(context, listen: true);

    if (_bankProvider.needToReloadHome) {
      _bankProvider.homePageReloaded();

      if (_bankProvider.didBankCardChanged) {
        _bankProvider.bankCardChangedDone();
        _page = 0;
      }

      _loadTransactions();
    }

    return NotificationListener(
      onNotification: (ScrollNotification scrollInfo) {
        if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
          _page++;
          _loadMoreTransactions();
        }

        return true;
      },
      child: BankBody(
        height: 310,
        child: Container(
          margin: EdgeInsets.only(top: 280, left: 16, right: 16),
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
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
