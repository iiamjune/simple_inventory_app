import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/labels.dart';
import '../services/auth/auth_service.dart';
import '../services/auth/login_service.dart';
import '../services/navigation_service.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  bool isLoggedIn = false;
  Map<String, dynamic>? data = {};
  Map<String, dynamic>? errors = {};
  String? errorMessage;
  bool success = false;
  String? email;
  String? password;
  String? emailError;
  String? passwordError;
  String? token;

  initData() {
    getCheckResult();
    Future.delayed(const Duration(seconds: 2)).then((value) {
      if (isLoggedIn) {
        getLoginData();
        loginProcess();
      } else {
        Future.delayed(const Duration(seconds: 1))
            .then((value) => Navigation(context).goToLogin());
      }
    });
  }

  getCheckResult() async {
    isLoggedIn = await AuthService(context).isLoggedIn();
  }

  void getLoginData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    email = prefs.getString("email") ?? "";
    password = prefs.getString("password") ?? "";

    if (email!.isEmpty || password!.isEmpty) {
      Future.delayed(const Duration(seconds: 1))
          .then((value) => Navigation(context).goToRegistration());
    } else {
      data = (await LoginService(context).login(email!, password!));
      setState(() {
        if (data!.containsKey("message")) {
          success = false;
          errorMessage = data?["message"];
          emailError = null;
          passwordError = null;
          errors = null;
          if (data!.containsKey("errors")) {
            errors = data?["errors"];
          }
        }
        if (data!.containsKey("token")) {
          success = true;
          token = data?["token"];
        }
      });
      setState(() {
        if (errors != null) {
          storeEmailError(errors);
          storePasswordError(errors);
        }
      });
    }
  }

  void loginProcess() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    Future.delayed(const Duration(seconds: 2)).then((value) {
      if (success) {
        prefs.setString("token", token!);
        prefs.setString("email", email!);
        prefs.setString("password", password!);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Token: ${token!}")));
        Navigation(context).backToProductList();
      } else {
        errorMessage != null
            ? ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(errorMessage!)))
            : null;
      }
    });
  }

  void storeEmailError(Map<String, dynamic>? errors) {
    if (errors!.containsKey("email")) {
      emailError = errors["email"][0];
    }
  }

  void storePasswordError(Map<String, dynamic>? errors) {
    if (errors!.containsKey("password")) {
      passwordError = errors["password"][0];
    }
  }

  @override
  void initState() {
    initData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: Colors.indigo[600]),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 140.0,
              ),
              child: Icon(
                Icons.inventory,
                size: 100.0,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20.0),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 20.0,
              ),
              child: Text(
                Label.appName,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 30.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 20.0),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 120.0,
              ),
              child: LinearProgressIndicator(),
            ),
          ],
        ),
      ),
    );
  }
}
