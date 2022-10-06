import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_application_1/models/product_list_model.dart';
import 'package:http/http.dart' as http;

import '../constants/endpoints.dart';
import '../constants/globals.dart';

class ProductListService {
  ProductListService(this.context);
  BuildContext context;

  static MapEntry<String, String> _json =
          MapEntry("Accept", "application/json"),
      contentType = MapEntry("Content-Type", "application/json"),
      accessControl = MapEntry("Access-Control-Allow-Origin", "*");

  Future<Map<String, String>> _header({required String token}) async {
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
      //TODO: Error Handling
      print("FETCHING PRODUCTS FAILED");
      print(response.body);
    }
  }
}
