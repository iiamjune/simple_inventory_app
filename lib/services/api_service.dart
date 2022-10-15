import 'package:flutter/cupertino.dart';

import '../constants/globals.dart';

class ApiService {
  ApiService(this.context);
  BuildContext context;

  /// It takes a list of key-value pairs and returns a map of key-value pairs
  ///
  /// Args:
  ///   entries (Iterable<MapEntry<String, String>>): The headers you want to add to the request.
  ///   token (String): The token that you want to add to the headers.
  ///   withToken (bool): If you want to send the token with the request, set this to true. Defaults to
  /// true
  ///
  /// Returns:
  ///   A Future<Map<String, String>>
  Future<Map<String, String>> headers({
    required Iterable<MapEntry<String, String>> entries,
    String token = "",
    bool withToken = true,
  }) async {
    Map<String, String> content;
    if (withToken) {
      MapEntry<String, String> auth =
          MapEntry("Authorization", "Bearer $token");
      content = Map.fromEntries(entries);
      content.addAll(Map.fromEntries([auth]));
    } else {
      content = Map.fromEntries(entries);
    }

    return content;
  }

  /// It takes in a string, and returns a Uri
  ///
  /// Args:
  ///   endpoint (String): The endpoint of the API.
  ///   page (int): The page number of the results you want to retrieve.
  ///   query (String): This is the query string that you want to pass to the server.
  ///   withQuery (bool): If true, the query parameter will be used as the endpoint. Defaults to false
  ///
  /// Returns:
  ///   A Uri object.
  Uri url({
    String endpoint = "",
    int? page,
    String query = "",
    bool withQuery = false,
  }) {
    String fullString;
    if (withQuery) {
      String endpointString = '$baseServerUrl$subString$endpoint';
      String queryString = query.trim().isNotEmpty ? '/${query.trim()}' : '';
      fullString = '$endpointString$queryString';
      return Uri.parse(fullString);
    } else {
      String endpointString = '$baseServerUrl$subString$endpoint';
      String queryString = page != null ? '?page=$page' : '';
      fullString = '$endpointString$queryString';
      return Uri.parse(fullString);
    }
  }
}
