import 'package:flutter/cupertino.dart';
import 'package:flutter_application_1/models/product_model.dart';
import 'package:http/http.dart' as http;

import '../constants/endpoints.dart';
import '../constants/globals.dart';

class ProductService {
  ProductService(this.context);
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
    String queryString = query.isNotEmpty ? '/$query' : '';
    String fullString = '$endpointString$queryString';
    return Uri.parse(fullString);
  }

  Future<ProductModel?> getProducts(
      {required String token, required String productID}) async {
    var client = http.Client();
    var response = await client.get(
      url(endpoint: EndPoint.products, query: productID),
      headers: await _header(token: token),
    );

    if (response.statusCode == 200) {
      print(response.body);
      return productModelFromJson(response.body);
    } else {
      //TODO: Error Handling
      print("FETCHING PRODUCT DETAILS FAILED");
      print(response.body);
    }
  }
}
