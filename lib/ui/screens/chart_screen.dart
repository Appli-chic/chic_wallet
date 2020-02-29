import 'package:chic_wallet/localization/app_translations.dart';
import 'package:chic_wallet/models/db/transaction.dart';
import 'package:chic_wallet/models/db/type_transaction.dart';
import 'package:chic_wallet/providers/bank_provider.dart';
import 'package:chic_wallet/providers/theme_provider.dart';
import 'package:chic_wallet/services/transaction_service.dart';
import 'package:chic_wallet/ui/components/area_chart.dart';
import 'package:chic_wallet/ui/components/bank_body.dart';
import 'package:chic_wallet/ui/components/circle_chart.dart';
import 'package:chic_wallet/ui/components/transaction_type_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TransactionTypeGroupData {
  int idType;
  String typeName;
  double amount;
  Color color;
  IconData icon;

  TransactionTypeGroupData({
    this.idType,
    this.typeName,
    this.amount,
    this.color,
    this.icon,
  });
}

class ChartScreen extends StatefulWidget {
  @override
  _ChartScreenState createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin<ChartScreen> {
  ThemeProvider _themeProvider;
  BankProvider _bankProvider;
  TransactionService _transactionService;

  List<TransactionTypeGroupData> _transactionsGroup = [];
  List<Transaction> _transactions = [];
  TabController _tabController;
  bool _isLoadingData = true;

  _loadMonthTransactions() async {
    _transactionsGroup = [];

    if (_bankProvider.selectedBank != null) {
      var transactions = await _transactionService.getTransactionsForTheMonth(
          _bankProvider.selectedBank.id, DateTime.now());

      for (var transaction in transactions) {
        var transactionTypeData = _transactionsGroup
            .where((d) => d.idType == transaction.typeTransaction.id)
            .toList();

        if (transactionTypeData.isEmpty) {
          var color =
              TypeTransaction.getColor(transaction.typeTransaction.color);

          _transactionsGroup.add(
            TransactionTypeGroupData(
              idType: transaction.typeTransaction.id,
              typeName: transaction.typeTransaction.title,
              amount: transaction.price,
              color: color,
              icon: TypeTransaction.getIconData(
                  transaction.typeTransaction.iconName),
            ),
          );
        } else {
          transactionTypeData[0].amount += transaction.price;
        }
      }

      // Sort by amount
      _transactionsGroup.sort((groupData1, groupData2) {
        if (groupData1.amount > groupData2.amount) {
          return 1;
        } else {
          return 0;
        }
      });
    }

    setState(() {
      _isLoadingData = false;
    });
  }

  _loadMonthSubscriptions() async {
    _transactionsGroup = [];

    if (_bankProvider.selectedBank != null) {
      var transactions = await _transactionService.getSubscriptionsForTheMonth(
          _bankProvider.selectedBank.id, DateTime.now());

      for (var transaction in transactions) {
        var transactionTypeData = _transactionsGroup
            .where((d) => d.idType == transaction.typeTransaction.id)
            .toList();

        if (transactionTypeData.isEmpty) {
          var color =
              TypeTransaction.getColor(transaction.typeTransaction.color);

          _transactionsGroup.add(
            TransactionTypeGroupData(
              idType: transaction.typeTransaction.id,
              typeName: transaction.typeTransaction.title,
              amount: transaction.price,
              color: color,
              icon: TypeTransaction.getIconData(
                  transaction.typeTransaction.iconName),
            ),
          );
        } else {
          transactionTypeData[0].amount += transaction.price;
        }
      }

      // Sort by amount
      _transactionsGroup.sort((groupData1, groupData2) {
        if (groupData1.amount > groupData2.amount) {
          return 1;
        } else {
          return 0;
        }
      });
    }

    setState(() {
      _isLoadingData = false;
    });
  }

  _loadAllTransactions() async {
    if (_bankProvider.selectedBank != null) {
      _transactions = await _transactionService
          .getAllByBankId(_bankProvider.selectedBank.id);
    }

    setState(() {
      _isLoadingData = false;
    });
  }

  Widget _displayCategoriesChart() {
    if (_bankProvider.needToReloadChart) {
      _isLoadingData = true;
      _bankProvider.chartPageReloaded();
      _loadMonthTransactions();
    }

    if (_isLoadingData) {
      return Container();
    }

    return Column(
      children: <Widget>[
        Center(
          child: CircleChart(
            transactionsGroup: _transactionsGroup,
          ),
        ),
        ListView.builder(
          padding: EdgeInsets.only(top: 0, bottom: 20, left: 16, right: 16),
          physics: NeverScrollableScrollPhysics(),
          itemCount: _transactionsGroup.length,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            return TransactionTypeCard(
              bank: _bankProvider.selectedBank,
              transactionTypeGroupData: _transactionsGroup[index],
            );
          },
        ),
      ],
    );
  }

  Widget _displayEvolution() {
    if (_bankProvider.needToReloadChart) {
      _isLoadingData = true;
      _bankProvider.chartPageReloaded();
      _loadAllTransactions();
    }

    if (_isLoadingData) {
      return Container();
    }

    return AreaChart(
      transactions: _transactions,
    );
  }

  Widget _displaysSubscriptionCharts() {
    if (_bankProvider.needToReloadChart) {
      _isLoadingData = true;
      _bankProvider.chartPageReloaded();
      _loadMonthSubscriptions();
    }

    if (_isLoadingData) {
      return Container();
    }

    return Column(
      children: <Widget>[
        Center(
          child: CircleChart(
            transactionsGroup: _transactionsGroup,
          ),
        ),
        ListView.builder(
          padding: EdgeInsets.only(top: 0, bottom: 20, left: 16, right: 16),
          physics: NeverScrollableScrollPhysics(),
          itemCount: _transactionsGroup.length,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            return TransactionTypeCard(
              bank: _bankProvider.selectedBank,
              transactionTypeGroupData: _transactionsGroup[index],
            );
          },
        ),
      ],
    );
  }

  Widget _displaysCharts() {
    if (_tabController.index == 0) {
      return _displayCategoriesChart();
    } else if (_tabController.index == 1) {
      return _displayEvolution();
    } else if (_tabController.index == 2) {
      return _displaysSubscriptionCharts();
    }

    return Container();
  }

  didChangeDependencies() {
    super.didChangeDependencies();

    if (_bankProvider == null) {
      _bankProvider = Provider.of<BankProvider>(context, listen: true);
    }

    if (_transactionService == null) {
      _transactionService = Provider.of<TransactionService>(context);
      _loadMonthTransactions();
    }
  }

  @override
  void initState() {
    _tabController = TabController(vsync: this, length: 3);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _themeProvider = Provider.of<ThemeProvider>(context, listen: true);
    _bankProvider = Provider.of<BankProvider>(context, listen: true);

    return BankBody(
      height: 310,
      label: Container(
        padding: EdgeInsets.only(bottom: 10),
        child: TabBar(
          controller: _tabController,
          isScrollable: false,
          unselectedLabelColor: _themeProvider.thirdTextColor,
          labelColor: _themeProvider.textColor,
          indicatorColor: Colors.transparent,
          onTap: (index) {
            _bankProvider.askReloadChartPage();
          },
          tabs: <Widget>[
            Text(
              AppTranslations.of(context).text("chart_screen_categories"),
              style: TextStyle(fontSize: 16),
            ),
            Text(
              AppTranslations.of(context).text("chart_screen_evolution"),
              style: TextStyle(fontSize: 16),
            ),
            Text(
              AppTranslations.of(context).text("chart_screen_subscriptions"),
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
      child: Container(
        margin: EdgeInsets.only(top: 310),
        child: _displaysCharts(),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
