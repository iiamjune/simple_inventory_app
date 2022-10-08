import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/product_list_model.dart';
import 'package:flutter_application_1/services/logout_service.dart';
import 'package:flutter_application_1/services/product_list_service.dart';
import 'package:flutter_application_1/services/product_service.dart';
import 'package:flutter_application_1/widgets/dialog.dart';
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
  Map<String, dynamic>? logoutData = {};
  String? message;
  String? token;
  bool success = false;
  List<ProductListModel> products = [];
  bool isDataLoaded = false;
  int? deleteData;

  void getLogoutData() async {
    logoutData = (await LogoutService(context).logout(token: token!));
    setState(() {
      if (logoutData!.containsKey("message")) {
        if (logoutData?["message"] == "Logged out") {
          success = true;
          message = logoutData?["message"];
        } else {
          success = false;
          message = logoutData?["message"];
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

  Future<bool> getDeleteData(result, index) async {
    bool deleteResult = false;
    if (result) {
      deleteData = await ProductService(context).deleteProduct(
          token: token!, productID: products[index].id.toString());

      String message;
      if (deleteData != null && deleteData == 1) {
        deleteResult = true;
        message = 'Delete successful';
      } else {
        deleteResult = false;
        message = 'Delete unsuccessful';
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    }
    return deleteResult;
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
        title: Text("Products List"),
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
          child: ListView.builder(
              itemBuilder: (context, index) {
                return Dismissible(
                  key: UniqueKey(),
                  direction: DismissDirection.startToEnd,
                  onDismissed: (direction) {
                    getProductsData();
                  },
                  confirmDismiss: (direction) async {
                    final result = await showDialog(
                        context: context,
                        builder: (_) => ConfirmDialog(
                              title: Label.warning,
                              content: Label.areYouSureDelete,
                            ));

                    getDeleteData(result, index);
                    return result;
                  },
                  background: Container(
                    color: Colors.red,
                    padding: EdgeInsets.only(left: 16.0),
                    child: Align(
                      child: Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                      alignment: Alignment.centerLeft,
                    ),
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        leading: CircleAvatar(
                            backgroundColor: Colors.indigo[600],
                            backgroundImage:
                                NetworkImage(products[index].imageLink)),
                        title: Text(products[index].name),
                        subtitle:
                            Text(products[index].updatedAt.toIso8601String()),
                        trailing: Text(
                          products[index].price,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        onTap: (() async {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          prefs.setString(
                              "productID", products[index].id.toString());
                          Navigation(context).goToProduct();
                        }),
                      ),
                      Divider(color: Colors.indigo[600], thickness: 1.0),
                    ],
                  ),
                );
              },
              itemCount: products.length)),
    );
  }
}
