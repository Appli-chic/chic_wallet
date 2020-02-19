import 'package:chic_wallet/localization/app_translations.dart';
import 'package:chic_wallet/models/db/type_transaction.dart';
import 'package:chic_wallet/providers/theme_provider.dart';
import 'package:chic_wallet/services/type_transaction_service.dart';
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
  List<TypeTransaction> _typeTransactionsList = [];

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
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    _themeProvider = Provider.of<ThemeProvider>(context, listen: true);

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
                    Icon(
                      Icons.edit,
                      color: _themeProvider.textColor,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 24, right: 8),
                      child: Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                    )
                  ],
                ),
              ),
              leading: Container(
                padding: EdgeInsets.only(left: 12, right: 12, top: 12, bottom: 12),
                color: TypeTransaction.getColor(_typeTransactionsList[index].color),
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
