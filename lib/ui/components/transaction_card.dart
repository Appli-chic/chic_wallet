import 'package:chic_wallet/models/db/transaction.dart';
import 'package:chic_wallet/models/db/type_transaction.dart';
import 'package:chic_wallet/providers/bank_provider.dart';
import 'package:chic_wallet/providers/theme_provider.dart';
import 'package:chic_wallet/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class TransactionCard extends StatefulWidget {
  final Transaction transaction;

  TransactionCard({
    this.transaction,
  });

  @override
  _TransactionCardState createState() => _TransactionCardState();
}

class _TransactionCardState extends State<TransactionCard> {
  ThemeProvider _themeProvider;
  BankProvider _bankProvider;

  @override
  Widget build(BuildContext context) {
    _themeProvider = Provider.of<ThemeProvider>(context, listen: true);
    _bankProvider = Provider.of<BankProvider>(context, listen: true);

    return GestureDetector(
      onTap: () async {
        await Navigator.pushNamed(context, '/add_transaction_screen',
            arguments: widget.transaction);
        _bankProvider.askReloadData(didBankCardChanged: true);
      },
      child: Container(
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
                            TypeTransaction.getIconData(
                                widget.transaction.typeTransaction.iconName),
                            color: _themeProvider.textColor),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          margin: EdgeInsets.only(top: 10, right: 10),
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: TypeTransaction.getColor(
                                widget.transaction.typeTransaction.color),
                          ),
                        ),
                      ),
                      widget.transaction.transaction.id != null
                          ? Align(
                              alignment: Alignment.topLeft,
                              child: Container(
                                margin: EdgeInsets.only(top: 4, left: 4),
                                width: 12,
                                height: 12,
                                child: Icon(
                                  Icons.repeat,
                                  color: _themeProvider.textColor,
                                  size: 12,
                                ),
                              ),
                            )
                          : Container(),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Text(
                        widget.transaction.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: _themeProvider.textColor,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        widget.transaction.description,
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
                      "${displaysCurrency(widget.transaction.bank)}${widget.transaction.price.abs().toStringAsFixed(2)}",
                      style: TextStyle(
                        color: widget.transaction.price >= 0
                            ? Color(0xFF5EB863)
                            : Color(0xFFe84646),
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      timeago.format(widget.transaction.date),
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
      ),
    );
  }
}
