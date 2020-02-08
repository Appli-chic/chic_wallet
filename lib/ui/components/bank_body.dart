import 'package:carousel_slider/carousel_slider.dart';
import 'package:chic_wallet/localization/app_translations.dart';
import 'package:chic_wallet/models/db/bank.dart';
import 'package:chic_wallet/providers/theme_provider.dart';
import 'package:chic_wallet/services/bank_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'bank_card.dart';

class BankBody extends StatefulWidget {
  final Widget child;
  final Widget label;

  BankBody({
    @required this.child,
    @required this.label,
  });

  @override
  _BankBodyState createState() => _BankBodyState();
}

class _BankBodyState extends State<BankBody> {
  ThemeProvider _themeProvider;
  BankService _bankService;

  List<Bank> _banks = [];
  int _carouselIndex = 0;

  didChangeDependencies() {
    super.didChangeDependencies();

    if (_bankService == null) {
      _bankService = Provider.of<BankService>(context);
      _loadAllBanks();
    }
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
                        AppTranslations.of(context).text("bank_body_banks"),
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
                CarouselSlider(
                  height: 140,
                  autoPlay: false,
                  enlargeCenterPage: true,
                  enableInfiniteScroll: false,
                  items: _banks.map((bank) {
                    return Builder(builder: (BuildContext context) {
                      return BankCard(
                        bank: bank,
                      );
                    });
                  }).toList(),
                  onPageChanged: (index) {
                    setState(() {
                      _carouselIndex = index;
                    });
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _banks.asMap().entries.map(
                    (mapEntry) {
                      return Container(
                        width: 8.0,
                        height: 8.0,
                        margin: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 2.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _carouselIndex == mapEntry.key
                              ? Colors.white
                              : Color(0xFFBD7BFE),
                        ),
                      );
                    },
                  ).toList(),
                ),
              ],
            ),
            widget.label,
          ],
        ),
      ),
    );
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
          widget.child,
        ],
      ),
    );
  }
}
