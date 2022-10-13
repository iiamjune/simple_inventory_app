import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../constants/endpoints.dart';
import '../../constants/globals.dart';
import '../../models/auth/login_model.dart';

class LoginService {
  LoginService(this.context);
  BuildContext context;

  List<MapEntry<String, String>> entries = [accept, contentType, accessControl];

  /// It takes in an email and password, sends a POST request to the server, and returns a Map<String,
  /// dynamic>?
  ///
  /// Args:
  ///   email (String): email,
  ///   password (String): The password of the user
  ///
  /// Returns:
  ///   A Future<Map<String, dynamic>?>
  Future<Map<String, dynamic>?> login(String email, String password) async {
    try {
      var client = http.Client();
      var response = await client.post(
        Globals(context).url(endpoint: EndPoint.login),
        headers:
            await Globals(context).headers(entries: entries, withToken: false),
        body: loginModelToJson(LoginModel(
          email: email,
          password: password,
        )),
      );

      if (response.statusCode == 201) {
        print(json.decode(response.body));
        return json.decode(response.body);
      } else {
        print(json.decode(response.body));
        return json.decode(response.body);
      }
    } catch (e) {
      print(e);
    }
  }
}
