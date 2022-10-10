import 'dart:convert';

/// It takes a RegistrationModel object and returns a JSON string
///
/// Args:
///   data (RegistrationModel): The data to be converted to JSON.
String registrationModelToJson(RegistrationModel data) =>
    json.encode(data.toJson());

class RegistrationModel {
  RegistrationModel({
    required this.name,
    required this.email,
    required this.password,
    required this.passwordConfirmation,
  });

  String name;
  String email;
  String password;
  String passwordConfirmation;

  Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
        "password": password,
        "password_confirmation": passwordConfirmation,
      };
}
