import 'dart:convert';

// RegistrationModel registrationModelFromJson(String str) => RegistrationModel.fromJson(json.decode(str));
Map<String, dynamic> registrationModelFromJson(String str) {
  return Map.from({});
}

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
