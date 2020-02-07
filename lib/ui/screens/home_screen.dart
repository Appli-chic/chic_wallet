import 'package:chic_wallet/models/db/bank.dart';
import 'package:chic_wallet/providers/theme_provider.dart';
import 'package:chic_wallet/services/bank_service.dart';
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
  BankService _bankService;

  List<Bank> _banks = [];

  @override
  void initState() {
    super.initState();
  }

  _loadAllBanks() async {
    _banks = await _bankService.getAll();

    setState(() {});
  }

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
        margin: EdgeInsets.only(top: kToolbarHeight - 30),
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
                    Container(
                      margin: EdgeInsets.only(left: 16),
                      child: Text(
                        'Banks',
                        style: TextStyle(
                          color: _themeProvider.textColor,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.add,
                          color: _themeProvider.textColor, size: 30),
                      onPressed: () async {
                        await Navigator.pushNamed(context, '/add_bank_screen');
                        _loadAllBanks();
                      },
                    ),
                  ],
                ),
                Container(
                  height: 140,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _banks.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 40, left: 16),
                          child: BankCard(
                            bank: _banks[index],
                          ),
                        );
                      }),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(bottom: 40, left: 16),
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

  didChangeDependencies() {
    super.didChangeDependencies();

    if (_bankService == null) {
      _bankService = Provider.of<BankService>(context);
      _loadAllBanks();
    }
  }

  @override
  Widget build(BuildContext context) {
    _themeProvider = Provider.of<ThemeProvider>(context, listen: true);

    return SingleChildScrollView(
      physics: ClampingScrollPhysics(),
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
