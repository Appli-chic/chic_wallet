import 'package:carousel_slider/carousel_slider.dart';
import 'package:chic_wallet/localization/app_translations.dart';
import 'package:chic_wallet/providers/bank_provider.dart';
import 'package:chic_wallet/providers/theme_provider.dart';
import 'package:chic_wallet/services/bank_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'bank_card.dart';

class BankBody extends StatefulWidget {
  final Widget child;
  final Widget label;
  final bool isAppBarDisplayed;
  final double height;

  BankBody({
    @required this.child,
    @required this.label,
    this.isAppBarDisplayed = false,
    this.height = 480,
  });

  @override
  _BankBodyState createState() => _BankBodyState();
}

class _BankBodyState extends State<BankBody> {
  ThemeProvider _themeProvider;
  BankProvider _bankProvider;
  BankService _bankService;

  CarouselSlider _carousel;

  didChangeDependencies() {
    super.didChangeDependencies();

    if (_bankProvider == null) {
      _bankProvider = Provider.of<BankProvider>(context, listen: true);
    }

    if (_bankService == null) {
      _bankService = Provider.of<BankService>(context);
    }
  }

  Future<void> _loadAllBanks() async {
    var banks = await _bankService.getAll();
    _bankProvider.setBanks(banks);

    if (_bankProvider.selectedBank == null) {
      _bankProvider.selectBank(banks[0].id);
    }
  }

  Widget _displaysBankCards() {
    if (_bankProvider.banks.isNotEmpty) {
      _carousel = CarouselSlider(
        height: 140,
        autoPlay: false,
        enlargeCenterPage: true,
        enableInfiniteScroll: false,
        items: _bankProvider.banks.map((bank) {
          return Builder(builder: (BuildContext context) {
            return GestureDetector(
              onTap: () async {
                await Navigator.pushNamed(context, '/add_bank_screen',
                    arguments: bank);
                await _loadAllBanks();
                _bankProvider.askReloadData(didBankCardChanged: true);
              },
              child: BankCard(
                bank: bank,
              ),
            );
          });
        }).toList(),
        onPageChanged: (index) {
          _bankProvider.selectBank(_bankProvider.banks[index].id);
          _bankProvider.askReloadData(didBankCardChanged: true);
        },
      );

      return _carousel;
    } else {
      return Center(
        child: GestureDetector(
          onTap: () async {
            await Navigator.pushNamed(context, '/add_bank_screen');
            await _loadAllBanks();
          },
          child: Container(
            height: 140,
            width: 280,
            decoration: new BoxDecoration(
              color: _themeProvider.backgroundColor,
              borderRadius: new BorderRadius.all(const Radius.circular(8.0)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Icon(
                    Icons.add,
                    color: _themeProvider.textColor,
                    size: 36,
                  ),
                ),
                Text(
                  AppTranslations.of(context).text("add_bank"),
                  style: TextStyle(
                    color: _themeProvider.textColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 36,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

  Widget _displaysTopPart() {
    Widget appbar = Container();

    if (widget.isAppBarDisplayed) {
      appbar = Container(
        child: BackButton(
          color: _themeProvider.textColor,
        ),
      );
    }

    return Container(
      height: widget.height,
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
                appbar,
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
                        await _loadAllBanks();
                      },
                    ),
                  ],
                ),
                _displaysBankCards(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _bankProvider.banks.asMap().entries.map(
                    (mapEntry) {
                      return Container(
                        width: 8.0,
                        height: 8.0,
                        margin: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 2.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _bankProvider.index == mapEntry.key
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
    _bankProvider = Provider.of<BankProvider>(context, listen: true);

    if (_carousel != null) {
      _carousel.jumpToPage(_bankProvider.index);
    }

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
