import 'package:chic_wallet/models/db/bank.dart';
import 'package:chic_wallet/providers/theme_provider.dart';
import 'package:chic_wallet/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class BankCard extends StatefulWidget {
  final Bank bank;

  BankCard({
    @required this.bank,
  });

  @override
  _BankCardState createState() => _BankCardState();
}

class _BankCardState extends State<BankCard> {
  ThemeProvider _themeProvider;

  Widget _displaysCardType() {
    if (widget.bank.cardType == "Visa") {
      return Container(
        width: 50,
        height: 25,
        padding: EdgeInsets.only(top: 4, bottom: 4, left: 8, right: 8),
        decoration: new BoxDecoration(
          color: _themeProvider.secondColor,
          borderRadius: new BorderRadius.all(const Radius.circular(4)),
        ),
        child: Image.asset(
          'assets/visa.png',
          fit: BoxFit.cover,
        ),
      );
    }

    return Container();
  }

  String _displaysCurrency() {
    var index = LIST_CURRENCIES_NAMES.indexOf(widget.bank.currency);
    return LIST_CURRENCIES[index];
  }

  @override
  Widget build(BuildContext context) {
    _themeProvider = Provider.of<ThemeProvider>(context, listen: true);

    final formatter = NumberFormat("#,###.##");
    String moneyString =
        "${_displaysCurrency()}${formatter.format(widget.bank.money)}";

    var dateFormatter = DateFormat('MM/yy');
    String dateString = dateFormatter.format(widget.bank.expirationDate);

    return Container(
      height: 130,
      width: 280,
      decoration: new BoxDecoration(
        color: _themeProvider.backgroundColor,
        borderRadius: new BorderRadius.all(const Radius.circular(8.0)),
      ),
      child: Container(
        margin: EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      widget.bank.bankName,
                      style: TextStyle(
                        color: _themeProvider.textColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        widget.bank.username,
                        style: TextStyle(
                          color: _themeProvider.textColor,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
                _displaysCardType(),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Flexible(
                  child: Text(
                    moneyString,
                    style: TextStyle(
                      color: _themeProvider.textColor,
                      fontWeight: FontWeight.bold,
                      fontSize: moneyString.length > 10 ? 24 : 34,
                    ),
                  ),
                ),
                Text(
                  dateString,
                  style: TextStyle(
                    color: _themeProvider.textColor,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
