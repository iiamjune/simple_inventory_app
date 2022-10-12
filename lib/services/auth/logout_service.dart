import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../../constants/endpoints.dart';
import '../../constants/globals.dart';

class LogoutService {
  LogoutService(this.context);
  BuildContext context;

  /// Creating a map with three entries.
  static const MapEntry<String, String> _json =
          MapEntry("Accept", "application/json"),
      contentType = MapEntry("Content-Type", "application/json"),
      accessControl = MapEntry("Access-Control-Allow-Origin", "*");

  /// It takes a token as a parameter and returns a map of headers
  ///
  /// Args:
  ///   token (String): The token that is returned from the login request.
  ///
  /// Returns:
  ///   A Future<Map<String, String>>
  Future<Map<String, String>> _header({required String token}) async {
    MapEntry<String, String> auth = MapEntry("Authorization", "Bearer $token");
    Map<String, String> content =
        Map.fromEntries([_json, contentType, accessControl, auth]);
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

  /// It takes a token as a parameter, sends a POST request to the server, and returns a Map<String,
  /// dynamic>?
  ///
  /// Args:
  ///   token (String): The token that is returned from the login function.
  ///
  /// Returns:
  ///   A Future<Map<String, dynamic>?>
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
      print(json.decode(response.body));
      return json.decode(response.body);
    }
  }
}
