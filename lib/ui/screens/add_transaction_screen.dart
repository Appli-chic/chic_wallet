import 'package:chic_wallet/localization/app_translations.dart';
import 'package:chic_wallet/providers/theme_provider.dart';
import 'package:chic_wallet/ui/components/bank_body.dart';
import 'package:chic_wallet/ui/components/rounded_button.dart';
import 'package:chic_wallet/ui/components/text_field_underline.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class AddTransactionScreen extends StatefulWidget {
  @override
  _AddTransactionScreenState createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  ThemeProvider _themeProvider;

  final _descriptionFocus = FocusNode();
  final _priceFocus = FocusNode();

  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _categoryController = TextEditingController();

  _onTitleSubmitted(String text) {
    FocusScope.of(context).requestFocus(_descriptionFocus);
  }

  _onDescriptionSubmitted(String text) {
    FocusScope.of(context).requestFocus(_priceFocus);
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
        child: BankBody(
          height: 290,
          isAppBarDisplayed: true,
          label: Container(),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: size.height,
              minWidth: size.width,
            ),
            child: Container(
              margin: EdgeInsets.only(top: 310),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 8, bottom: 16),
                        child: TextFieldUnderline(
                          controller: _titleController,
                          hint: AppTranslations.of(context)
                              .text("add_transaction_title"),
                          onSubmitted: _onTitleSubmitted,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16, bottom: 16),
                        child: TextFieldUnderline(
                          controller: _descriptionController,
                          focus: _descriptionFocus,
                          hint: AppTranslations.of(context)
                              .text("add_transaction_description"),
                          onSubmitted: _onDescriptionSubmitted,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16, bottom: 16),
                        child: TextFieldUnderline(
                          controller: _priceController,
                          focus: _priceFocus,
                          inputType: TextInputType.numberWithOptions(decimal: true),
                          hint: AppTranslations.of(context)
                              .text("add_transaction_price"),
                          textInputAction: TextInputAction.done,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16, bottom: 16),
                        child: TextFieldUnderline(
                          controller: _categoryController,
                          hint: AppTranslations.of(context)
                              .text("add_transaction_type"),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
                    child: RoundedButton(
                      onClick: () {},
                      text: AppTranslations.of(context)
                          .text("add_transaction_add")
                          .toUpperCase(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
