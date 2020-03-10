import 'package:chic_wallet/providers/bank_provider.dart';
import 'package:chic_wallet/services/auth_service.dart';
import 'package:chic_wallet/services/bank_service.dart';
import 'package:chic_wallet/services/transaction_service.dart';
import 'package:chic_wallet/services/type_transaction_service.dart';
import 'package:chic_wallet/ui/screens/add_bank_screen.dart';
import 'package:chic_wallet/ui/screens/add_transaction_screen.dart';
import 'package:chic_wallet/ui/screens/login_screen.dart';
import 'package:chic_wallet/ui/screens/manage_category_screen.dart';
import 'package:chic_wallet/ui/screens/new_category_screen.dart';
import 'package:chic_wallet/ui/screens/settings_touch_id_screen.dart';
import 'package:chic_wallet/ui/screens/signup_screen.dart';
import 'package:chic_wallet/ui/screens/splash_screen.dart';
import 'package:chic_wallet/utils/sqlite.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'localization/app_translations_delegate.dart';
import 'localization/application.dart';
import 'models/env.dart';
import 'providers/theme_provider.dart';
import 'ui/screens/main_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(new App());
  });
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  AppTranslationsDelegate _newLocaleDelegate;
  Env _env = Env();

  @override
  void initState() {
    super.initState();

    _newLocaleDelegate = AppTranslationsDelegate(newLocale: null);
    application.onLocaleChanged = onLocaleChange;

    _onLoadEnvFile();
  }

  /// Triggers when the [locale] changes
  void onLocaleChange(Locale locale) {
    setState(() {
      _newLocaleDelegate = AppTranslationsDelegate(newLocale: locale);
    });
  }

  /// Load the env file which contains critic data
  void _onLoadEnvFile() async {
    _env = await EnvParser().load();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>.value(
          value: AuthService(env: _env),
        ),
        Provider<BankService>.value(
          value: BankService(env: _env),
        ),
        Provider<TransactionService>.value(
          value: TransactionService(env: _env),
        ),
        Provider<TypeTransactionService>.value(
          value: TypeTransactionService(env: _env),
        ),
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => BankProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Chic Wallet',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        localizationsDelegates: [
          _newLocaleDelegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('en', ''), // English
          const Locale('fr', ''), // French
        ],
        initialRoute: '/splash',
        routes: {
          '/': (context) => MainScreen(),
          '/splash': (context) => SplashScreen(),
          '/login': (context) => LoginScreen(),
          '/signup': (context) => SignUpScreen(),
          '/add_bank_screen': (context) => AddBankScreen(),
          '/add_transaction_screen': (context) => AddTransactionScreen(),
          '/manage_category_screen': (context) => ManageCategoryScreen(),
          '/add_category': (context) => NewCategoryScreen(),
          '/settings_touch_id': (context) => SettingsTouchIdScreen(),
        },
      ),
    );
  }
}
