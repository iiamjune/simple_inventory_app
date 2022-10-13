import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../../constants/endpoints.dart';
import '../../constants/globals.dart';

class ProductListService {
  ProductListService(this.context);
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

  /// `url` takes an optional `endpoint` and `page` and returns a `Uri` object
  ///
  /// Args:
  ///   endpoint (String): The endpoint of the API you're trying to hit.
  ///   page (int): The page number to request.
  ///
  /// Returns:
  ///   A Uri object.
  Uri url({String endpoint = "", int? page}) {
    String endpointString = '$baseServerUrl$subString$endpoint';
    String queryString = page != null ? '?page=$page' : '';
    String fullString = '$endpointString$queryString';
    return Uri.parse(fullString);
  }

  /// It takes a token and a page number as parameters, and returns a map of dynamic data
  ///
  /// Args:
  ///   token (String): The token that is returned from the login request.
  ///   pageNumber (int): The page number of the products you want to fetch.
  ///
  /// Returns:
  ///   A Future<Map<String, dynamic>?>
  Future<Map<String, dynamic>?> getResponse(
      {required String token, int? pageNumber}) async {
    try {
      var client = http.Client();
      var response = await client.get(
        url(endpoint: EndPoint.products, page: pageNumber),
        headers: await _header(token: token),
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        return data;
      } else {
        print(response.body);
      }
    } catch (e) {
      print(e);
    }
  }
}
