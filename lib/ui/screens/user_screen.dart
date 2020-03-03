import 'package:chic_wallet/localization/app_translations.dart';
import 'package:chic_wallet/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class UserScreen extends StatefulWidget {
  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  ThemeProvider _themeProvider;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    _themeProvider = Provider.of<ThemeProvider>(context, listen: true);

    return Scaffold(
      backgroundColor: _themeProvider.secondBackgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.fitness_center,
              color: _themeProvider.textColor,
              size: 60,
            ),
            Container(
              padding: EdgeInsets.only(top: 16),
              child: Text(
                AppTranslations.of(context)
                    .text("user_screen_work_in_progress"),
                style: TextStyle(
                  color: _themeProvider.textColor,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
