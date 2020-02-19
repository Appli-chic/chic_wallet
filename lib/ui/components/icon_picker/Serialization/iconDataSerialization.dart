/// IconDataSerialization
/// Author Rebar Ahmad
/// https://github.com/Ahmadre
/// rebar.ahmad@gmail.com

import 'package:flutter/material.dart';

/// Converts an IconData to a Map.
/// Useful for saving IconData for further retreivement.
Map<String, dynamic> iconDataToMap(IconData iconData) {
  Map<String, dynamic> result = new Map<String, dynamic>.from({
    'codePoint': iconData.codePoint,
    'fontFamily': iconData.fontFamily,
    'matchTextDirection': iconData.matchTextDirection
  });
  return result;
}

/// Converts a Map to IconData.
IconData mapToIconData(Map<String, dynamic> map) {
  return new IconData(map['codePoint'],
      fontFamily: map['fontFamily'],
      matchTextDirection: map['matchTextDirection']);
}

String iconDataToString(IconData iconData) {
  return "${iconData.codePoint},${iconData.fontFamily},${iconData.matchTextDirection}";
}

IconData stringToIconData(String iconData) {
  var map = iconData.split(",");
  return new IconData(int.parse(map[0]),
      fontFamily: map[1], matchTextDirection: map[2] == 'true');
}
