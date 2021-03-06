/// IconPicker
/// Author Rebar Ahmad
/// https://github.com/Ahmadre
/// rebar.ahmad@gmail.com

import 'package:flutter/material.dart';
import 'searchBar.dart';
import 'icons.dart';

class IconPicker extends StatefulWidget {
  final double iconSize;
  final String noResultsText;
  final Color iconColor;
  static Function reload;
  static Map<String, IconData> iconMap;

  IconPicker({this.iconSize, this.noResultsText, this.iconColor, Key key})
      : super(key: key);

  @override
  _IconPickerState createState() => _IconPickerState();
}

class _IconPickerState extends State<IconPicker> {
  List<Widget> iconList = [];

  @override
  void initState() {
    super.initState();
    IconPicker.iconMap = icons;
    _buildIcons(context);
    IconPicker.reload = reload;
  }

  reload() {
    if (IconPicker.iconMap.isNotEmpty)
      _buildIcons(context);
    else
      setState(() {
        iconList = [];
      });
  }

  _buildIcons(context) async {
    iconList = [];
    IconPicker.iconMap.forEach((String key, IconData val) async {
      iconList.add(InkResponse(
        onTap: () => Navigator.pop(context, val),
        child: Icon(
          val,
          size: widget.iconSize,
          color: widget.iconColor,
        ),
      ));
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(top: 10, bottom: 10, left: 10),
          child: Wrap(
              spacing: 5,
              runSpacing: 10,
              children: IconPicker.iconMap.length != 0
                  ? iconList
                  : [
                      Center(
                        child: Text(
                          widget.noResultsText +
                              ' ' +
                              SearchBar.searchTextController.text,
                          style: TextStyle(
                            color: widget.iconColor,
                          ),
                        ),
                      )
                    ]),
        ),
      ),
    ]);
  }
}
