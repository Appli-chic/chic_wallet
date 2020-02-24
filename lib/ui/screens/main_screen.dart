import 'package:chic_wallet/providers/theme_provider.dart';
import 'package:chic_wallet/ui/screens/chart_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'package:provider/provider.dart';

import 'home_screen.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  ThemeProvider _themeProvider;

  PreloadPageController _pageController = PreloadPageController();
  int _index = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  /// Changes the displayed tab to the specified [index]
  _onTabClicked(int index) {
    setState(() {
      _index = index;
    });

    _pageController.jumpToPage(_index);
  }

  /// Displays the bottom navigation bar
  BottomNavigationBar _displayBottomBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: _themeProvider.backgroundColor,
      elevation: 0,
      currentIndex: _index,
      onTap: _onTabClicked,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.credit_card,
              color: _themeProvider.textColor, size: 30),
          activeIcon: Icon(Icons.credit_card,
              color: _themeProvider.secondColor, size: 30),
          title: const SizedBox(),
        ),
        BottomNavigationBarItem(
          icon:
              Icon(Icons.show_chart, color: _themeProvider.textColor, size: 30),
          activeIcon: Icon(Icons.show_chart,
              color: _themeProvider.secondColor, size: 30),
          title: const SizedBox(),
        ),
        BottomNavigationBarItem(
          icon: const SizedBox(),
          title: const SizedBox(),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person, color: _themeProvider.textColor, size: 30),
          activeIcon:
              Icon(Icons.person, color: _themeProvider.secondColor, size: 30),
          title: const SizedBox(),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings, color: _themeProvider.textColor, size: 30),
          activeIcon:
              Icon(Icons.settings, color: _themeProvider.secondColor, size: 30),
          title: const SizedBox(),
        ),
      ],
    );
  }

  Widget _displaysFloatingButton() {
    return Padding(
      padding: EdgeInsets.only(top: 20),
      child: SizedBox(
        height: 70,
        width: 70,
        child: FloatingActionButton(
          backgroundColor: Colors.transparent,
          elevation: 0,
          onPressed: () async {
            await Navigator.pushNamed(context, '/add_transaction_screen');
          },
          child: Container(
            height: 70,
            width: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _themeProvider.secondColor,
            ),
            child: Icon(Icons.add, size: 40),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    _themeProvider = Provider.of<ThemeProvider>(context, listen: true);

    return Scaffold(
      backgroundColor: _themeProvider.secondBackgroundColor,
      bottomNavigationBar: _displayBottomBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _displaysFloatingButton(),
      body: PreloadPageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        children: <Widget>[
          HomeScreen(),
          ChartScreen(),
          Container(),
          Container(color: Colors.yellow),
          Container(color: Colors.blue),
        ],
      ),
    );
  }
}
