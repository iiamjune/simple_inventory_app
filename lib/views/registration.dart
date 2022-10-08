import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/registration_service.dart';
import 'package:flutter_application_1/widgets/appbar.dart';
import 'package:flutter_application_1/widgets/button.dart';
import 'package:flutter_application_1/widgets/footer.dart';
import 'package:flutter_application_1/widgets/popup.dart';
import 'package:flutter_application_1/widgets/textformfield.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/labels.dart';
import '../services/navigation.dart';

class Registration extends StatefulWidget {
  const Registration({super.key});

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController passwordController = TextEditingController();
  String? name;
  String? email;
  String? password;
  String? passwordConfirmation;
  Map<String, dynamic>? data = {};
  String? errorMessage;
  String? token;
  bool success = false;

  void getRegistrationData() async {
    data = (await RegistrationService(context)
        .register(name!, email!, password!, passwordConfirmation!));
    setState(() {
      if (data!.containsKey("errors")) {
        success = false;
        if (data?["errors"].containsKey("email")) {
          errorMessage = data?["errors"]["email"][0];
        }
      }
      if (data!.containsKey("token")) {
        success = true;
        token = data?["token"];
      }
    });
  }

  @override
  void dispose() {
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: PageAppBar(Label.registration),
        body: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.disabled,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 50.0, vertical: 30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Icon(
                  Icons.app_registration,
                  color: Colors.indigo[600],
                  size: 80.0,
                ),
                SingleChildScrollView(
                  reverse: true,
                  child: Column(
                    children: [
                      StandardTextField(
                        label: Label.name,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return ErrorMessage.enterYourName;
                          }
                          return null;
                        },
                        onSaved: (value) {
                          name = value;
                        },
                      ),
                      const SizedBox(height: 20.0),
                      StandardTextField(
                        label: Label.email,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return ErrorMessage.enterAnEmailAddress;
                          }
                          return EmailValidator.validate(value)
                              ? null
                              : ErrorMessage.enterAValidEmailAddress;
                        },
                        onSaved: (value) {
                          email = value;
                        },
                      ),
                      const SizedBox(height: 20.0),
                      PasswordTextField(
                        label: Label.password,
                        controller: passwordController,
                        onSaved: (value) {
                          password = value;
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return ErrorMessage.enterAPassword;
                          }
                          if (value.length < 8) {
                            return ErrorMessage.useEightCharactersOrMore;
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20.0),
                      PasswordTextField(
                        label: Label.passwordConfirmation,
                        onSaved: (value) {
                          passwordConfirmation = value;
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return ErrorMessage.confirmYourPassword;
                          }
                          if (value != passwordController.text) {
                            return ErrorMessage.thosePasswordsDidntMatch;
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                MainButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      getRegistrationData();
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();

                      Future.delayed(Duration(seconds: 2)).then((value) {
                        if (success) {
                          prefs.setString("token", token!);
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Token: ${token!}")));
                          Popup(context).showSuccess(
                            message: "Registration successful",
                            onTap: () => Navigation(context).backToHome(),
                          );
                        } else {
                          errorMessage != null
                              ? ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(errorMessage!)))
                              : null;
                        }
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content:
                              Text("Please make sure your input is valid")));
                    }
                  },
                  buttonLabel: Label.createAccount,
                ),
                Divider(
                  color: Colors.grey,
                  thickness: 1.0,
                ),
                PageFooter(
                  label: Label.alreadyHaveAnAccount,
                  navigation: () {
                    Navigation(context).goToLogin();
                  },
                  buttonLabel: Label.login,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
