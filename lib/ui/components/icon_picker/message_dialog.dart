import 'package:flutter/material.dart';

class MessageDialog {
  static Future<void> display(
    BuildContext ctx, {
    Color backgroundColor,
    Widget title,
    Widget body,
    List<Widget> actions,
  }) async {
    return showDialog<void>(
      context: ctx,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
          backgroundColor: backgroundColor,
          title: title,
          content: body,
          actions: actions,
        );
      },
    );
  }
}
