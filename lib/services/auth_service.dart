import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  AuthService([this.context]);
  BuildContext? context;

  Future<bool> isLoggedIn() async {
    SharedPreferences sharedPref = await SharedPreferences.getInstance();
    String? token = sharedPref.getString("token");
    if (token != null) {
      if (token.isNotEmpty) {
        return true;
      }
    }
    return false;
  }
}
