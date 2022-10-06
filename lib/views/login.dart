import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/login_service.dart';
import 'package:flutter_application_1/widgets/appbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/labels.dart';
import '../services/navigation.dart';
import '../widgets/popup.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController passwordController = TextEditingController();
  String? email;
  String? password;
  Map<String, dynamic>? data = {};
  String? errorMessage;
  String? token;
  bool success = false;

  void getData() async {
    data = (await LoginService(context).login(email!, password!));
    setState(() {
      if (data!.containsKey("message")) {
        success = false;
        errorMessage = data?["message"];
      }
      if (data!.containsKey("token")) {
        success = true;
        token = data?["token"];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: PageAppBar(Label.login),
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
                  Icons.login,
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
                          return null;
                        },
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: Label.password,
                        ),
                      ),
                      SizedBox(height: 20.0),
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
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();

                      Future.delayed(Duration(seconds: 2)).then((value) {
                        print(success);
                        if (success) {
                          prefs.setString("token", token!);
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Token: ${token!}")));
                          Navigation(context).backToHome();
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
                      Label.login,
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
                      Label.dontHaveAnAccount,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigation(context).goToRegistration();
                      },
                      child: Text(
                        Label.register,
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
    ;
  }
}
