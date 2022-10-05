import 'package:flutter/material.dart';

import '../constants/labels.dart';
import '../services/navigation.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  initData() {
    Future.delayed(Duration(seconds: 3))
        .then((value) => Navigation(context).goToRegistration());
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
