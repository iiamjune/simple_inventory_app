import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/logout_service.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/login_service.dart';
import '../services/navigation.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Map<String, dynamic>? data = {};
  String? message;
  String? token;
  bool success = false;

  void getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    data =
        (await LogoutService(context).logout(token: prefs.getString("token")!));
    setState(() {
      if (data!.containsKey("message")) {
        if (data?["message"] == "Logged out") {
          success = true;
          message = data?["message"];
        } else {
          success = false;
          message = data?["message"];
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo[600],
        title: Text("Home"),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                token = prefs.getString("token");
                getData();

                Future.delayed(Duration(seconds: 2)).then((value) {
                  if (success) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text(message!)));
                    Navigation(context).goToLogin();
                  } else {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text(message!)));
                  }
                });
              },
              icon: Icon(Icons.power_settings_new)),
        ],
      ),
      body: Center(
        child: Text("HOME PAGE"),
      ),
    );
  }
}
