import 'package:chic_wallet/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingCard extends StatefulWidget {
  final String title;
  final String description;
  final Function onTap;

  SettingCard({
    this.title,
    this.description,
    this.onTap,
  });

  @override
  _SettingCardState createState() => _SettingCardState();
}

class _SettingCardState extends State<SettingCard> {
  ThemeProvider _themeProvider;

  @override
  Widget build(BuildContext context) {
    _themeProvider = Provider.of<ThemeProvider>(context, listen: true);

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        height: 100,
        width: double.maxFinite,
        decoration: BoxDecoration(
          color: _themeProvider.backgroundColor,
          borderRadius: BorderRadius.all(const Radius.circular(8.0)),
        ),
        child: Container(
          margin: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text(
                widget.title,
                style: TextStyle(
                  color: _themeProvider.textColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                widget.description,
                style: TextStyle(
                    color: _themeProvider.secondTextColor, fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
