import 'package:chic_wallet/localization/app_translations.dart';
import 'package:chic_wallet/providers/theme_provider.dart';
import 'package:chic_wallet/ui/components/bank_body.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChartScreen extends StatefulWidget {
  @override
  _ChartScreenState createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen> with AutomaticKeepAliveClientMixin<ChartScreen> {
  ThemeProvider _themeProvider;

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
      child: Container(),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
