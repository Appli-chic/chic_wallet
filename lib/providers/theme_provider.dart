import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/theme.dart';
import '../utils/constants.dart';

const int DEFAULT_THEME_DARK = 0;
const int DEFAULT_THEME_LIGHT = 1;

class ThemeProvider with ChangeNotifier {
  List<CWTheme> _themeList = List();
  CWTheme _theme;

  ThemeProvider() {
    _generateThemeList();
    _theme = _themeList[0];
    _loadTheme();
  }

  /// Generates the list of themes and insert it in the [_themeList].
  _generateThemeList() {
    CWTheme _defaultDarkTheme = CWTheme(
      id: DEFAULT_THEME_DARK,
      backgroundColor: Color(0xFF242B39),
      secondBackgroundColor: Color(0xFF3F4656),
      firstColor: Color(0xFFD13447),
      secondColor: Color(0xFFF15142),
      textColor: Color(0xFFFFFFFF),
      secondTextColor: Color(0xFFBABABA),
      isLight: false,
    );

    CWTheme _defaultLightTheme = CWTheme(
      id: DEFAULT_THEME_LIGHT,
      backgroundColor: Color(0xFFFFFFFF),
      secondBackgroundColor: Color(0xFF666666),
      firstColor: Color(0xFFD13447),
      secondColor: Color(0xFFF15142),
      textColor: Color(0xFF464646),
      secondTextColor: Color(0xFF666666),
      isLight: true,
    );

    _themeList.add(_defaultDarkTheme);
    _themeList.add(_defaultLightTheme);
  }

  /// Load the [_theme] stored in the secured storage
  _loadTheme() async {
    final storage = FlutterSecureStorage();
    String _themeString = await storage.read(key: KEY_THEME);

    if (_themeString != null) {
      // Load the theme if it exists
      _theme = _themeList
          .where((theme) => theme.id == int.parse(_themeString))
          .toList()[0];
    }

    notifyListeners();
  }

  /// Set the new theme using the [id] of the [_theme]
  setTheme(int id) {
    _theme = _themeList.where((theme) => theme.id == id).toList()[0];
    notifyListeners();
  }

  /// Set the brightness from the actual [_theme]
  Brightness setBrightness() {
    if (theme.isLight) {
      return Brightness.light;
    } else {
      return Brightness.dark;
    }
  }

  /// Retrieve the background color corresponding to the [_theme]
  CWTheme get theme => _theme;

  /// Retrieve the background color corresponding to the [_theme]
  Color get backgroundColor => _theme.backgroundColor;

  // Retrieve the second background color corresponding to the [_theme]
  Color get secondBackgroundColor => _theme.secondBackgroundColor;

  /// Retrieve the first color corresponding to the [_theme]
  Color get firstColor => _theme.firstColor;

  /// Retrieve the second color corresponding to the [_theme]
  Color get secondColor => _theme.secondColor;

  /// Retrieve the text color corresponding to the [_theme]
  Color get textColor => _theme.textColor;

  /// Retrieve the second text color corresponding to the [_theme]
  Color get secondTextColor => _theme.secondTextColor;
}