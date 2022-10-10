import 'dart:convert';

/// It converts the LoginModel object to a JSON string.
///
/// Args:
///   data (LoginModel): The data to be converted to JSON.
String loginModelToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel {
  LoginModel({
    required this.email,
    required this.password,
  });

  String email;
  String password;

  Map<String, dynamic> toJson() => {
        "email": email,
        "password": password,
      };
}
