import 'dart:async';

import 'package:chic_wallet/providers/theme_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rounded_date_picker/rounded_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TextFieldType {
  const TextFieldType._(this.index);

  final int index;

  static const TextFieldType text = TextFieldType._(0);

  static const TextFieldType date = TextFieldType._(1);

  static const TextFieldType select = TextFieldType._(2);

  static const TextFieldType multipleSelect = TextFieldType._(3);
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
  final List<String> listFields2;
  final Function(DateTime) onDateSelected;
  final TextInputType inputType;
  final List<TextInputFormatter> inputFormatterList;
  final Function(int, String, int, String) onMultipleSelectChose;
  final Function() onDeletePressed;
  final String dateFormatString;

  TextFieldUnderline({
    @required this.controller,
    @required this.hint,
    this.isObscure = false,
    this.focus,
    this.onSubmitted,
    this.textInputAction = TextInputAction.next,
    this.fieldType = TextFieldType.text,
    this.listFields = const [],
    this.onDateSelected,
    this.inputType = TextInputType.text,
    this.inputFormatterList = const [],
    this.listFields2 = const [],
    this.onMultipleSelectChose,
    this.onDeletePressed,
    this.dateFormatString = "MM/yy",
  });

  @override
  _TextFieldUnderlineState createState() => _TextFieldUnderlineState();
}

class _TextFieldUnderlineState extends State<TextFieldUnderline> {
  ThemeProvider _themeProvider;
  String _firstPickerResult;
  int _firstPickerIndex = 0;
  String _secondPickerResult;
  int _secondPickerIndex = 0;
  bool _isNotClickable = false;

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

  _onMultipleSelectInputClicked() async {
    // Pre selection of the first inputs
    if (widget.controller.text.isEmpty) {
      _firstPickerResult = widget.listFields[0];
      _firstPickerIndex = 0;
      _secondPickerResult = widget.listFields[0];
      _secondPickerIndex = 0;

      widget.onMultipleSelectChose(_firstPickerIndex, _firstPickerResult,
          _secondPickerIndex, _secondPickerResult);
    }

    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200,
          child: Row(
            children: <Widget>[
              Expanded(
                child: CupertinoPicker(
                  backgroundColor: _themeProvider.backgroundColor,
                  itemExtent: 30,
                  onSelectedItemChanged: (int index) {
                    _firstPickerResult = widget.listFields[index];
                    _firstPickerIndex = index;
                    widget.onMultipleSelectChose(
                        _firstPickerIndex,
                        _firstPickerResult,
                        _secondPickerIndex,
                        _secondPickerResult);
                  },
                  children: List<Widget>.generate(widget.listFields.length,
                      (int index) {
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
              ),
              Expanded(
                child: CupertinoPicker(
                  backgroundColor: _themeProvider.backgroundColor,
                  itemExtent: 30,
                  onSelectedItemChanged: (int index) {
                    _secondPickerResult = widget.listFields[index];
                    _secondPickerIndex = index;
                    widget.onMultipleSelectChose(
                        _firstPickerIndex,
                        _firstPickerResult,
                        _secondPickerIndex,
                        _secondPickerResult);
                  },
                  children: List<Widget>.generate(widget.listFields2.length,
                      (int index) {
                    return Center(
                      child: Text(
                        widget.listFields2[index],
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ],
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
      var dateFormatter = DateFormat(widget.dateFormatString);
      String dateString = dateFormatter.format(selectedDate);

      widget.controller.text = dateString;
      widget.onDateSelected(selectedDate);
    }
  }

  @override
  void initState() {
    if (widget.fieldType == TextFieldType.multipleSelect) {
      _firstPickerResult = widget.listFields[0];
      _secondPickerResult = widget.listFields2[0];
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _themeProvider = Provider.of<ThemeProvider>(context, listen: true);

    return TextField(
      focusNode: widget.focus,
      controller: widget.controller,
      keyboardType: widget.inputType,
      textInputAction: widget.textInputAction,
      inputFormatters: widget.inputFormatterList,
      obscureText: widget.isObscure,
      autocorrect: false,
      textCapitalization: widget.isObscure
          ? TextCapitalization.none
          : TextCapitalization.sentences,
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
        suffix: widget.fieldType == TextFieldType.multipleSelect
            ? GestureDetector(
                onTap: () async {
                  _isNotClickable = true;
                  widget.onDeletePressed();
                  FocusScope.of(context).requestFocus(FocusNode());

                  Future.delayed(Duration(milliseconds: 300), () {
                    _isNotClickable = false;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Icon(
                    Icons.close,
                    color: _themeProvider.textColor,
                  ),
                ),
              )
            : null,
      ),
      style: TextStyle(color: _themeProvider.textColor, fontSize: 16),
      onSubmitted: widget.onSubmitted,
      readOnly: widget.fieldType == TextFieldType.date ||
              widget.fieldType == TextFieldType.select ||
              widget.fieldType == TextFieldType.multipleSelect
          ? true
          : false,
      onTap: () {
        if (!_isNotClickable) {
          if (widget.fieldType == TextFieldType.date) {
            _onDateInputClicked();
          } else if (widget.fieldType == TextFieldType.select) {
            _onSelectInputClicked();
          } else if (widget.fieldType == TextFieldType.multipleSelect) {
            _onMultipleSelectInputClicked();
          }
        }
      },
    );
  }
}
