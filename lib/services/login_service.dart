import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../constants/endpoints.dart';
import '../constants/globals.dart';
import '../models/login_model.dart';

class LoginService {
  LoginService(this.context);
  BuildContext context;

  /// Creating a map of headers.
  static MapEntry<String, String> _json =
          const MapEntry("Accept", "application/json"),
      contentType = const MapEntry("Content-Type", "application/json"),
      accessControl = const MapEntry("Access-Control-Allow-Origin", "*");

  /// _header() returns a map of strings that contains the keys "Content-Type",
  /// "Access-Control-Allow-Origin", and "Content-Type" with the values "application/json", "*", and
  /// "application/json" respectively
  ///
  /// Returns:
  ///   A map of strings.
  Map<String, String> _header() {
    Map<String, String> content =
        Map.fromEntries([_json, contentType, accessControl]);
    return content;
  }

  /// It takes an endpoint and a query, and returns a Uri
  ///
  /// Args:
  ///   endpoint (String): The endpoint of the API you're trying to hit.
  ///   query (String): This is the query string that you want to pass to the server.
  ///
  /// Returns:
  ///   A Uri object.
  Uri url({String endpoint = "", String query = ""}) {
    String endpointString = '$baseServerUrl$subString$endpoint';
    String queryString = query.isNotEmpty ? query : '';
    String fullString = '$endpointString$queryString';
    return Uri.parse(fullString);
  }

  /// It takes an email and password, sends a POST request to the server, and returns a Map<String,
  /// dynamic>? (which is a Map of String keys and dynamic values, or null)
  ///
  /// Args:
  ///   email (String): email,
  ///   password (String): The password of the user
  ///
  /// Returns:
  ///   A Future<Map<String, dynamic>?>
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
