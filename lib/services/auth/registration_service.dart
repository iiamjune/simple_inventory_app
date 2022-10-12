import 'package:flutter/cupertino.dart';
import 'package:flutter_application_1/models/auth/registration_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../constants/endpoints.dart';
import '../../constants/globals.dart';

class RegistrationService {
  RegistrationService(this.context);
  BuildContext context;

  /// Creating a map entry.
  static const MapEntry<String, String> accept =
          MapEntry("Accept", "application/json"),
      contentType = MapEntry("Content-Type", "application/json"),
      accessControl = MapEntry("Access-Control-Allow-Origin", "*");

  /// _header() returns a map of strings that contains the accept, contentType, and accessControl
  /// headers
  ///
  /// Returns:
  ///   A map of strings.
  Map<String, String> _header() {
    Map<String, String> content =
        Map.fromEntries([accept, contentType, accessControl]);
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

  /// It takes in a name, email, password, and password confirmation, and returns a Map<String,
  /// dynamic>?
  ///
  /// Args:
  ///   name (String): The name of the user
  ///   email (String): email,
  ///   password (String): password,
  ///   passwordConfirmation (String): passwordConfirmation,
  ///
  /// Returns:
  ///   A Future<Map<String, dynamic>?>
  Future<Map<String, dynamic>?> register(String name, String email,
      String password, String passwordConfirmation) async {
    var client = http.Client();
    var response = await client.post(url(endpoint: EndPoint.register),
        headers: _header(),
        body: registrationModelToJson(RegistrationModel(
            name: name,
            email: email,
            password: password,
            passwordConfirmation: passwordConfirmation)));

    if (response.statusCode == 201) {
      print(json.decode(response.body));
      return json.decode(response.body);
    } else {
      print(json.decode(response.body));
      return json.decode(response.body);
    }
  }
}
