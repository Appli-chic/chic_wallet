import 'package:chic_wallet/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppBarImage extends StatefulWidget {
  final String imageUrl;
  final double height;

  AppBarImage({
    @required this.imageUrl,
    this.height = 300,
  });

  @override
  _AppBarImageState createState() => _AppBarImageState();
}

class _AppBarImageState extends State<AppBarImage> {
  ThemeProvider _themeProvider;

  @override
  Widget build(BuildContext context) {
    _themeProvider = Provider.of<ThemeProvider>(context, listen: true);

    return Stack(
      children: <Widget>[
        Container(
          height: widget.height,
          width: double.maxFinite,
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
          child: Opacity(
            opacity: 0.5,
            child: Image(
              image: AssetImage(widget.imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
        AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: BackButton(
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ],
    );
  }
}
