import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_application_1/models/product_list_model.dart';
import 'package:http/http.dart' as http;

import '../constants/endpoints.dart';
import '../constants/globals.dart';

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

  /// It makes a GET request to the server, and if the response is successful, it returns a list of
  /// products
  ///
  /// Args:
  ///   token (String): The token that is returned from the login request.
  ///
  /// Returns:
  ///   A Future<List<ProductListModel>?>
  Future<List<ProductListModel>?> getProducts({required String token}) async {
    var client = http.Client();
    var response = await client.get(
      url(endpoint: EndPoint.products),
      headers: await _header(token: token),
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body)["data"];
      return productListModelFromJson(json.encode(data));
    } else {
      print(response.body);
    }
  }
}
