import 'package:chic_wallet/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/env.dart';
import 'ui/screens/home_screen.dart';

void main() => runApp(App());

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {

  Env _env = Env();

  @override
  void initState() {
    super.initState();
    _onLoadEnvFile();
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
      ],
      child: MaterialApp(
        title: 'Chic Wallet',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/home',
        routes: {
          '/home': (context) => HomeScreen(),
        },
      ),
    );
  }
}