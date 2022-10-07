import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_application_1/models/product_data_model.dart';
import 'package:http/http.dart' as http;

import '../constants/endpoints.dart';
import '../constants/globals.dart';
import '../models/product_model.dart';

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

  Future<ProductDataModel?> getProduct(
      {required String token, required String productID}) async {
    var client = http.Client();
    var response = await client.get(
      url(endpoint: EndPoint.products, query: productID),
      headers: await _header(token: token),
    );

    if (response.statusCode == 200) {
      print(response.body);
      return productDataModelFromJson(response.body);
    } else {
      //TODO: Error Handling
      print("FETCHING PRODUCT DETAILS FAILED");
      print(response.body);
    }
  }

  Future<Map<String, dynamic>?> editProduct(
      {required String token,
      required String productID,
      required String name,
      required String imageLink,
      required String description,
      required String price,
      required bool isPublished}) async {
    var client = http.Client();
    var response =
        await client.put(url(endpoint: EndPoint.products, query: productID),
            headers: await _header(token: token),
            body: productModelToJson(ProductModel(
              name: name,
              imageLink: imageLink,
              description: description,
              price: price,
              isPublished: isPublished,
            )));

    if (response.statusCode == 201) {
      print(json.decode(response.body));
      return json.decode(response.body);
    } else {
      //TODO: Error Validation for existing email, and the password confirmation does not match
      print("FAILED TO EDIT");
      print(json.decode(response.body));
      return json.decode(response.body);
    }
  }

  Future<Map<String, dynamic>?> addProduct(
      {required String token,
      required String name,
      required String imageLink,
      required String description,
      required String price,
      required bool isPublished}) async {
    var client = http.Client();
    var response = await client.post(url(endpoint: EndPoint.products),
        headers: await _header(token: token),
        body: productModelToJson(ProductModel(
          name: name,
          imageLink: imageLink,
          description: description,
          price: price,
          isPublished: isPublished,
        )));

    if (response.statusCode == 201) {
      print(json.decode(response.body));
      return json.decode(response.body);
    } else {
      //TODO: Error Validation for existing email, and the password confirmation does not match
      print("FAILED TO ADD");
      print(json.decode(response.body));
      return json.decode(response.body);
    }
  }
}
