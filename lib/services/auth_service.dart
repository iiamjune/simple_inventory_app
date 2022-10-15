import 'package:flutter/cupertino.dart';
import 'package:flutter_application_1/services/shared_preferences_service.dart';

class AuthService {
  AuthService(this.context);
  BuildContext context;

  Future<bool> isLoggedIn() async {
    String? token = await SharedPref(context).getString("token");
    if (token != null) {
      if (token.isNotEmpty) {
        return true;
      }
    }
    return false;
  }
}
