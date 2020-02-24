import 'package:chic_wallet/localization/app_translations.dart';
import 'package:chic_wallet/models/db/type_transaction.dart';
import 'package:chic_wallet/providers/theme_provider.dart';
import 'package:chic_wallet/services/type_transaction_service.dart';
import 'package:chic_wallet/ui/components/app_bar_image.dart';
import 'package:chic_wallet/ui/components/error_form.dart';
import 'package:chic_wallet/ui/components/icon_picker/Serialization/iconDataSerialization.dart';
import 'package:chic_wallet/ui/components/icon_picker/flutter_iconpicker.dart';
import 'package:chic_wallet/ui/components/rounded_button.dart';
import 'package:chic_wallet/ui/components/text_field_underline.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';

class NewCategoryScreen extends StatefulWidget {
  @override
  _NewCategoryScreenState createState() => _NewCategoryScreenState();
}

class _NewCategoryScreenState extends State<NewCategoryScreen> {
  ThemeProvider _themeProvider;
  TypeTransactionService _typeTransactionService;

  TextEditingController _titleController = TextEditingController();
  Color _pickerColor = Color(0xfff44336);
  IconData _icon = Icons.shopping_cart;
  List<String> _errorList = [];

  didChangeDependencies() {
    super.didChangeDependencies();

    if (_typeTransactionService == null) {
      _typeTransactionService =
          Provider.of<TypeTransactionService>(context);
    }
  }

  _save() async {
    bool isValid = true;
    List<String> errorList = [];

    // Check the title
    if (_titleController.text.isEmpty) {
      isValid = false;
      errorList
          .add(AppTranslations.of(context).text("add_category_empty_title"));
    }

    if (isValid) {
      var typeTransaction = TypeTransaction(
        title: _titleController.text,
        color: TypeTransaction.colorToString(_pickerColor),
        iconName: iconDataToString(_icon),
      );

      await _typeTransactionService.save(typeTransaction);

      Navigator.pop(context);
    }

    setState(() {
      _errorList = errorList;
    });

    // Hide the keyboard
    FocusScope.of(context).requestFocus(FocusNode());
  }

  _changeColor(Color color) {
    setState(() => _pickerColor = color);
  }

  _displayColorSelector() {
    showDialog(
      context: context,
      child: AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.0))),
        backgroundColor: _themeProvider.backgroundColor,
        content: BlockPicker(
          pickerColor: _pickerColor,
          onColorChanged: _changeColor,
        ),
        actions: <Widget>[
          FlatButton(
            child: Text(AppTranslations.of(context).text("dialog_ok")),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  _pickIcon() async {
    var iconData = await FlutterIconPicker.showIconPicker(context,
        backgroundColor: _themeProvider.backgroundColor,
        firstColor: _themeProvider.textColor,
        secondColor: _themeProvider.secondTextColor,
        iconSize: 40,
        iconPickerShape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text(
          'Pick an icon',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: _themeProvider.textColor,
          ),
        ),
        closeChild: Text(
          'Close',
          textScaleFactor: 1.25,
        ),
        searchHintText: 'Search icon...',
        noResultsText: 'No results for:');

    if (iconData != null) {
      setState(() {
        _icon = iconData;
      });
    }
  }

  /// Displays the errors from the [_errorList]
  Widget _displayError() {
    if (_errorList.isNotEmpty) {
      return Padding(
        padding:
            const EdgeInsets.only(top: 32, left: 32, right: 32, bottom: 32),
        child: ErrorForm(errorList: _errorList),
      );
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    _themeProvider = Provider.of<ThemeProvider>(context, listen: true);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: _themeProvider.secondBackgroundColor,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: size.height,
              minWidth: size.width,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    AppBarImage(
                      imageUrl: 'assets/category.jpg',
                      height: 240,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Center(
                        child: Text(
                          AppTranslations.of(context)
                              .text("add_category_title"),
                          style: TextStyle(
                            color: _themeProvider.textColor,
                            fontSize: 24,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16, bottom: 16),
                      child: TextFieldUnderline(
                        controller: _titleController,
                        textInputAction: TextInputAction.done,
                        hint: AppTranslations.of(context)
                            .text("add_category_title_hint"),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 16, bottom: 16, left: 16),
                        child: Row(
                          children: <Widget>[
                            Container(
                              width: 40.0,
                              height: 40.0,
                              decoration: new BoxDecoration(
                                color: _pickerColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 16),
                              child: FlatButton(
                                onPressed: _displayColorSelector,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4.0)),
                                color: _themeProvider.firstColor,
                                child: Text(
                                  AppTranslations.of(context)
                                      .text("add_category_change_color"),
                                  style: TextStyle(
                                    color: _themeProvider.textColor,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 16, bottom: 16, left: 16),
                        child: Row(
                          children: <Widget>[
                            Container(
                              width: 40.0,
                              height: 40.0,
                              decoration: new BoxDecoration(
                                color: _themeProvider.thirdBackgroundColor,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                _icon,
                                color: _themeProvider.textColor,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 16),
                              child: FlatButton(
                                onPressed: _pickIcon,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4.0)),
                                color: _themeProvider.firstColor,
                                child: Text(
                                  AppTranslations.of(context)
                                      .text("add_category_change_icon"),
                                  style: TextStyle(
                                    color: _themeProvider.textColor,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    _displayError(),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 16, right: 16, bottom: 16, top: 16),
                  child: RoundedButton(
                    onClick: _save,
                    text: AppTranslations.of(context)
                        .text("add_category_save")
                        .toUpperCase(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
