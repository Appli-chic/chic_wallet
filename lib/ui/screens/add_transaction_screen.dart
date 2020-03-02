import 'package:chic_wallet/localization/app_translations.dart';
import 'package:chic_wallet/models/db/transaction.dart';
import 'package:chic_wallet/models/db/type_transaction.dart';
import 'package:chic_wallet/providers/bank_provider.dart';
import 'package:chic_wallet/providers/theme_provider.dart';
import 'package:chic_wallet/services/bank_service.dart';
import 'package:chic_wallet/services/transaction_service.dart';
import 'package:chic_wallet/services/type_transaction_service.dart';
import 'package:chic_wallet/ui/components/bank_body.dart';
import 'package:chic_wallet/ui/components/error_form.dart';
import 'package:chic_wallet/ui/components/message_dialog.dart';
import 'package:chic_wallet/ui/components/rounded_button.dart';
import 'package:chic_wallet/ui/components/text_field_underline.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AddTransactionScreen extends StatefulWidget {
  @override
  _AddTransactionScreenState createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  ThemeProvider _themeProvider;
  BankProvider _bankProvider;
  TypeTransactionService _typeTransactionService;
  TransactionService _transactionService;
  BankService _bankService;

  List<String> _typeTransactionsTextList = [];
  List<TypeTransaction> _typeTransactionsList = [];
  List<String> _numberDayInYearList = [];

  final _descriptionFocus = FocusNode();
  final _priceFocus = FocusNode();
  List<String> _errorList = [];

  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _categoryController = TextEditingController();
  TextEditingController _repeatController = TextEditingController();
  TextEditingController _repeatDateController = TextEditingController();

  int _paymentType = 0;
  int _indexRepeat = -1;
  int _nbRepeat = -1;
  DateTime _subscriptionDate;

  bool _updateInfoSet = false;
  Transaction _transaction;

  didChangeDependencies() {
    super.didChangeDependencies();

    if (_typeTransactionService == null) {
      _typeTransactionService =
          Provider.of<TypeTransactionService>(context, listen: true);
      _loadAllTypeTransactions();
    }
  }

  _loadAllTypeTransactions() async {
    _typeTransactionsList = await _typeTransactionService.getAll();

    List<String> typeTransactionString = [];
    _typeTransactionsList.forEach((tt) {
      typeTransactionString.add(tt.title);
    });

    if (_categoryController.text.isEmpty) {
      _categoryController.text = typeTransactionString[0];
    }

    setState(() {
      _typeTransactionsTextList = typeTransactionString;
    });
  }

  _onSubscriptionDateSelected(DateTime date) {
    setState(() {
      _subscriptionDate = date;
    });
  }

  _onTitleSubmitted(String text) {
    FocusScope.of(context).requestFocus(_descriptionFocus);
  }

  _onDescriptionSubmitted(String text) {
    FocusScope.of(context).requestFocus(_priceFocus);
  }

  _delete() async {
    if (_transaction.startSubscriptionDate == null) {
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
          AppTranslations.of(context).text("dialog_warning_delete_transaction"),
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
              var newBank = _bankProvider.selectedBank;
              newBank.money -= _transaction.price;
              await _bankService.update(newBank);

              await _transactionService.delete(_transaction);

              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    }
  }

  _update() async {
    bool isValid = true;
    List<String> errorList = [];

    // Check the title
    if (_titleController.text.isEmpty) {
      isValid = false;
      errorList
          .add(AppTranslations.of(context).text("add_transaction_empty_title"));
    }

    // Check the price
    if (_priceController.text.isEmpty) {
      isValid = false;
      errorList
          .add(AppTranslations.of(context).text("add_transaction_empty_price"));
    }

    // Check the bank
    if (_bankProvider.banks.isEmpty) {
      isValid = false;
      errorList
          .add(AppTranslations.of(context).text("add_transaction_empty_bank"));
    }

    if (_repeatController.text.isNotEmpty && _subscriptionDate == null) {
      isValid = false;
      errorList.add(AppTranslations.of(context)
          .text("add_transaction_empty_subscription_date"));
    }

    if (isValid) {
      var category = _typeTransactionsList
          .where((tt) => tt.title == _categoryController.text)
          .toList()[0];
      var typeTransactionIndex = _typeTransactionsList.indexOf(category);
      var transaction = Transaction(
        id: _transaction.id,
        title: _titleController.text,
        description: _descriptionController.text,
        price: _paymentType == 0
            ? -double.parse(_priceController.text)
            : double.parse(_priceController.text),
        date: DateTime.now(),
        typeTransaction: _typeTransactionsList[typeTransactionIndex],
        bank: _bankProvider.selectedBank,
        nbDayRepeat: _nbRepeat == -1 ? null : _nbRepeat,
        indexTypeRepeat: _indexRepeat == -1 ? null : _indexRepeat,
        startSubscriptionDate: _subscriptionDate,
      );

      var newBank = _bankProvider.selectedBank;
      if (transaction.startSubscriptionDate == null) {
        await _transactionService.update(transaction);

        newBank.money -= _transaction.price;
        newBank.money += _paymentType == 0
            ? -double.parse(_priceController.text)
            : double.parse(_priceController.text);
        await _bankService.update(newBank);
      } else {
        // Manage subscription money
//        var addedTransactions = await _transactionService
//            .addTransactionsFromSubscription(transaction);
//
//        for (var addedTransaction in addedTransactions) {
//          newBank.money += addedTransaction.price;
//          await _bankService.update(newBank);
//        }
      }

      _bankProvider.askReloadData();
      Navigator.pop(context);
    }

    setState(() {
      _errorList = errorList;
    });

    // Hide the keyboard
    FocusScope.of(context).requestFocus(FocusNode());
  }

  _addTransaction() async {
    bool isValid = true;
    List<String> errorList = [];

    // Check the title
    if (_titleController.text.isEmpty) {
      isValid = false;
      errorList
          .add(AppTranslations.of(context).text("add_transaction_empty_title"));
    }

    // Check the price
    if (_priceController.text.isEmpty) {
      isValid = false;
      errorList
          .add(AppTranslations.of(context).text("add_transaction_empty_price"));
    }

    // Check the bank
    if (_bankProvider.banks.isEmpty) {
      isValid = false;
      errorList
          .add(AppTranslations.of(context).text("add_transaction_empty_bank"));
    }

    if (_repeatController.text.isNotEmpty && _subscriptionDate == null) {
      isValid = false;
      errorList.add(AppTranslations.of(context)
          .text("add_transaction_empty_subscription_date"));
    }

    if (isValid) {
      var category = _typeTransactionsList
          .where((tt) => tt.title == _categoryController.text)
          .toList()[0];
      var typeTransactionIndex = _typeTransactionsList.indexOf(category);
      var transaction = Transaction(
        title: _titleController.text,
        description: _descriptionController.text,
        price: _paymentType == 0
            ? -double.parse(_priceController.text)
            : double.parse(_priceController.text),
        date: DateTime.now(),
        typeTransaction: _typeTransactionsList[typeTransactionIndex],
        bank: _bankProvider.selectedBank,
        nbDayRepeat: _nbRepeat == -1 ? null : _nbRepeat,
        indexTypeRepeat: _indexRepeat == -1 ? null : _indexRepeat,
        startSubscriptionDate: _subscriptionDate,
      );

      var transactionId = await _transactionService.save(transaction);
      transaction.id = transactionId;

      var newBank = _bankProvider.selectedBank;
      if (transaction.startSubscriptionDate == null) {
        newBank.money += _paymentType == 0
            ? -double.parse(_priceController.text)
            : double.parse(_priceController.text);
        await _bankService.update(newBank);
      } else {
        var addedTransactions = await _transactionService
            .addTransactionsFromSubscription(transaction);

        for (var addedTransaction in addedTransactions) {
          newBank.money += addedTransaction.price;
          await _bankService.update(newBank);
        }
      }

      _bankProvider.askReloadData();
      Navigator.pop(context);
    }

    setState(() {
      _errorList = errorList;
    });

    // Hide the keyboard
    FocusScope.of(context).requestFocus(FocusNode());
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

  _onMultipleSelectChose(
      int index1, String result1, int index2, String result2) {
    _indexRepeat = index2;
    _nbRepeat = int.parse(result1);

    // Write a text corresponding to the selection
    bool isSingular = true;

    if (result1 != "1") {
      isSingular = false;
    }

    if (isSingular) {
      switch (index2) {
        case 0:
          _repeatController.text = AppTranslations.of(context)
              .text("add_transaction_repeat_every_day");
          break;
        case 1:
          _repeatController.text = AppTranslations.of(context)
              .text("add_transaction_repeat_every_week");
          break;
        case 2:
          _repeatController.text = AppTranslations.of(context)
              .text("add_transaction_repeat_every_month");
          break;
        case 3:
          _repeatController.text = AppTranslations.of(context)
              .text("add_transaction_repeat_every_year");
          break;
      }
    } else {
      switch (index2) {
        case 0:
          _repeatController.text = AppTranslations.of(context).textWithArgument(
              "add_transaction_repeat_every_many_day", result1);
          break;
        case 1:
          _repeatController.text = AppTranslations.of(context).textWithArgument(
              "add_transaction_repeat_every_many_week", result1);
          break;
        case 2:
          _repeatController.text = AppTranslations.of(context).textWithArgument(
              "add_transaction_repeat_every_many_month", result1);
          break;
        case 3:
          _repeatController.text = AppTranslations.of(context).textWithArgument(
              "add_transaction_repeat_every_many_year", result1);
          break;
      }
    }

    setState(() {});
  }

  _setDataInInputs() {
    _titleController.text = _transaction.title;
    _descriptionController.text = _transaction.description;
    _priceController.text = _transaction.price.abs().toStringAsFixed(2);
    _categoryController.text = _transaction.typeTransaction.title;

    if (_transaction.transaction.id != null) {
      // Add the subscription information
      _onMultipleSelectChose(
          _transaction.transaction.nbDayRepeat - 1,
          _transaction.transaction.nbDayRepeat.toString(),
          _transaction.transaction.indexTypeRepeat,
          AppTranslations.of(context).list("add_transaction_repeat_list")[
              _transaction.transaction.indexTypeRepeat]);

      var dateFormatter = DateFormat("MM/dd/yyyy");
      String dateString =
          dateFormatter.format(_transaction.transaction.startSubscriptionDate);
      _repeatDateController.text = dateString;
      _subscriptionDate = _transaction.transaction.startSubscriptionDate;
    }

    if (_transaction.price >= 0) {
      _paymentType = 1;
    }
  }

  @override
  void initState() {
    for (var i = 1; i != 366; i++) {
      _numberDayInYearList.add(i.toString());
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    _themeProvider = Provider.of<ThemeProvider>(context, listen: true);
    _bankProvider = Provider.of<BankProvider>(context, listen: true);
    _transactionService = Provider.of<TransactionService>(context);
    _bankService = Provider.of<BankService>(context);
    _transaction = ModalRoute.of(context).settings.arguments;

    final size = MediaQuery.of(context).size;

    if (_transaction != null && !_updateInfoSet) {
      _updateInfoSet = true;
      _setDataInInputs();
    }

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
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Center(
                          child: Text(
                            _transaction != null
                                ? AppTranslations.of(context)
                                    .text("add_transaction_screen_title_edit")
                                : AppTranslations.of(context)
                                    .text("add_transaction_screen_title"),
                            style: TextStyle(
                              color: _themeProvider.textColor,
                              fontSize: 24,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8, bottom: 8),
                        child: CupertinoSlidingSegmentedControl(
                          groupValue: _paymentType,
                          backgroundColor: _themeProvider.thirdBackgroundColor,
                          thumbColor: _themeProvider.firstColor,
                          onValueChanged: (value) {
                            setState(() {
                              _paymentType = value;
                            });
                          },
                          children: {
                            0: Text(
                              AppTranslations.of(context)
                                  .text("add_transaction_payment"),
                              style: TextStyle(color: _themeProvider.textColor),
                            ),
                            1: Text(
                              AppTranslations.of(context)
                                  .text("add_transaction_receiving"),
                              style: TextStyle(color: _themeProvider.textColor),
                            ),
                          },
                        ),
                      ),
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
                          inputType:
                              TextInputType.numberWithOptions(decimal: true),
                          hint: AppTranslations.of(context)
                              .text("add_transaction_price"),
                          textInputAction: TextInputAction.done,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16, bottom: 16),
                        child: TextFieldUnderline(
                          controller: _repeatController,
                          fieldType: TextFieldType.multipleSelect,
                          listFields: _numberDayInYearList,
                          listFields2: AppTranslations.of(context)
                              .list("add_transaction_repeat_list"),
                          multiSelectDefaultIndex1: _nbRepeat - 1,
                          multiSelectDefaultIndex2: _indexRepeat,
                          onMultipleSelectChose: _onMultipleSelectChose,
                          multiSelectChoose: () {
                            setState(() {});
                          },
                          onDeletePressed: () {
                            _repeatController.text = "";
                            _indexRepeat = -1;
                            _nbRepeat = -1;
                            setState(() {});
                          },
                          hint: AppTranslations.of(context)
                              .text("add_transaction_repeat"),
                        ),
                      ),
                      _repeatController.text.isNotEmpty
                          ? Padding(
                              padding:
                                  const EdgeInsets.only(top: 16, bottom: 16),
                              child: TextFieldUnderline(
                                controller: _repeatDateController,
                                fieldType: TextFieldType.date,
                                hint: AppTranslations.of(context)
                                    .text("add_transaction_subscription_date"),
                                onDateSelected: _onSubscriptionDateSelected,
                                defaultDate: _subscriptionDate,
                                dateFormatString: "MM/dd/yyyy",
                              ),
                            )
                          : Container(),
                      Padding(
                        padding: const EdgeInsets.only(top: 16, bottom: 16),
                        child: TextFieldUnderline(
                          controller: _categoryController,
                          fieldType: TextFieldType.select,
                          listFields: _typeTransactionsTextList,
                          singleSelectDefaultIndex: _typeTransactionsTextList
                              .indexOf(_categoryController.text),
                          singleSelectChoose: () {
                            setState(() {});
                          },
                          hint: AppTranslations.of(context)
                              .text("add_transaction_type"),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          await Navigator.pushNamed(
                              context, '/manage_category_screen');
                          _loadAllTypeTransactions();
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 8, bottom: 16, left: 16, right: 16),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              AppTranslations.of(context)
                                  .text("add_transaction_add_category"),
                              style: TextStyle(
                                color: _themeProvider.textColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                      _displayError(),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        bottom: 16, left: 16, right: 16, top: 16),
                    child: RoundedButton(
                      onClick: _transaction != null ? _update : _addTransaction,
                      text: _transaction != null
                          ? AppTranslations.of(context)
                              .text("add_transaction_edit")
                              .toUpperCase()
                          : AppTranslations.of(context)
                              .text("add_transaction_add")
                              .toUpperCase(),
                    ),
                  ),
                  _transaction != null
                      ? Padding(
                          padding: const EdgeInsets.only(
                              left: 16, right: 16, bottom: 16, top: 8),
                          child: RoundedButton(
                            onClick: _delete,
                            color: Colors.red,
                            text: AppTranslations.of(context)
                                .text("add_transaction_delete")
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
