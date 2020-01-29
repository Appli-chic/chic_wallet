import 'package:chic_wallet/localization/app_translations.dart';
import 'package:chic_wallet/providers/theme_provider.dart';
import 'package:chic_wallet/ui/components/app_bar_image.dart';
import 'package:chic_wallet/ui/components/rounded_button.dart';
import 'package:chic_wallet/ui/components/text_field_underline.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:validate/validate.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  ThemeProvider _themeProvider;
  bool _isLoading = false;
  List<String> _errorList = [];

  /// Evaluates if the [value] is corresponding to an email
  String _validateEmail(String value) {
    try {
      Validate.isEmail(value);
    } catch (e) {
      return 'L\'adresse email doit être une adresse valide';
    }

    return null;
  }

  /// Evaluates if the [value] is corresponding to a valid password.
  /// A valid password must contains at least 6 characters
  String _validatePassword(String value) {
    if (value.length < 6) {
      return 'Le mot de passe doit faire au moins 6 charactères';
    }

    return null;
  }

  _login() async {
    if (!_isLoading) {
      setState(() {
        _isLoading = true;
      });

      bool isValid = true;
      List<String> errorList = [];

      // Check the email
      if (_validateEmail(_emailController.text) != null) {
        isValid = false;
        errorList
            .add(AppTranslations.of(context).text("login_email_not_valid"));
      }

      // Check the password
      if (_validatePassword(_passwordController.text) != null) {
        isValid = false;
        errorList.add(
            AppTranslations.of(context).text("login_email_password_too_short"));
      }

      if (isValid) {

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
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    _themeProvider = Provider.of<ThemeProvider>(context, listen: true);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: _themeProvider.backgroundColor,
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: size.height,
            minWidth: size.width,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  AppBarImage(
                    imageUrl: 'assets/login.jpg',
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                      child: Text(
                        'Login',
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
                      controller: _emailController,
                      hint: "Email",
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16, bottom: 16),
                    child: TextFieldUnderline(
                      controller: _passwordController,
                      hint: "Password",
                      isObscure: true,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16, top: 8),
                    child: Text(
                      'Lost your password?',
                      style: TextStyle(color: _themeProvider.textColor),
                    ),
                  ),
                ],
              ),
              Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    child: RoundedButton(onClick: _login),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 16, right: 16, top: 16, bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'No account yet? ',
                          style:
                              TextStyle(color: _themeProvider.secondTextColor),
                        ),
                        Text(
                          'Sign up now',
                          style: TextStyle(
                            color: _themeProvider.textColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
