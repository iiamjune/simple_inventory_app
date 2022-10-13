import 'package:flutter/cupertino.dart';

String baseServerUrl = "https://api-001.emberspec.com";
String subString = "/api";
MapEntry<String, String> accept = const MapEntry("Accept", "application/json"),
    contentType = const MapEntry("Content-Type", "application/json"),
    accessControl = const MapEntry("Access-Control-Allow-Origin", "*");

class Globals {
  Globals(this.context);
  BuildContext context;

  /// It takes a list of key-value pairs and returns a map of key-value pairs
  ///
  /// Args:
  ///   entries (Iterable<MapEntry<String, String>>): This is the list of headers you want to send with
  /// the request.
  ///   token (String): The token that you want to add to the header.
  ///   withToken (bool): This is a boolean value that determines whether or not to include the token in
  /// the headers. Defaults to true
  ///
  /// Returns:
  ///   A Future<Map<String, String>>
  Future<Map<String, String>> headers(
      {required Iterable<MapEntry<String, String>> entries,
      String token = "",
      bool withToken = true}) async {
    Map<String, String> content;
    if (withToken) {
      MapEntry<String, String> auth =
          MapEntry("Authorization", "Bearer $token");
      content = Map.fromEntries(entries);
      content.addAll(Map.fromEntries([auth]));
      print(content);
    } else {
      content = Map.fromEntries(entries);
    }

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
