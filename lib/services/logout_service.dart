import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_application_1/models/logout_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../constants/endpoints.dart';
import '../constants/globals.dart';

class LogoutService {
  LogoutService(this.context);
  BuildContext context;

  static MapEntry<String, String> _json =
          MapEntry("Accept", "application/json"),
      contentType = MapEntry("Content-Type", "application/json"),
      accessControl = MapEntry("Access-Control-Allow-Origin", "*");

  Future<Map<String, String>> _header({required String token}) async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    MapEntry<String, String> auth = MapEntry("Authorization", "Bearer $token");
    Map<String, String> content =
        Map.fromEntries([_json, contentType, accessControl, auth]);
    return content;
  }

  Uri url({String endpoint = "", String query = ""}) {
    String endpointString = '$baseServerUrl$subString$endpoint';
    String queryString = query.isNotEmpty ? query : '';
    String fullString = '$endpointString$queryString';
    return Uri.parse(fullString);
  }

  Future<Map<String, dynamic>?> logout({required String token}) async {
    var client = http.Client();
    var response = await client.post(
      url(endpoint: EndPoint.logout),
      headers: await _header(token: token),
    );

    if (response.statusCode == 201) {
      print(json.decode(response.body));
      return json.decode(response.body);
    } else {
      //TODO: Error Handling
      return json.decode(response.body);
    }
  }
}
