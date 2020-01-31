import 'package:chic_wallet/providers/theme_provider.dart';
import 'package:chic_wallet/ui/components/bank_card.dart';
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
        margin: EdgeInsets.only(top: kToolbarHeight - 20, left: 16, right: 16),
        child: Align(
          alignment: Alignment.topLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                height: 30,
                child: Row(
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
                      icon: Icon(Icons.add, color: _themeProvider.textColor),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 16),
                child: Row(
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _themeProvider = Provider.of<ThemeProvider>(context, listen: true);

    return Column(
      children: <Widget>[
        _displaysTopPart(),
      ],
    );
  }
}
