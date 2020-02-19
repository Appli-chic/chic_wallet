import 'package:chic_wallet/localization/app_translations.dart';
import 'package:chic_wallet/models/db/type_transaction.dart';
import 'package:chic_wallet/providers/bank_provider.dart';
import 'package:chic_wallet/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:provider/provider.dart';

class CircleChart extends StatefulWidget {
  @override
  _CircleChartState createState() => _CircleChartState();
}

class _CircleChartState extends State<CircleChart> {
  ThemeProvider _themeProvider;
  List<charts.Series> _seriesList;
  BankProvider _bankProvider;

  _loadChartsData() {
    List<LinearTransactions> data = [];

    for (var transaction in _bankProvider.transactions) {
      var transactionTypeData = data
          .where((d) => d.category == transaction.typeTransaction.id)
          .toList();

      if (transactionTypeData.isEmpty) {
        var color = TypeTransaction.getColor(transaction.typeTransaction.color);

        data.add(LinearTransactions(
          transaction.typeTransaction.id,
          transaction.price,
          charts.Color(r: color.red, g: color.green, b: color.blue, a: color.alpha),
        ));
      } else {
        transactionTypeData[0].price += transaction.price;
      }
    }

    var series = charts.Series<LinearTransactions, int>(
      id: 'Transactions',
      domainFn: (LinearTransactions sales, _) => sales.category,
      measureFn: (LinearTransactions sales, _) => sales.price,
      data: data,
      colorFn: (LinearTransactions sales, _) => sales.color,
    );

    if (data.isEmpty) {
      setState(() {
        _seriesList = [];
      });
    } else {
      setState(() {
        _seriesList = [series];
      });
    }
  }

  Widget _displaysChart() {
    return Container(
      height: 300,
      child: charts.PieChart(
        _seriesList,
        animate: true,
        defaultRenderer: charts.ArcRendererConfig(arcWidth: 98),
      ),
    );
  }

  Widget _displaysEmptyData() {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
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
    );
  }

  @override
  Widget build(BuildContext context) {
    _themeProvider = Provider.of<ThemeProvider>(context, listen: true);
    _bankProvider = Provider.of<BankProvider>(context, listen: true);
    _loadChartsData();

    if (_seriesList.isEmpty) {
      return _displaysEmptyData();
    } else {
      return _displaysChart();
    }
  }
}

class LinearTransactions {
  final int category;
  double price;
  final charts.Color color;

  LinearTransactions(this.category, this.price, this.color);
}
