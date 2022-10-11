import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/product_models/product_list_model.dart';
import 'package:flutter_application_1/services/auth_services/logout_service.dart';
import 'package:flutter_application_1/services/product_services/product_list_service.dart';
import 'package:flutter_application_1/services/product_services/product_service.dart';
import 'package:flutter_application_1/widgets/dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../constants/labels.dart';
import '../../services/navigation.dart';

class ProductList extends StatefulWidget {
  const ProductList({super.key});

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  Map<String, dynamic>? logoutData = {};
  String? message;
  String? token;
  bool success = false;
  List<ProductListModel> products = [];
  bool isDataLoaded = false;
  int? deleteData;
  bool urlIsValid = false;

  /// It gets the logout data from the server and sets the state of the widget
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

  /// It gets the token from the shared preferences and then calls the getProducts function from the
  /// ProductListService class
  void getProductsData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString("token");
    products = (await ProductListService(context).getProducts(token: token!))!;
    setState(() {
      isDataLoaded = true;
    });
  }

  /// It takes in a result and an index, and if the result is true, it will delete the product at the
  /// index
  ///
  /// Args:
  ///   result: The result of the confirmation dialog.
  ///   index: The index of the product in the list
  ///
  /// Returns:
  ///   A Future<bool>
  Future<bool> getDeleteData(result, index) async {
    bool deleteResult = false;
    if (result) {
      deleteData = await ProductService(context).deleteProduct(
          token: token!, productID: products[index].id.toString());

      String message;
      if (deleteData != null && deleteData == 1) {
        deleteResult = true;
        message = Label.deleteSuccessful;
      } else {
        deleteResult = false;
        message = Label.deleteUnsuccessful;
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    }
    return deleteResult;
  }

  /// It handles logout process
  void logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString("token");
    getLogoutData();

    Future.delayed(const Duration(seconds: 2)).then((value) {
      if (success) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(message!)));
        Navigation(context).goToLogin();
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(message!)));
      }
    });
  }

  void checkUrlValidity(String url) async {
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        urlIsValid = true;
      } else {
        urlIsValid = false;
      }
    } on SocketException {
      urlIsValid = false;
    }
  }

  String getUrl(String url) {
    checkUrlValidity(url);
    print(urlIsValid);
    if (urlIsValid) {
      return url;
    }
    return "https://cdn-icons-png.flaticon.com/512/71/71768.png";
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
        title: const Text(Label.productList),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            onPressed: logout,
            icon: const Icon(Icons.power_settings_new),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigo[600],
        onPressed: () => Navigation(context).goToAddProduct(),
        child: const Icon(Icons.add),
      ),
      body: Visibility(
          visible: isDataLoaded && products.isNotEmpty,
          replacement: const Center(child: CircularProgressIndicator()),
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
                        builder: (_) => const ConfirmDialog(
                              title: Label.warning,
                              content: Label.areYouSureDelete,
                            ));

                    getDeleteData(result, index);
                    return result;
                  },
                  background: Container(
                    color: Colors.red,
                    padding: const EdgeInsets.only(left: 16.0),
                    child: const Align(
                      alignment: Alignment.centerLeft,
                      child: Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.indigo[600],
                          backgroundImage:
                              NetworkImage(products[index].imageLink),
                        ),
                        title: Text(products[index].name),
                        subtitle:
                            Text(products[index].updatedAt.toIso8601String()),
                        trailing: Text(
                          products[index].price,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        onTap: () async {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          prefs.setString(
                              "productID", products[index].id.toString());
                          Navigation(context).goToProduct();
                        },
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
