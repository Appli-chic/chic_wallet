import 'package:chic_wallet/localization/app_translations.dart';
import 'package:chic_wallet/providers/theme_provider.dart';
import 'package:chic_wallet/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

class SettingsTouchIdScreen extends StatefulWidget {
  @override
  _SettingsTouchIdScreenState createState() => _SettingsTouchIdScreenState();
}

class _SettingsTouchIdScreenState extends State<SettingsTouchIdScreen> {
  ThemeProvider _themeProvider;
  bool _isActivated = false;
  final storage = new FlutterSecureStorage();

  @override
  void initState() {
    _readTouchIdActivated();
    super.initState();
  }

  _readTouchIdActivated() async {
    bool isAuthActivated = await storage.read(key: KEY_LOCAL_AUTH) == 'true';

    setState(() {
      _isActivated = isAuthActivated;
    });
  }

  _onTouchIdActivatedChange(bool isActivated) async {
    await storage.write(
        key: KEY_LOCAL_AUTH, value: isActivated ? 'true' : 'false');

    setState(() {
      _isActivated = isActivated;
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    _themeProvider = Provider.of<ThemeProvider>(context, listen: true);

    return Scaffold(
      backgroundColor: _themeProvider.secondBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        children: <Widget>[
          MergeSemantics(
            child: ListTile(
              title: Text(
                AppTranslations.of(context).text("touch_id_screen_activated"),
                style: TextStyle(
                  color: _themeProvider.textColor,
                ),
              ),
              trailing: CupertinoSwitch(
                value: _isActivated,
                onChanged: (bool value) {
                  _onTouchIdActivatedChange(value);
                },
              ),
              onTap: () {
                _onTouchIdActivatedChange(!_isActivated);
              },
            ),
          )
        ],
      ),
    );
  }
}
