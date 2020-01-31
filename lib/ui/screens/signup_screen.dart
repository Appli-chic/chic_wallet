import 'package:chic_wallet/localization/app_translations.dart';
import 'package:chic_wallet/models/api_error.dart';
import 'package:chic_wallet/providers/theme_provider.dart';
import 'package:chic_wallet/services/auth_service.dart';
import 'package:chic_wallet/ui/components/app_bar_image.dart';
import 'package:chic_wallet/ui/components/error_form.dart';
import 'package:chic_wallet/ui/components/loading_dialog.dart';
import 'package:chic_wallet/ui/components/rounded_button.dart';
import 'package:chic_wallet/ui/components/text_field_underline.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:validate/validate.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  ThemeProvider _themeProvider;
  AuthService _authService;
  bool _isLoading = false;
  List<String> _errorList = [];

  final _passwordFocus = FocusNode();
  final _confirmPasswordFocus = FocusNode();

  /// When the email is submitted we focus the password field
  _onEmailSubmitted(String text) {
    FocusScope.of(context).requestFocus(_passwordFocus);
  }

  /// When the password is submitted we focus the confirmed password field
  _onPasswordSubmitted(String text) {
    FocusScope.of(context).requestFocus(_confirmPasswordFocus);
  }

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

  _signUp() async {
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

      // Check the passwords are identical
      if (_passwordController.text != _confirmPasswordController.text) {
        isValid = false;
        errorList.add(AppTranslations.of(context)
            .text("sign_up_passwords_not_identical"));
      }

      if (isValid) {
        // Sign up the user
        try {
          await _authService.signUp(
              _emailController.text, _passwordController.text);

          setState(() {
            _isLoading = false;
          });

          Navigator.pop(context);
          Navigator.pushReplacementNamed(context, '/');
        } catch (e) {
          setState(() {
            _isLoading = false;
          });

          if (e is ApiError) {
            if (e.message == ERROR_EMAIL_ALREADY_EXISTS) {
              errorList.add(AppTranslations.of(context)
                  .text("sign_up_email_already_exists"));
            } else {
              errorList.add(AppTranslations.of(context).text("error_server"));
            }
          } else {
            errorList.add(AppTranslations.of(context).text("error_server"));
          }
        }
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
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    _themeProvider = Provider.of<ThemeProvider>(context, listen: true);
    _authService = Provider.of<AuthService>(context);

    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: _themeProvider.backgroundColor,
      body: LoadingDialog(
        isDisplayed: _isLoading,
        child: SingleChildScrollView(
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      AppBarImage(
                        imageUrl: 'assets/signup.jpg',
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Center(
                          child: Text(
                            AppTranslations.of(context).text("sign_up_sign_up"),
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
                          onSubmitted: _onEmailSubmitted,
                          hint: AppTranslations.of(context).text("login_email"),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16, bottom: 16),
                        child: TextFieldUnderline(
                          onSubmitted: _onPasswordSubmitted,
                          focus: _passwordFocus,
                          controller: _passwordController,
                          hint: AppTranslations.of(context).text("login_password"),
                          isObscure: true,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16, bottom: 16),
                        child: TextFieldUnderline(
                          focus: _confirmPasswordFocus,
                          controller: _confirmPasswordController,
                          hint: AppTranslations.of(context).text("sign_up_confirm_password"),
                          isObscure: true,
                          textInputAction: TextInputAction.done,
                        ),
                      ),
                      _displayError(),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                        child: RoundedButton(
                          onClick: _signUp,
                          text: AppTranslations.of(context)
                              .text("sign_up_sign_up")
                              .toUpperCase(),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
