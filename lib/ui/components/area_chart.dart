import 'package:charts_flutter/flutter.dart' as charts;
import 'package:chic_wallet/localization/app_translations.dart';
import 'package:chic_wallet/models/db/transaction.dart';
import 'package:chic_wallet/providers/bank_provider.dart';
import 'package:chic_wallet/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AreaChart extends StatefulWidget {
  final List<Transaction> transactions;

  AreaChart({
    @required this.transactions,
  });

  @override
  _AreaChartState createState() => _AreaChartState();
}

class _AreaChartState extends State<AreaChart> {
  ThemeProvider _themeProvider;
  BankProvider _bankProvider;
  List<charts.Series<LinearSales, int>> _seriesList = [];

  _loadChartsData() {
    if (_bankProvider.selectedBank != null && widget.transactions.isNotEmpty) {
      List<LinearSales> dataList = [];

      var bankMoney = _bankProvider.selectedBank.money;
      var index = 0;
      var date = widget.transactions[0].date;
      var linearSale = LinearSales(index, 0);

      for (var transaction in widget.transactions) {
        if (transaction.date.year == date.year &&
            transaction.date.month == date.month &&
            transaction.date.day == date.day) {
          linearSale.money += transaction.price;
          bankMoney -= transaction.price;
        } else {
          dataList.add(linearSale);

          linearSale = LinearSales(index, transaction.price);
          date = transaction.date;
          bankMoney -= transaction.price;
          index++;
        }
      }

      dataList.add(linearSale);

      for (var data in dataList) {
        bankMoney = bankMoney + data.money;
        data.money = bankMoney;
      }

      charts.Color color = charts.Color(
        r: _themeProvider.textColor.red,
        g: _themeProvider.textColor.green,
        b: _themeProvider.textColor.blue,
        a: 200,
      );

      _seriesList = [
        charts.Series<LinearSales, int>(
          id: 'Transactions',
          colorFn: (_, __) => color,
          domainFn: (LinearSales sales, _) => sales.index,
          measureFn: (LinearSales sales, _) => sales.money,
          data: dataList,
        )..setAttribute(charts.rendererIdKey, 'customArea'),
      ];

      setState(() {});
    }
  }

  Widget _displaysChart() {
    final size = MediaQuery.of(context).size;

    return Container(
      height: 300,
      width: size.width,
      child: charts.LineChart(
        _seriesList,
        animate: true,
        domainAxis: charts.NumericAxisSpec(
          showAxisLine: false,
          renderSpec: charts.NoneRenderSpec(),
        ),
        primaryMeasureAxis: charts.NumericAxisSpec(
          showAxisLine: false,
          renderSpec: charts.NoneRenderSpec(),
        ),
        secondaryMeasureAxis: charts.NumericAxisSpec(
          showAxisLine: false,
          renderSpec: charts.NoneRenderSpec(),
        ),
        customSeriesRenderers: [
          charts.LineRendererConfig(
            customRendererId: 'customArea',
            includeArea: true,
          ),
        ],
      ),
    );
  }

  Widget _displaysEmptyData() {
    return Center(
      child: Padding(
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

class LinearSales {
  int index;
  double money;

  LinearSales(this.index, this.money);
}
