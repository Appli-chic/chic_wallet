import 'package:chic_wallet/providers/theme_provider.dart';
import 'package:chic_wallet/ui/components/bank_card.dart';
import 'package:chic_wallet/ui/components/transaction_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ThemeProvider _themeProvider;

  Widget _displaysTopPart() {
    return Container(
      height: 480,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _themeProvider.firstColor,
            _themeProvider.secondColor,
            _themeProvider.thirdColor,
          ],
        ),
      ),
      child: Container(
        margin: EdgeInsets.only(top: kToolbarHeight - 30, left: 16, right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Banks',
                      style: TextStyle(
                        color: _themeProvider.textColor,
                        fontSize: 18,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.add, color: _themeProvider.textColor, size: 30),
                      onPressed: () {},
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    BankCard(
                      bankName: "Banque populaire",
                      username: "Guillaume Belouin",
                      money: 16000.49,
                      cardType: 'visa',
                      expirationDate: DateTime.now(),
                    ),
                  ],
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(bottom: 40),
              child: Text(
                'Transactions',
                style: TextStyle(
                  color: _themeProvider.textColor,
                  fontSize: 18,
                ),
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

    return SingleChildScrollView(
      child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              _displaysTopPart(),
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: 450, left: 16, right: 16),
            child: ListView.builder(
              padding: EdgeInsets.only(top: 0, bottom: 20),
              physics: NeverScrollableScrollPhysics(),
              itemCount: 10,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                return TransactionCard();
              },
            ),
          ),
        ],
      ),
    );
  }
}
