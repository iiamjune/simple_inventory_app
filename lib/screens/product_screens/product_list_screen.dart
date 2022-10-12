import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/product_models/product_list_model.dart';
import 'package:flutter_application_1/services/auth_services/logout_service.dart';
import 'package:flutter_application_1/services/product_services/product_list_service.dart';
import 'package:flutter_application_1/services/product_services/product_service.dart';
import 'package:flutter_application_1/widgets/dialog.dart';
import 'package:number_pagination/number_pagination.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  Color arrowColor = Colors.indigo[600]!;
  Map<String, dynamic> responseData = {};
  int? pageTotal;
  int? currentPage;
  int? lastPage;

  /// It gets the logout data from the server and sets the state of the widget
  void getLogoutData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    logoutData = (await LogoutService(context).logout(token: token!));
    setState(() {
      if (logoutData!.containsKey("message")) {
        if (logoutData?["message"] == "Logged out") {
          for (var element in ["token", "email", "password", "currentPage"]) {
            prefs.remove(element);
          }
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

  void getResponseData({String pageNumber = ""}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString("token");
    responseData = (await ProductListService(context)
        .getResponse(token: token!, pageNumber: pageNumber))!;
    products = productListModelFromJson(json.encode(responseData["data"]));
    pageTotal = responseData["last_page"];
    currentPage = responseData["current_page"];
    lastPage = responseData["last_page"];
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

  void initData() {
    getResponseData(pageNumber: currentPage.toString());
  }

  @override
  void initState() {
    initData();
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
        onPressed: () {
          Navigation(context).goToAddProduct();
        },
        child: const Icon(Icons.add),
      ),
      body: Visibility(
        visible: isDataLoaded && products.isNotEmpty,
        replacement: const Center(child: CircularProgressIndicator()),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                  itemBuilder: (context, index) {
                    return Dismissible(
                      key: UniqueKey(),
                      direction: DismissDirection.startToEnd,
                      onDismissed: (direction) {
                        getResponseData();
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
                          Column(
                            children: [
                              ListTile(
                                contentPadding: const EdgeInsets.only(
                                    top: 15.0, bottom: 15.0, right: 20.0),
                                leading: CircleAvatar(
                                  radius: 50.0,
                                  backgroundColor: Colors.indigo[600],
                                  backgroundImage:
                                      NetworkImage(products[index].imageLink),
                                ),
                                title: Text(products[index].name),
                                subtitle: Text(products[index]
                                    .updatedAt
                                    .toIso8601String()),
                                trailing: Text(
                                  products[index].price,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                onTap: () async {
                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  prefs.setString("productID",
                                      products[index].id.toString());
                                  Navigation(context).goToEditProduct();
                                },
                              ),
                              Divider(
                                color: Colors.indigo[600],
                                thickness: 1.0,
                                indent: 40.0,
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                  itemCount: products.length),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0, bottom: 80.0),
              child: Column(
                children: [
                  Text(
                    "Page ${currentPage.toString()} of ${lastPage.toString()}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  NumberPagination(
                    fontSize: 10.0,
                    colorPrimary: Colors.indigo,
                    onPageChanged: (pageNumber) async {
                      final SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      prefs.setInt("currentPage", pageNumber);
                      setState(() {
                        currentPage = pageNumber;
                        getResponseData(pageNumber: pageNumber.toString());
                      });
                    },
                    pageTotal: pageTotal ?? 0,
                    pageInit: 1,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
