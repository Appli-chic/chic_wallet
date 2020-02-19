import 'package:chic_wallet/ui/components/icon_picker/Serialization/iconDataSerialization.dart';
import 'package:chic_wallet/utils/constants.dart';
import 'package:flutter/material.dart';

class TypeTransaction {
  static const tableName = "type_transactions";

  int id;
  String title;
  String color;
  String iconName;

  TypeTransaction({
    this.id,
    this.title,
    this.color,
    this.iconName,
  });

  factory TypeTransaction.fromJson(Map<String, dynamic> json) {
    return TypeTransaction(
      id: json['id'],
      title: json['title'],
      color: json['color'],
      iconName: json['icon_name'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['color'] = this.color;
    data['icon_name'] = this.iconName;
    return data;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'title': this.title,
      'color': this.color,
      'icon_name': this.iconName,
    };
  }

  static Color getColor(String color) {
    var colorData = color.split(",");
    return Color.fromARGB(int.parse(colorData[0]), int.parse(colorData[1]), int.parse(colorData[2]), int.parse(colorData[3]));
  }

  static String colorToString(Color color) {
    return "${color.alpha},${color.red},${color.green},${color.blue}";
  }

  static IconData getIconData(String name) {
    return stringToIconData(name);
  }
}
