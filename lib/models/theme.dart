import 'package:flutter/material.dart';

class CWTheme {
  final int id;
  final Color backgroundColor;
  final Color secondBackgroundColor;
  final Color firstColor;
  final Color secondColor;
  final Color textColor;
  final Color secondTextColor;
  final bool isLight;

  CWTheme({
    @required this.id,
    @required this.backgroundColor,
    @required this.secondBackgroundColor,
    @required this.firstColor,
    @required this.secondColor,
    @required this.textColor,
    @required this.secondTextColor,
    @required this.isLight,
  });
}