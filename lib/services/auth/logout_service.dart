import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../../constants/endpoints.dart';
import '../../constants/globals.dart';

class LogoutService {
  LogoutService(this.context);
  BuildContext context;

  List<MapEntry<String, String>> entries = [accept, contentType, accessControl];

  /// It takes a token and returns a Map<String, dynamic>?
  ///
  /// Args:
  ///   token (String): The token that was returned from the login function.
  ///
  /// Returns:
  ///   A Map<String, dynamic>?
  Future<Map<String, dynamic>?> logout({required String token}) async {
    try {
      var client = http.Client();
      var response = await client.post(
        Globals(context).url(endpoint: EndPoint.logout),
        headers: await Globals(context).headers(entries: entries, token: token),
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
