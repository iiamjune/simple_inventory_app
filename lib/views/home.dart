import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/product_list_model.dart';
import 'package:flutter_application_1/services/logout_service.dart';
import 'package:flutter_application_1/services/product_list_service.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/labels.dart';
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
  List<ProductListModel> products = [];
  bool isDataLoaded = false;

  void getLogoutData() async {
    data = (await LogoutService(context).logout(token: token!));
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

  void getProductsData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString("token");
    products = (await ProductListService(context).getProducts(token: token!))!;
    setState(() {
      isDataLoaded = true;
    });
  }

  @override
  void initState() {
    getProductsData();
    super.initState();
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
                getLogoutData();

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
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.indigo[600],
        onPressed: () {
          Navigation(context).goToAddProduct();
        },
      ),
      body: Visibility(
          visible: isDataLoaded,
          replacement: Center(child: CircularProgressIndicator()),
          child: ListView.separated(
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(
                      backgroundColor: Colors.indigo[600],
                      backgroundImage: NetworkImage(products[index].imageLink)),
                  title: Text(products[index].name),
                  subtitle: Text(products[index].updatedAt.toIso8601String()),
                  trailing: Text(
                    products[index].price,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onTap: (() async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.setString("productID", products[index].id.toString());
                    Navigation(context).goToProduct();
                  }),
                );
              },
              separatorBuilder: (context, index) =>
                  Divider(color: Colors.indigo[600], thickness: 1.0),
              itemCount: products.length)),
    );
  }
}
