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

  /// Creating a map of headers that will be used in the http requests.
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

  /// `url` takes an `endpoint` and `query` string and returns a `Uri` object
  ///
  /// Args:
  ///   endpoint (String): The endpoint of the API you're trying to hit.
  ///   query (String): This is the query string that you want to pass to the server.
  ///
  /// Returns:
  ///   A Uri object.
  Uri url({String endpoint = "", String query = ""}) {
    String endpointString = '$baseServerUrl$subString$endpoint';
    String queryString = query.isNotEmpty ? '/$query' : '';
    String fullString = '$endpointString$queryString';
    return Uri.parse(fullString);
  }

  /// It takes a token and a productID as parameters, makes a GET request to the server, and returns a
  /// ProductDataModel object if the request is successful
  ///
  /// Args:
  ///   token (String): The token that is generated when the user logs in.
  ///   productID (String): The ID of the product you want to get.
  ///
  /// Returns:
  ///   A Future<ProductDataModel?>
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
      print(response.body);
    }
    return null;
  }

  /// It takes in a token, productID, name, imageLink, description, price, and isPublished, and returns
  /// a Map of dynamic values
  ///
  /// Args:
  ///   token (String): The token of the user who is logged in
  ///   productID (String): The ID of the product you want to edit.
  ///   name (String): name of the product
  ///   imageLink (String): This is the link to the image that you want to upload.
  ///   description (String): "This is a description"
  ///   price (String): price,
  ///   isPublished (bool): true/false
  ///
  /// Returns:
  ///   A Future<Map<String, dynamic>?>
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
      print(json.decode(response.body));
      return json.decode(response.body);
    }
  }

  /// It takes in a token, name, imageLink, description, price, and isPublished and returns a
  /// Map<String, dynamic>?
  ///
  /// Args:
  ///   token (String): The token of the user who is adding the product
  ///   name (String): name of the product
  ///   imageLink (String): This is the link to the image that you want to upload.
  ///   description (String): "This is a description"
  ///   price (String): price,
  ///   isPublished (bool): true,
  ///
  /// Returns:
  ///   A Future<Map<String, dynamic>?>
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
      print(json.decode(response.body));
      return json.decode(response.body);
    }
  }

  /// It takes a token and a productID as required parameters, and then it makes a DELETE request to the
  /// server, and returns the response body as a JSON object
  ///
  /// Args:
  ///   token (String): The token that is returned from the login function.
  ///   productID (String): The ID of the product you want to delete.
  ///
  /// Returns:
  ///   The response from the server.
  Future<int> deleteProduct({
    required String token,
    required String productID,
  }) async {
    var client = http.Client();
    var response = await client.delete(
      url(endpoint: EndPoint.products, query: productID),
      headers: await _header(token: token),
    );

    if (response.statusCode == 200) {
      print(json.decode(response.body));
      return json.decode(response.body);
    } else {
      print(json.decode(response.body));
      return json.decode(response.body);
    }
  }
}
