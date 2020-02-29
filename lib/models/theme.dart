import 'package:flutter/material.dart';

class CWTheme {
  final int id;
  final Color backgroundColor;
  final Color secondBackgroundColor;
  final Color thirdBackgroundColor;
  final Color firstColor;
  final Color secondColor;
  final Color thirdColor;
  final Color textColor;
  final Color secondTextColor;
  final Color thirdTextColor;
  final bool isLight;

  CWTheme({
    @required this.id,
    @required this.backgroundColor,
    @required this.secondBackgroundColor,
    @required this.thirdBackgroundColor,
    @required this.firstColor,
    @required this.secondColor,
    @required this.thirdColor,
    @required this.textColor,
    @required this.secondTextColor,
    @required this.thirdTextColor,
    @required this.isLight,
  });
}