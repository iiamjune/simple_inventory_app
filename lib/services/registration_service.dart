import 'package:flutter/cupertino.dart';
import 'package:flutter_application_1/models/registration_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../constants/endpoints.dart';
import '../constants/globals.dart';

class RegistrationService {
  RegistrationService(this.context);
  BuildContext context;

  static MapEntry<String, String> _json =
      MapEntry("Accept", "application/json");

  Map<String, String> _header() {
    Map<String, String> content = Map.fromEntries([_json]);
    return content;
  }

  Uri url({String endpoint = "", String query = ""}) {
    String endpointString = '$baseServerUrl$subString$endpoint';
    String queryString = query.isNotEmpty ? query : '';
    String fullString = '$endpointString$queryString';
    return Uri.parse(fullString);
  }

  Future<Map<String, dynamic>> register(String name, String email,
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
      return json.decode(response.body);
    }
    return {};
  }
}
