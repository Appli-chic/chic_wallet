import 'package:chic_wallet/localization/app_translations.dart';
import 'package:chic_wallet/providers/theme_provider.dart';
import 'package:chic_wallet/ui/components/bank_body.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class ChartScreen extends StatefulWidget {
  @override
  _ChartScreenState createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen>
    with AutomaticKeepAliveClientMixin<ChartScreen> {
  ThemeProvider _themeProvider;

  List<charts.Series> _seriesList;

  @override
  void initState() {
    _loadChartsData();
    super.initState();
  }

  _loadChartsData() {
    final data = [
      LinearTransactions(0, 100.0, charts.Color.fromHex(code: "#fe3523")),
      LinearTransactions(1, 75.0, charts.Color.fromHex(code: "#2a828f")),
      LinearTransactions(2, 25.0, charts.Color.fromHex(code: "#29514c")),
      LinearTransactions(3, 5.0, charts.Color.fromHex(code: "#2a4f8f")),
    ];

    var series = charts.Series<LinearTransactions, int>(
      id: 'Transactions',
      domainFn: (LinearTransactions sales, _) => sales.category,
      measureFn: (LinearTransactions sales, _) => sales.price,
      data: data,
      colorFn: (LinearTransactions sales, _) => sales.color,
    );

    setState(() {
      _seriesList = [series];
    });
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
              child: Container(
                height: 300,
                child: charts.PieChart(
                  _seriesList,
                  animate: true,
                  defaultRenderer: charts.ArcRendererConfig(arcWidth: 98),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class LinearTransactions {
  final int category;
  final double price;
  final charts.Color color;

  LinearTransactions(this.category, this.price, this.color);
}
