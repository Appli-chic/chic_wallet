import 'package:chic_wallet/localization/app_translations.dart';
import 'package:chic_wallet/providers/theme_provider.dart';
import 'package:chic_wallet/ui/components/app_bar_image.dart';
import 'package:chic_wallet/ui/components/loading_dialog.dart';
import 'package:chic_wallet/ui/components/text_field_underline.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddBankScreen extends StatefulWidget {
  @override
  _AddBankScreenState createState() => _AddBankScreenState();
}

class _AddBankScreenState extends State<AddBankScreen> {
  ThemeProvider _themeProvider;

  final _cardholderNameFocus = FocusNode();
  final _validtyDateFocus = FocusNode();
  TextEditingController _bankNameController = TextEditingController();
  TextEditingController _cardholderNameController = TextEditingController();
  bool _isLoading = false;

  /// When the bank name is submitted we focus the card holder name field
  _onBankNameSubmitted(String text) {
    FocusScope.of(context).requestFocus(_cardholderNameFocus);
  }

  /// When the cardholder name is submitted we focus the card holder validity date field
  _onCardholderNameSubmitted(String text) {
    FocusScope.of(context).requestFocus(_validtyDateFocus);
  }

  @override
  Widget build(BuildContext context) {
    _themeProvider = Provider.of<ThemeProvider>(context, listen: true);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: _themeProvider.secondBackgroundColor,
      body: LoadingDialog(
        isDisplayed: _isLoading,
        child: SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: size.height,
              minWidth: size.width,
            ),
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
              },
              child: Column(
                children: <Widget>[
                  AppBarImage(
                    imageUrl: 'assets/dollars.jpg',
                    height: 240,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                      child: Text(
                        AppTranslations.of(context).text("add_bank_title"),
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
                      controller: _bankNameController,
                      hint: AppTranslations.of(context)
                          .text("add_bank_bank_name"),
                      onSubmitted: _onBankNameSubmitted,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16, bottom: 16),
                    child: TextFieldUnderline(
                      controller: _cardholderNameController,
                      focus: _cardholderNameFocus,
                      hint: AppTranslations.of(context)
                          .text("add_bank_cardholder_name"),
                      onSubmitted: _onCardholderNameSubmitted,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16, bottom: 16),
                    child: TextFieldUnderline(
                      fieldType: TextFieldType.date,
//                      focus: _cardholderNameFocus,
                      hint: AppTranslations.of(context)
                          .text("add_bank_validity_date"),
//                      onSubmitted: _onCardholderNameSubmitted,
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
