import 'package:chic_wallet/localization/app_translations.dart';
import 'package:chic_wallet/models/db/type_transaction.dart';
import 'package:chic_wallet/providers/bank_provider.dart';
import 'package:chic_wallet/providers/theme_provider.dart';
import 'package:chic_wallet/services/transaction_service.dart';
import 'package:chic_wallet/services/type_transaction_service.dart';
import 'package:chic_wallet/ui/components/icon_picker/message_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class ManageCategoryScreen extends StatefulWidget {
  @override
  _ManageCategoryScreenState createState() => _ManageCategoryScreenState();
}

class _ManageCategoryScreenState extends State<ManageCategoryScreen> {
  ThemeProvider _themeProvider;
  TypeTransactionService _typeTransactionService;
  TransactionService _transactionService;
  BankProvider _bankProvider;

  List<TypeTransaction> _typeTransactionsList = [];

  didChangeDependencies() {
    super.didChangeDependencies();

    if (_typeTransactionService == null) {
      _typeTransactionService = Provider.of<TypeTransactionService>(context);
      _loadAllTypeTransactions();
    }
  }

  _loadAllTypeTransactions() async {
    _typeTransactionsList = await _typeTransactionService.getAll();
    setState(() {});
  }

  _onDeleteCategory(int index) async {
    var transactionsFromCategory =
        await _transactionService.getAllByBankIdAndTypeTransactionId(
            _bankProvider.selectedBank.id, _typeTransactionsList[index].id);

    if (transactionsFromCategory.isNotEmpty) {
      // Displays error
      await MessageDialog.display(
        context,
        backgroundColor: _themeProvider.backgroundColor,
        title: Text(
          AppTranslations.of(context).text("dialog_error"),
          style: TextStyle(
            color: _themeProvider.textColor,
          ),
        ),
        body: Text(
          AppTranslations.of(context)
              .text("dialog_error_cant_delete_category_transactions_active"),
          style: TextStyle(
            color: _themeProvider.textColor,
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text(
              AppTranslations.of(context).text("dialog_ok"),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    } else {
      // Delete the category
      await _typeTransactionService.delete(_typeTransactionsList[index]);
      await _loadAllTypeTransactions();
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    _themeProvider = Provider.of<ThemeProvider>(context, listen: true);
    _bankProvider = Provider.of<BankProvider>(context, listen: true);
    _transactionService = Provider.of<TransactionService>(context);

    return Scaffold(
      backgroundColor: _themeProvider.secondBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(AppTranslations.of(context).text("manage_category_title")),
        actions: <Widget>[
          IconButton(
            onPressed: () async {
              await Navigator.pushNamed(context, '/add_category');
              _loadAllTypeTransactions();
            },
            icon: Icon(
              Icons.add,
              color: _themeProvider.textColor,
            ),
          ),
        ],
      ),
      body: Container(
        child: ListView.builder(
          itemCount: _typeTransactionsList.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              contentPadding: EdgeInsets.only(right: 16, top: 0, bottom: 0),
              title: Text(
                _typeTransactionsList[index].title,
                style: TextStyle(
                  color: _themeProvider.textColor,
                ),
              ),
              trailing: Container(
                width: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    IconButton(
                      onPressed: () async {
                        await Navigator.pushNamed(
                          context,
                          '/add_category',
                          arguments: _typeTransactionsList[index],
                        );
                        _loadAllTypeTransactions();
                      },
                      icon: Icon(
                        Icons.edit,
                        color: _themeProvider.textColor,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        _onDeleteCategory(index);
                      },
                      icon: Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
              leading: Container(
                padding:
                    EdgeInsets.only(left: 12, right: 12, top: 12, bottom: 12),
                color: TypeTransaction.getColor(
                    _typeTransactionsList[index].color),
                child: Icon(
                  TypeTransaction.getIconData(
                      _typeTransactionsList[index].iconName),
                  color: _themeProvider.textColor,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
