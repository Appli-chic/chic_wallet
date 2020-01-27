import 'dart:convert';

import 'package:chic_wallet/models/env.dart';
import 'package:http/http.dart';

const String AUTH_LOGIN = "/auth/login";

class AuthService {
  Client client = Client();
  final Env env;

  AuthService({
    this.env,
  });

  Future<dynamic> login() async {
    final response = await client
        .post('${env.apiUrl}$AUTH_LOGIN');

    if (response.statusCode == 200) {
      return 'something';
//      return User.fromJson(json.decode(response.body));
    } else {
      throw Exception(json.decode(response.body));
    }
  }
}