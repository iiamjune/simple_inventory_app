import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_application_1/repositories/auth_repository_interface.dart';
import 'package:http/http.dart' as http;

import '../constants/endpoints.dart';
import '../constants/globals.dart';
import '../models/auth/login_model.dart';
import '../models/auth/registration_model.dart';
import '../services/api_service.dart';

class AuthRepository implements AuthRepositoryInterface {
  AuthRepository(this.context);
  BuildContext context;

  List<MapEntry<String, String>> entries = [accept, contentType, accessControl];

  /// It takes in 4 strings, sends a POST request to the server, and returns a Map<String, dynamic>?
  ///
  /// Args:
  ///   name (String): The name of the user
  ///   email (String): String,
  ///   password (String): The password of the user
  ///   passwordConfirmation (String): passwordConfirmation,
  ///
  /// Returns:
  ///   A Future<Map<String, dynamic>?>
  @override
  Future<Map<String, dynamic>?> register(String name, String email,
      String password, String passwordConfirmation) async {
    try {
      var client = http.Client();
      var response = await client.post(
        ApiService(context).url(endpoint: EndPoint.register),
        headers: await ApiService(context)
            .headers(entries: entries, withToken: false),
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
    return null;
  }

  /// It takes in an email and password, and returns a Map<String, dynamic>?
  ///
  /// Args:
  ///   email (String): email,
  ///   password (String): The password of the user
  ///
  /// Returns:
  ///   A Future<Map<String, dynamic>?>
  @override
  Future<Map<String, dynamic>?> login(String email, String password) async {
    try {
      var client = http.Client();
      var response = await client.post(
        ApiService(context).url(endpoint: EndPoint.login),
        headers: await ApiService(context)
            .headers(entries: entries, withToken: false),
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
    return null;
  }

  /// It takes a token as a parameter, sends a post request to the server, and returns a json response
  ///
  /// Args:
  ///   token (String): The token that was returned from the login function.
  ///
  /// Returns:
  ///   A Future<Map<String, dynamic>?>
  @override
  Future<Map<String, dynamic>?> logout({required String token}) async {
    try {
      var client = http.Client();
      var response = await client.post(
        ApiService(context).url(endpoint: EndPoint.logout),
        headers:
            await ApiService(context).headers(entries: entries, token: token),
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
    return null;
  }
}
