import 'package:chic_wallet/localization/app_translations.dart';
import 'package:chic_wallet/models/db/bank.dart';
import 'package:chic_wallet/providers/theme_provider.dart';
import 'package:chic_wallet/services/bank_service.dart';
import 'package:chic_wallet/ui/components/app_bar_image.dart';
import 'package:chic_wallet/ui/components/error_form.dart';
import 'package:chic_wallet/ui/components/loading_dialog.dart';
import 'package:chic_wallet/ui/components/rounded_button.dart';
import 'package:chic_wallet/ui/components/text_field_underline.dart';
import 'package:chic_wallet/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddBankScreen extends StatefulWidget {
  @override
  _AddBankScreenState createState() => _AddBankScreenState();
}

class _AddBankScreenState extends State<AddBankScreen> {
  ThemeProvider _themeProvider;
  BankService _bankService;

  DateTime _validityDate;

  final _cardholderNameFocus = FocusNode();
  TextEditingController _bankNameController = TextEditingController();
  TextEditingController _cardholderNameController = TextEditingController();
  TextEditingController _validityDateController = TextEditingController();
  TextEditingController _cardTypeController = TextEditingController();
  TextEditingController _currencyController = TextEditingController();

  bool _isLoading = false;
  List<String> _errorList = [];

  /// When the bank name is submitted we focus the card holder name field
  _onBankNameSubmitted(String text) {
    FocusScope.of(context).requestFocus(_cardholderNameFocus);
  }

  _onValidityDateSelected(DateTime date) {
    setState(() {
      _validityDate = date;
    });
  }

  _save() {
    if (!_isLoading) {
      setState(() {
        _isLoading = true;
      });

      bool isValid = true;
      List<String> errorList = [];

      // Check the bank name
      if (_bankNameController.text.isEmpty) {
        isValid = false;
        errorList.add(
            AppTranslations.of(context).text("add_bank_error_no_bank_name"));
      }

      // Check the cardholder name
      if (_cardholderNameController.text.isEmpty) {
        isValid = false;
        errorList.add(AppTranslations.of(context)
            .text("add_bank_error_no_cardholder_name"));
      }

      // Check the validity date
      if (_validityDateController.text.isEmpty) {
        isValid = false;
        errorList.add(AppTranslations.of(context)
            .text("add_bank_error_no_validity_date"));
      }

      if (isValid) {
        setState(() {
          _isLoading = false;
        });

        try {
          _bankService.createBank(
            Bank(
              bankName: _bankNameController.text,
              username: _cardholderNameController.text,
              money: 0,
              cardType: _cardTypeController.text,
              expirationDate: _validityDate,
              currency: _currencyController.text,
            ),
          );
        } catch (e) {
          return null;
        }

        Navigator.pop(context);
      } else {
        setState(() {
          _isLoading = false;
        });
      }

      setState(() {
        _errorList = errorList;
      });

      // Hide the keyboard
      FocusScope.of(context).requestFocus(FocusNode());
    }
  }

  @override
  void initState() {
    _cardTypeController.text = LIST_CARD_TYPES[0];
    _currencyController.text = LIST_CURRENCIES_NAMES[0];

    super.initState();
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
    _themeProvider = Provider.of<ThemeProvider>(context, listen: true);
    _bankService = Provider.of<BankService>(context);
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
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
                          textInputAction: TextInputAction.done,
                          hint: AppTranslations.of(context)
                              .text("add_bank_cardholder_name"),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16, bottom: 16),
                        child: TextFieldUnderline(
                          controller: _validityDateController,
                          fieldType: TextFieldType.date,
                          hint: AppTranslations.of(context)
                              .text("add_bank_validity_date"),
                          onDateSelected: _onValidityDateSelected,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16, bottom: 16),
                        child: TextFieldUnderline(
                          controller: _cardTypeController,
                          fieldType: TextFieldType.select,
                          hint: AppTranslations.of(context)
                              .text("add_bank_card_type"),
                          listFields: LIST_CARD_TYPES,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16, bottom: 16),
                        child: TextFieldUnderline(
                          controller: _currencyController,
                          fieldType: TextFieldType.select,
                          hint: AppTranslations.of(context)
                              .text("add_bank_currency"),
                          listFields: LIST_CURRENCIES_NAMES,
                        ),
                      ),
                      _displayError(),
                    ],
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                    child: RoundedButton(
                      onClick: _save,
                      text: AppTranslations.of(context)
                          .text("add_bank_save")
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
