import 'package:chic_wallet/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TransactionCard extends StatefulWidget {
  @override
  _TransactionCardState createState() => _TransactionCardState();
}

class _TransactionCardState extends State<TransactionCard> {
  ThemeProvider _themeProvider;

  @override
  Widget build(BuildContext context) {
    _themeProvider = Provider.of<ThemeProvider>(context, listen: true);

    return Container(
      height: 60,
      margin: EdgeInsets.only(bottom: 12),
      decoration: new BoxDecoration(
        color: _themeProvider.backgroundColor,
        borderRadius: new BorderRadius.all(const Radius.circular(8.0)),
      ),
      child: Container(
        child: Row(
          children: <Widget>[
            Container(
              height: 60,
              width: 60,
              decoration: new BoxDecoration(
                color: _themeProvider.thirdBackgroundColor,
                borderRadius: new BorderRadius.only(
                  topLeft: const Radius.circular(8.0),
                  bottomLeft: const Radius.circular(8.0),
                ),
              ),
              child: Center(
                child:
                    Icon(Icons.shopping_cart, color: _themeProvider.textColor),
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(
                  left: 16,
                  right: 8,
                  top: 6,
                  bottom: 6,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Text(
                      'Selling',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: _themeProvider.textColor,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      'Selling my old graphic card',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: _themeProvider.secondTextColor,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                top: 6,
                bottom: 6,
                right: 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Text(
                    '\$100',
                    style: TextStyle(
                      color: Color(0xFF5EB863),
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    'Yesterday',
                    style: TextStyle(
                      color: _themeProvider.secondTextColor,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
