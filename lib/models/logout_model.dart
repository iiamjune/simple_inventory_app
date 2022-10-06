import 'dart:convert';

LogoutModel logoutModelFromJson(String str) =>
    LogoutModel.fromJson(json.decode(str));

class LogoutModel {
  LogoutModel({
    required this.message,
  });

  String message;

  factory LogoutModel.fromJson(Map<String, dynamic> json) => LogoutModel(
        message: json["message"],
      );
}
