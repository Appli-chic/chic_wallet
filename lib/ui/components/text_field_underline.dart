import 'package:chic_wallet/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TextFieldUnderline extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final bool isObscure;
  final FocusNode focus;
  final TextInputAction textInputAction;
  final Function(String) onSubmitted;

  TextFieldUnderline({
    @required this.controller,
    @required this.hint,
    this.isObscure = false,
    this.focus,
    this.onSubmitted,
    this.textInputAction = TextInputAction.next,
  });

  @override
  _TextFieldUnderlineState createState() => _TextFieldUnderlineState();
}

class _TextFieldUnderlineState extends State<TextFieldUnderline> {
  ThemeProvider _themeProvider;

  @override
  Widget build(BuildContext context) {
    _themeProvider = Provider.of<ThemeProvider>(context, listen: true);

    return TextField(
      focusNode: widget.focus,
      controller: widget.controller,
      keyboardType: TextInputType.emailAddress,
      textInputAction: widget.textInputAction,
      obscureText: widget.isObscure,
      autocorrect: false,
      decoration: InputDecoration(
        labelText: widget.hint,
        labelStyle: TextStyle(color: _themeProvider.secondTextColor),
        hintStyle: TextStyle(color: _themeProvider.secondTextColor),
        contentPadding: EdgeInsets.only(left: 16, bottom: 8),
        enabledBorder: UnderlineInputBorder(
          borderSide:
              BorderSide(color: _themeProvider.secondTextColor, width: 0.0),
        ),
        border: UnderlineInputBorder(
          borderSide:
              BorderSide(color: _themeProvider.secondTextColor, width: 0.0),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide:
              BorderSide(color: _themeProvider.secondTextColor, width: 0.0),
        ),
      ),
      style: TextStyle(color: _themeProvider.textColor, fontSize: 16),
      onSubmitted: widget.onSubmitted,
    );
  }
}
