import 'package:flutter/cupertino.dart';
import 'package:flutter_application_1/models/auth/registration_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../constants/endpoints.dart';
import '../../constants/globals.dart';

class RegistrationService {
  RegistrationService(this.context);
  BuildContext context;

  List<MapEntry<String, String>> entries = [accept, contentType, accessControl];

  /// It takes in 4 strings, sends a post request to the server, and returns a map of dynamic values
  ///
  /// Args:
  ///   name (String): The name of the user
  ///   email (String): String,
  ///   password (String): The password of the user
  ///   passwordConfirmation (String): passwordConfirmation,
  ///
  /// Returns:
  ///   A Future<Map<String, dynamic>?>
  Future<Map<String, dynamic>?> register(String name, String email,
      String password, String passwordConfirmation) async {
    try {
      var client = http.Client();
      var response = await client.post(
        Globals(context).url(endpoint: EndPoint.register),
        headers:
            await Globals(context).headers(entries: entries, withToken: false),
        body: registrationModelToJson(RegistrationModel(
            name: name,
            email: email,
            password: password,
            passwordConfirmation: passwordConfirmation)),
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
