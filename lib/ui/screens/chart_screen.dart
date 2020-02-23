import 'package:chic_wallet/localization/app_translations.dart';
import 'package:chic_wallet/models/db/type_transaction.dart';
import 'package:chic_wallet/providers/bank_provider.dart';
import 'package:chic_wallet/providers/theme_provider.dart';
import 'package:chic_wallet/services/transaction_service.dart';
import 'package:chic_wallet/ui/components/bank_body.dart';
import 'package:chic_wallet/ui/components/circle_chart.dart';
import 'package:chic_wallet/ui/components/transaction_type_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TransactionTypeGroupData {
  int idType;
  String typeName;
  double amount;
  Color color;
  IconData icon;

  TransactionTypeGroupData({
    this.idType,
    this.typeName,
    this.amount,
    this.color,
    this.icon,
  });
}

class ChartScreen extends StatefulWidget {
  @override
  _ChartScreenState createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen>
    with AutomaticKeepAliveClientMixin<ChartScreen> {
  ThemeProvider _themeProvider;
  BankProvider _bankProvider;
  TransactionService _transactionService;

  List<TransactionTypeGroupData> _transactionsGroup = [];

  _loadMonthTransactions() async {
    _transactionsGroup = [];
    var transactions = await _transactionService.getTransactionsForTheMonth(
        _bankProvider.selectedBank.id, DateTime.now());

    for (var transaction in transactions) {
      var transactionTypeData = _transactionsGroup
          .where((d) => d.idType == transaction.typeTransaction.id)
          .toList();

      if (transactionTypeData.isEmpty) {
        var color = TypeTransaction.getColor(transaction.typeTransaction.color);

        _transactionsGroup.add(
          TransactionTypeGroupData(
            idType: transaction.typeTransaction.id,
            typeName: transaction.typeTransaction.title,
            amount: transaction.price,
            color: color,
            icon: TypeTransaction.getIconData(
                transaction.typeTransaction.iconName),
          ),
        );
      } else {
        transactionTypeData[0].amount += transaction.price;
      }
    }
  }

  didChangeDependencies() {
    super.didChangeDependencies();

    if (_bankProvider == null) {
      _bankProvider = Provider.of<BankProvider>(context, listen: true);
    }

    if (_transactionService == null) {
      _transactionService =
          Provider.of<TransactionService>(context, listen: true);
      _loadMonthTransactions();
    }
  }

  @override
  Widget build(BuildContext context) {
    _themeProvider = Provider.of<ThemeProvider>(context, listen: true);

    return BankBody(
      height: 330,
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
      child: Container(
        margin: EdgeInsets.only(top: 330, left: 16, right: 16),
        child: Column(
          children: <Widget>[
            Center(
              child: CircleChart(
                transactionsGroup: _transactionsGroup,
              ),
            ),
            ListView.builder(
              padding: EdgeInsets.only(top: 0, bottom: 20),
              physics: NeverScrollableScrollPhysics(),
              itemCount: _transactionsGroup.length,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                return TransactionTypeCard(
                  bank: _bankProvider.selectedBank,
                  transactionTypeGroupData: _transactionsGroup[index],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
