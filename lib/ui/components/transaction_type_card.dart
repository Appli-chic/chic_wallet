import 'package:chic_wallet/models/db/bank.dart';
import 'package:chic_wallet/providers/theme_provider.dart';
import 'package:chic_wallet/ui/screens/chart_screen.dart';
import 'package:chic_wallet/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TransactionTypeCard extends StatefulWidget {
  final TransactionTypeGroupData transactionTypeGroupData;
  final Bank bank;

  TransactionTypeCard({
    this.transactionTypeGroupData,
    this.bank,
  });

  @override
  _TransactionTypeCardState createState() => _TransactionTypeCardState();
}

class _TransactionTypeCardState extends State<TransactionTypeCard> {
  ThemeProvider _themeProvider;

  @override
  Widget build(BuildContext context) {
    _themeProvider = Provider.of<ThemeProvider>(context, listen: true);

    return Container(
      height: 60,
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: _themeProvider.backgroundColor,
        borderRadius: new BorderRadius.all(const Radius.circular(8.0)),
      ),
      child: Container(
        child: Row(
          children: <Widget>[
            Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                color: _themeProvider.thirdBackgroundColor,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(8.0),
                  bottomLeft: const Radius.circular(8.0),
                ),
              ),
              child: Container(
                child: Stack(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.center,
                      child: Icon(
                        widget.transactionTypeGroupData.icon,
                        color: _themeProvider.textColor,
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        margin: EdgeInsets.only(top: 10, right: 10),
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: widget.transactionTypeGroupData.color,
                        ),
                      ),
                    ),
                  ],
                ),
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
                child: Text(
                  widget.transactionTypeGroupData.typeName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: _themeProvider.textColor,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                top: 6,
                bottom: 6,
                right: 16,
              ),
              child: Text(
                "${displaysCurrency(widget.bank)}${widget.transactionTypeGroupData.amount.abs().toStringAsFixed(2)}",
                style: TextStyle(
                  color: widget.transactionTypeGroupData.amount >= 0
                      ? Color(0xFF5EB863)
                      : Color(0xFFe84646),
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
