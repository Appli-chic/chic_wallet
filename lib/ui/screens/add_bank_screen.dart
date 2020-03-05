import 'package:chic_wallet/localization/app_translations.dart';
import 'package:chic_wallet/models/db/bank.dart';
import 'package:chic_wallet/providers/bank_provider.dart';
import 'package:chic_wallet/providers/theme_provider.dart';
import 'package:chic_wallet/services/bank_service.dart';
import 'package:chic_wallet/services/transaction_service.dart';
import 'package:chic_wallet/ui/components/app_bar_image.dart';
import 'package:chic_wallet/ui/components/error_form.dart';
import 'package:chic_wallet/ui/components/loading_dialog.dart';
import 'package:chic_wallet/ui/components/message_dialog.dart';
import 'package:chic_wallet/ui/components/rounded_button.dart';
import 'package:chic_wallet/ui/components/text_field_underline.dart';
import 'package:chic_wallet/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AddBankScreen extends StatefulWidget {
  @override
  _AddBankScreenState createState() => _AddBankScreenState();
}

class _AddBankScreenState extends State<AddBankScreen> {
  ThemeProvider _themeProvider;
  BankService _bankService;
  TransactionService _transactionService;
  BankProvider _bankProvider;

  DateTime _validityDate;

  final _cardholderNameFocus = FocusNode();
  final _priceFocus = FocusNode();
  TextEditingController _bankNameController = TextEditingController();
  TextEditingController _cardholderNameController = TextEditingController();
  TextEditingController _validityDateController = TextEditingController();
  TextEditingController _cardTypeController = TextEditingController();
  TextEditingController _currencyController = TextEditingController();
  TextEditingController _priceController = TextEditingController();

  Bank _bank;
  bool _isLoading = false;
  bool _updateInfoSet = false;
  List<String> _errorList = [];

  /// When the bank name is submitted we focus the card holder name field
  _onBankNameSubmitted(String text) {
    FocusScope.of(context).requestFocus(_cardholderNameFocus);
  }

  /// When the cardholder name is submitted we focus the price field
  _onCardholderNameeSubmitted(String text) {
    FocusScope.of(context).requestFocus(_priceFocus);
  }

  _onValidityDateSelected(DateTime date) {
    setState(() {
      _validityDate = date;
    });
  }

  _delete() async {
    await MessageDialog.display(
      context,
      backgroundColor: _themeProvider.backgroundColor,
      title: Text(
        AppTranslations.of(context).text("dialog_warning"),
        style: TextStyle(
          color: _themeProvider.textColor,
        ),
      ),
      body: Text(
        AppTranslations.of(context).text("dialog_warning_delete_bank"),
        style: TextStyle(
          color: _themeProvider.textColor,
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text(
            AppTranslations.of(context).text("dialog_no"),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          child: Text(
            AppTranslations.of(context).text("dialog_yes"),
            style: TextStyle(
              color: Colors.red,
            ),
          ),
          onPressed: () async {
            // Delete the transactions
            var transactions =
                await _transactionService.getAllByBankId(_bank.id);
            for (var transaction in transactions) {
              await _transactionService.delete(transaction);
            }

            // Delete the subscriptions
            var subscriptions =
                await _transactionService.getSubscriptionsByBankId(_bank);
            for (var subscription in subscriptions) {
              await _transactionService.delete(subscription);
            }

            // Delete the bank account
            await _bankService.delete(_bank);

            Navigator.of(context).pop();
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  _edit() async {
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

      // Check the money is set
      if (_priceController.text.isEmpty) {
        isValid = false;
        errorList
            .add(AppTranslations.of(context).text("add_bank_error_no_money"));
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
          var newBank = Bank(
            id: _bank.id,
            bankName: _bankNameController.text,
            username: _cardholderNameController.text,
            money: double.parse(_priceController.text),
            cardType: _cardTypeController.text,
            expirationDate: _validityDate,
            currency: _currencyController.text,
          );

          await _bankService.update(newBank);
        } catch (e) {
          return null;
        }

        _bankProvider.askReloadData();
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

  _save() async {
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

      // Check the money is set
      if (_priceController.text.isEmpty) {
        isValid = false;
        errorList
            .add(AppTranslations.of(context).text("add_bank_error_no_money"));
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
          await _bankService.save(
            Bank(
              bankName: _bankNameController.text,
              username: _cardholderNameController.text,
              money: double.parse(_priceController.text),
              cardType: _cardTypeController.text,
              expirationDate: _validityDate,
              currency: _currencyController.text,
            ),
          );
        } catch (e) {
          return null;
        }

        _bankProvider.askReloadData();
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

  _setDataInInputs() {
    var dateFormatter = DateFormat("MM/yy");
    String dateString = dateFormatter.format(_bank.expirationDate);

    _bankNameController.text = _bank.bankName;
    _cardholderNameController.text = _bank.username;
    _priceController.text = _bank.money.toStringAsFixed(2);
    _validityDate = _bank.expirationDate;
    _validityDateController.text = dateString;
    _cardTypeController.text = _bank.cardType;
    _currencyController.text = _bank.currency;
  }

  @override
  Widget build(BuildContext context) {
    _themeProvider = Provider.of<ThemeProvider>(context, listen: true);
    _bankProvider = Provider.of<BankProvider>(context, listen: true);
    _bankService = Provider.of<BankService>(context);
    _transactionService = Provider.of<TransactionService>(context);
    _bank = ModalRoute.of(context).settings.arguments;
    final size = MediaQuery.of(context).size;

    if (_bank != null && !_updateInfoSet) {
      _updateInfoSet = true;
      _setDataInInputs();
    }

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
                            _bank != null
                                ? AppTranslations.of(context)
                                    .text("add_bank_title_edit")
                                : AppTranslations.of(context)
                                    .text("add_bank_title"),
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
                          onSubmitted: _onCardholderNameeSubmitted,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16, bottom: 16),
                        child: TextFieldUnderline(
                          controller: _priceController,
                          focus: _priceFocus,
                          inputType:
                              TextInputType.numberWithOptions(decimal: true),
                          textInputAction: TextInputAction.done,
                          hint: AppTranslations.of(context)
                              .text("add_bank_money"),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16, bottom: 16),
                        child: TextFieldUnderline(
                          controller: _validityDateController,
                          fieldType: TextFieldType.date,
                          defaultDate: _validityDate,
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
                          singleSelectDefaultIndex:
                              LIST_CARD_TYPES.indexOf(_cardTypeController.text),
                          listFields: LIST_CARD_TYPES,
                          singleSelectChoose: () {
                            setState(() {});
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16, bottom: 16),
                        child: TextFieldUnderline(
                          controller: _currencyController,
                          fieldType: TextFieldType.select,
                          hint: AppTranslations.of(context)
                              .text("add_bank_currency"),
                          singleSelectDefaultIndex: LIST_CURRENCIES_NAMES
                              .indexOf(_currencyController.text),
                          listFields: LIST_CURRENCIES_NAMES,
                          singleSelectChoose: () {
                            setState(() {});
                          },
                        ),
                      ),
                      _displayError(),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 16, right: 16, bottom: 16, top: 16),
                    child: RoundedButton(
                      onClick: _bank != null ? _edit : _save,
                      text: _bank != null
                          ? AppTranslations.of(context)
                              .text("add_bank_update")
                              .toUpperCase()
                          : AppTranslations.of(context)
                              .text("add_bank_save")
                              .toUpperCase(),
                    ),
                  ),
                  _bank != null
                      ? Padding(
                          padding: const EdgeInsets.only(
                              left: 16, right: 16, bottom: 16, top: 8),
                          child: RoundedButton(
                            onClick: _delete,
                            color: Colors.red,
                            text: AppTranslations.of(context)
                                .text("add_bank_delete")
                                .toUpperCase(),
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
