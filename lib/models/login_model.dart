import 'dart:convert';

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

class LoginResponse {
  LoginResponse({
    required this.user,
    required this.token,
  });

  Map<String, dynamic> user;
  String token;
}
