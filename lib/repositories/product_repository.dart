import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_application_1/repositories/product_repository_interface.dart';
import 'package:http/http.dart' as http;

import '../constants/endpoints.dart';
import '../constants/globals.dart';
import '../models/product/product_data_model.dart';
import '../models/product/product_model.dart';
import '../services/api_service.dart';

class ProductRepository implements ProductRepositoryInterface {
  ProductRepository(this.context);
  BuildContext context;

  List<MapEntry<String, String>> entries = [accept, contentType, accessControl];

  /// It takes a token and a page number as parameters, and returns a map of dynamic data
  ///
  /// Args:
  ///   token (String): The token that is returned from the login API.
  ///   pageNumber (int): The page number of the products to be fetched.
  ///
  /// Returns:
  ///   A Future<Map<String, dynamic>?>
  Future<Map<String, dynamic>?> getProductList(
      {required String token, int? pageNumber}) async {
    try {
      var client = http.Client();
      var response = await client.get(
        ApiService(context).url(endpoint: EndPoint.products, page: pageNumber),
        headers:
            await ApiService(context).headers(entries: entries, token: token),
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

  /// It takes a token and a productID, and returns a ProductDataModel
  ///
  /// Args:
  ///   token (String): The token that is returned from the login API
  ///   productID (String): The ID of the product you want to get.
  ///
  /// Returns:
  ///   A Future<ProductDataModel?>
  Future<ProductDataModel?> getProduct(
      {required String token, required String productID}) async {
    try {
      var client = http.Client();
      var response = await client.get(
        ApiService(context).url(
            endpoint: EndPoint.products, query: productID, withQuery: true),
        headers:
            await ApiService(context).headers(entries: entries, token: token),
      );

      if (response.statusCode == 200) {
        print(response.body);
        return productDataModelFromJson(response.body);
      } else {
        print(response.body);
      }
      return null;
    } catch (e) {
      print(e);
    }
  }

  /// It takes in a token, productID, name, imageLink, description, price, and isPublished, and returns
  /// a Map<String, dynamic>?
  ///
  /// Args:
  ///   token (String): The token of the user
  ///   productID (String): The ID of the product you want to edit.
  ///   name (String): The name of the product
  ///   imageLink (String): The image link of the product
  ///   description (String): The description of the product
  ///   price (String): price,
  ///   isPublished (bool): is a boolean value
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
    try {
      var client = http.Client();
      var response = await client.put(
          ApiService(context).url(
              endpoint: EndPoint.products, query: productID, withQuery: true),
          headers:
              await ApiService(context).headers(entries: entries, token: token),
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
    } catch (e) {
      print(e);
    }
  }

  /// It takes in a token, name, imageLink, description, price, and isPublished, and returns a
  /// Map<String, dynamic>?
  ///
  /// Args:
  ///   token (String): The token of the user who is adding the product
  ///   name (String): The name of the product
  ///   imageLink (String): The image link of the product
  ///   description (String): The description of the product
  ///   price (String): price,
  ///   isPublished (bool): is a boolean value
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
    try {
      var client = http.Client();
      var response = await client.post(
          ApiService(context).url(endpoint: EndPoint.products),
          headers:
              await ApiService(context).headers(entries: entries, token: token),
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
    } catch (e) {
      print(e);
    }
  }

  /// It takes a token and a productID as required parameters, and then it makes a DELETE request to the
  /// server, and returns the response body as an integer.
  /// </code>
  ///
  /// Args:
  ///   token (String): The token of the user
  ///   productID (String): The ID of the product to be deleted
  ///
  /// Returns:
  ///   The result of the delete request.
  Future<int> deleteProduct({
    required String token,
    required String productID,
  }) async {
    int result = 0;
    try {
      var client = http.Client();
      var response = await client.delete(
        ApiService(context).url(
            endpoint: EndPoint.products, query: productID, withQuery: true),
        headers:
            await ApiService(context).headers(entries: entries, token: token),
      );

      if (response.statusCode == 200) {
        result = json.decode(response.body);
        print(result);
        return result;
      } else {
        result = json.decode(response.body);
        print(result);
        return result;
      }
    } catch (e) {
      print(e);
    }
    return result;
  }
}
