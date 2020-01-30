
import 'package:flutter/material.dart';

class Token {
  final String accessToken;
  final String refreshToken;

  Token({
    @required this.accessToken,
    @required this.refreshToken,
  });

  factory Token.fromJson(Map<String, dynamic> jsonMap) {
    return new Token(
      refreshToken: jsonMap["refresh_token"],
      accessToken: jsonMap["access_token"],
    );
  }
}