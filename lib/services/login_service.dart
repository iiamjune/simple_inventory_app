import 'package:flutter/cupertino.dart';
import 'package:flutter_application_1/models/registration_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../constants/endpoints.dart';
import '../constants/globals.dart';
import '../models/login_model.dart';

class LoginService {
  LoginService(this.context);
  BuildContext context;

  static MapEntry<String, String> _json =
          MapEntry("Accept", "application/json"),
      contentType = MapEntry("Content-Type", "application/json"),
      accessControl = MapEntry("Access-Control-Allow-Origin", "*");

  Map<String, String> _header() {
    Map<String, String> content =
        Map.fromEntries([_json, contentType, accessControl]);
    return content;
  }

  Uri url({String endpoint = "", String query = ""}) {
    String endpointString = '$baseServerUrl$subString$endpoint';
    String queryString = query.isNotEmpty ? query : '';
    String fullString = '$endpointString$queryString';
    return Uri.parse(fullString);
  }

  Future<Map<String, dynamic>?> login(String email, String password) async {
    var client = http.Client();
    var response = await client.post(url(endpoint: EndPoint.login),
        headers: _header(),
        body: loginModelToJson(LoginModel(
          email: email,
          password: password,
        )));

    if (response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      //TODO: Error Handling
      return json.decode(response.body);
    }
  }
}
