import 'package:flutter/material.dart';

import '../constants/labels.dart';
import '../services/auth/auth_service.dart';
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
    setState(() {
      getCheckResult();
    });
    Future.delayed(const Duration(seconds: 2)).then((value) {
      if (isLoggedIn) {
        Navigation(context).backToProductList();
      } else {
        Future.delayed(const Duration(seconds: 1))
            .then((value) => Navigation(context).goToLogin());
      }
    });
  }

  getCheckResult() async {
    isLoggedIn = await AuthService(context).isLoggedIn();
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
