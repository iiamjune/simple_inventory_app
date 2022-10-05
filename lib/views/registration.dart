import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/registration_service.dart';

import '../constants/labels.dart';

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
        appBar: AppBar(
          backgroundColor: Colors.indigo[600],
          title: const Text(Label.registration),
          centerTitle: true,
        ),
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
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      print(
                          "$name | $email | $password | $passwordConfirmation");
                      RegistrationService(context).register(
                          name!, email!, password!, passwordConfirmation!);
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
