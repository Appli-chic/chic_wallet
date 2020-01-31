import 'dart:convert';

import 'package:chic_wallet/models/api_error.dart';
import 'package:chic_wallet/models/env.dart';
import 'package:chic_wallet/models/token.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';

const String ERROR_EMAIL_OR_PASSWORD_INCORRECT = "Email or password incorrect";
const String ERROR_EMAIL_ALREADY_EXISTS = "User already exists";

class AuthService {
  static String authLogin = "/auth/login";
  static String authSignUp = "/auth/signup";
  static String authRefreshToken = "/auth/refresh";

  Client client = Client();
  final Env env;

  AuthService({
    this.env,
  });

  /// Login the user with an [email] and a [password]
  ///
  /// Throws [ApiError] if the [email] or [password] is wrong.
  Future<void> login(String email, String password) async {
    final response = await client.post(
      '${env.apiUrl}$authLogin',
      body: {
        "username": email,
        "password": password,
      },
    );

    if (response.statusCode == 200) {
      // Register the token
      final storage = FlutterSecureStorage();
      Token token = Token.fromJson(json.decode(response.body));

      // Store the token
      await storage.write(key: env.accessTokenKey, value: token.accessToken);
      await storage.write(key: env.refreshTokenKey, value: token.refreshToken);

      // Add the timer to refresh the token
      refreshAccessTokenTimer();
    } else {
      throw ApiError.fromJson(json.decode(response.body));
    }
  }

  /// Signup the user with an [email], [password]
  ///
  /// Throws [ApiError] if the [email] already exists.
  Future<void> signUp(String email, String password) async {
    var response = await client.post("${env.apiUrl}$authSignUp",
        body: {"username": email, "password": password});

    if (response.statusCode == 201) {
      // Retrieve the tokens
      final storage = FlutterSecureStorage();
      Token token = Token.fromJson(json.decode(response.body));

      // Store the tokens
      await storage.write(key: env.accessTokenKey, value: token.accessToken);
      await storage.write(key: env.refreshTokenKey, value: token.refreshToken);

      // Add the timer to refresh the token
      refreshAccessTokenTimer();
    } else {
      throw ApiError.fromJson(json.decode(response.body));
    }
  }

  /// Check if the user is logged in
  Future<bool> isLoggedIn() async {
    final storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: env.accessTokenKey);
//    await storage.delete(key: env.accessTokenKey);

    if (accessToken != null && env.accessTokenKey.isNotEmpty) {
      // Add the timer to refresh the token
      try {
        await refreshAccessToken();
      } catch (e) {}
      return true;
    } else {
      return false;
    }
  }

  // Retrieve the access token
  Future<String> getAccessToken() async {
    final storage = FlutterSecureStorage();
    return await storage.read(key: env.accessTokenKey);
  }

  // Refresh the access token each time it delayed
  Future<void> refreshAccessToken() async {
    final storage = FlutterSecureStorage();
    final refreshToken = await storage.read(key: env.refreshTokenKey);

    var response = await client.post("${env.apiUrl}$authRefreshToken",
        body: json.encode({"refresh_token": refreshToken}));

    if (response.statusCode == 200) {
      // Retrieve the tokens
      Token token = Token.fromJson(json.decode(response.body));

      // Store the tokens
      await storage.write(key: env.accessTokenKey, value: token.accessToken);
      refreshAccessTokenTimer();
    } else {
      throw ApiError.fromJson(json.decode(response.body));
    }
  }

  // A timer to refresh the access token
  refreshAccessTokenTimer() async {
    var newTime = 40000;
    await Future.delayed(Duration(milliseconds: newTime));

    try {
      await refreshAccessToken();
      refreshAccessTokenTimer();
    } catch (e) {
      await refreshAccessToken();
      refreshAccessTokenTimer();
    }
  }
}
