import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/registration_service.dart';
import 'package:flutter_application_1/widgets/appbar.dart';
import 'package:flutter_application_1/widgets/popup.dart';

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

  void getData() async {
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
          autovalidateMode: AutovalidateMode.onUserInteraction,
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
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return ErrorMessage.enterYourName;
                          }
                          return null;
                        },
                        onSaved: (value) {
                          name = value;
                        },
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: Label.name),
                      ),
                      SizedBox(height: 20.0),
                      TextFormField(
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
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: Label.email),
                      ),
                      SizedBox(height: 20.0),
                      TextFormField(
                        obscureText: true,
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
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: Label.password,
                        ),
                      ),
                      SizedBox(height: 20.0),
                      TextFormField(
                        obscureText: true,
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
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: Label.passwordConfirmation,
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.indigo[600]),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0))),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      getData();

                      Future.delayed(Duration(seconds: 2)).then((value) {
                        if (success) {
                          Popup(context).showSuccess(
                            message: "Registration successful",
                            onTap: () => Navigation(context).backToHome(),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Token: ${token!}")));
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
                  child: const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text(
                      Label.createAccount,
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Divider(
                  color: Colors.grey,
                  thickness: 1.0,
                ),
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  alignment: WrapAlignment.center,
                  direction: Axis.vertical,
                  spacing: -10.0,
                  children: <Widget>[
                    Text(
                      Label.alreadyHaveAnAccount,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigation(context).goToLogin();
                      },
                      child: Text(
                        Label.login,
                        style: TextStyle(color: Colors.indigo[600]),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
