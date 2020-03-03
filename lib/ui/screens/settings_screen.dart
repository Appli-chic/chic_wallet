import 'package:chic_wallet/localization/app_translations.dart';
import 'package:chic_wallet/providers/bank_provider.dart';
import 'package:chic_wallet/providers/theme_provider.dart';
import 'package:chic_wallet/ui/components/setting_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  ThemeProvider _themeProvider;
  BankProvider _bankProvider;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    _themeProvider = Provider.of<ThemeProvider>(context, listen: true);
    _bankProvider = Provider.of<BankProvider>(context, listen: true);

    return Scaffold(
      backgroundColor: _themeProvider.secondBackgroundColor,
      body: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Container(
          padding: EdgeInsets.only(
              left: 16, right: 16, bottom: 16, top: kToolbarHeight),
          child: Column(
            children: <Widget>[
              SettingCard(
                title: AppTranslations.of(context)
                    .text("settings_screen_categories_title"),
                description: AppTranslations.of(context)
                    .text("settings_screen_categories_description"),
                onTap: () async {
                  await Navigator.pushNamed(context, '/manage_category_screen');
                  _bankProvider.askReloadData();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
