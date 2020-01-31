import 'package:chic_wallet/providers/theme_provider.dart';
import 'package:chic_wallet/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  AuthService _authService;
  ThemeProvider _themeProvider;

  /// Check if the user is logged in and redirect to the right page
  /// The home page if the user is logged in
  /// The login page if the user needs to login
  _checkIsLoggedIn() async {
    bool isLoggedIn = await _authService.isLoggedIn();

    if (isLoggedIn) {
      Navigator.pushReplacementNamed(context, '/');
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  /// Displays logo in the top of this page
  Widget _displayLogo() {
    return Center(
      child: Container(
        width: 150,
        height: 150,
        child: Placeholder(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    _themeProvider = Provider.of<ThemeProvider>(context, listen: true);
    _authService = Provider.of<AuthService>(context);
    _checkIsLoggedIn();

    return Container(
      color: _themeProvider.backgroundColor,
      child: _displayLogo(),
    );
  }
}

