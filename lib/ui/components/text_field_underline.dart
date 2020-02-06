import 'package:chic_wallet/providers/theme_provider.dart';
import 'package:chic_wallet/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/rounded_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TextFieldType {
  const TextFieldType._(this.index);

  final int index;

  static const TextFieldType text = TextFieldType._(0);

  static const TextFieldType date = TextFieldType._(1);

  static const TextFieldType select = TextFieldType._(2);
}

class TextFieldUnderline extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final bool isObscure;
  final FocusNode focus;
  final TextInputAction textInputAction;
  final Function(String) onSubmitted;
  final TextFieldType fieldType;
  final List<String> listFields;

  TextFieldUnderline({
    @required this.controller,
    @required this.hint,
    this.isObscure = false,
    this.focus,
    this.onSubmitted,
    this.textInputAction = TextInputAction.next,
    this.fieldType = TextFieldType.text,
    this.listFields = const [],
  });

  @override
  _TextFieldUnderlineState createState() => _TextFieldUnderlineState();
}

class _TextFieldUnderlineState extends State<TextFieldUnderline> {
  ThemeProvider _themeProvider;

  _onSelectInputClicked() async {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200,
          child: CupertinoPicker(
            backgroundColor: _themeProvider.backgroundColor,
            itemExtent: 30,
            onSelectedItemChanged: (int index) {
              widget.controller.text = widget.listFields[index];
            },
            children:
                List<Widget>.generate(widget.listFields.length, (int index) {
              return Center(
                child: Text(
                  widget.listFields[index],
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              );
            }),
          ),
        );
      },
    );
  }

  _onDateInputClicked() async {
    DateTime selectedDate = await showRoundedDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      borderRadius: 16,
      initialDatePickerMode: DatePickerMode.year,
      theme: ThemeData(
        primaryColor: _themeProvider.secondColor,
        accentColor: _themeProvider.secondColor,
        dialogBackgroundColor: _themeProvider.backgroundColor,
        textTheme: TextTheme(
          body1: TextStyle(color: _themeProvider.textColor),
          caption: TextStyle(color: _themeProvider.textColor),
          subhead: TextStyle(color: _themeProvider.textColor),
        ),
        disabledColor: _themeProvider.secondTextColor,
        accentTextTheme: TextTheme(
          body2: TextStyle(color: _themeProvider.textColor),
        ),
        iconTheme: IconThemeData(color: _themeProvider.textColor),
      ),
    );

    if (selectedDate != null) {
      var dateFormatter = new DateFormat('MM/yy');
      String dateString = dateFormatter.format(selectedDate);

      widget.controller.text = dateString;
    }
  }

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
      readOnly: widget.fieldType == TextFieldType.date ||
              widget.fieldType == TextFieldType.select
          ? true
          : false,
      onTap: () {
        if (widget.fieldType == TextFieldType.date) {
          _onDateInputClicked();
        } else if (widget.fieldType == TextFieldType.select) {
          _onSelectInputClicked();
        }
      },
    );
  }
}
