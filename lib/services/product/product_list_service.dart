import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../../constants/endpoints.dart';
import '../../constants/globals.dart';

class ProductListService {
  ProductListService(this.context);
  BuildContext context;

  List<MapEntry<String, String>> entries = [accept, contentType, accessControl];

  /// It takes a token and a page number as parameters, and returns a map of dynamic data
  ///
  /// Args:
  ///   token (String): The token that is used to authenticate the user.
  ///   pageNumber (int): The page number to fetch.
  ///
  /// Returns:
  ///   A Future<Map<String, dynamic>?>
  Future<Map<String, dynamic>?> getResponse(
      {required String token, int? pageNumber}) async {
    try {
      var client = http.Client();
      var response = await client.get(
        Globals(context).url(endpoint: EndPoint.products, page: pageNumber),
        headers: await Globals(context).headers(entries: entries, token: token),
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
