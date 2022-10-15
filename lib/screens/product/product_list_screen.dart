import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/product/product_list_model.dart';
import 'package:flutter_application_1/repositories/auth_repository.dart';
import 'package:flutter_application_1/repositories/product_respository.dart';
import 'package:flutter_application_1/services/shared_preferences_service.dart';
import 'package:flutter_application_1/widgets/dialog.dart';
import 'package:number_pagination/number_pagination.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/labels.dart';
import '../../services/navigation_service.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
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
  bool isProcessing = false;

  /// It gets the logout data from the server and sets the state of the widget
  void getLogoutData() async {
    logoutData = (await AuthRepository(context).logout(token: token!));
    setState(() {
      if (logoutData!.containsKey("message")) {
        if (logoutData?["message"] == "Logged out") {
          SharedPref(context).remove("token");
          success = true;
          message = logoutData?["message"];
        } else {
          success = false;
          message = logoutData?["message"];
        }
      }
    });
  }

  /// It gets the response from the API and then parses the response into a model
  ///
  /// Args:
  ///   pageNumber (String): The page number to be loaded.
  void getResponseData({int? pageNumber}) async {
    setState(() {
      isProcessing = true;
    });
    token = await SharedPref(context).getString("token");
    responseData = (await ProductRepository(context)
        .getProductList(token: token!, pageNumber: pageNumber))!;
    products = productListModelFromJson(json.encode(responseData["data"]));
    pageTotal = responseData["last_page"];
    currentPage = responseData["current_page"];
    lastPage = responseData["last_page"];
    setState(() {
      isProcessing = false;
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
      deleteData = await ProductRepository(context).deleteProduct(
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
    getResponseData(pageNumber: currentPage);
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
        replacement: Center(
            child: !isProcessing
                ? Text(
                    Label.noProducts,
                    style: TextStyle(
                      color: Colors.indigo[600],
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
                  )
                : const CircularProgressIndicator()),
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
                                    left: 20.0,
                                    top: 15.0,
                                    bottom: 15.0,
                                    right: 20.0),
                                leading: ClipOval(
                                  child: Material(
                                    color: Colors.indigo[600],
                                    child: Image.network(
                                      products[index].imageLink,
                                      fit: BoxFit.cover,
                                      width: 50.0,
                                      height: 50.0,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        print(error);
                                        return Image.network(
                                            "https://cdn-icons-png.flaticon.com/512/71/71768.png");
                                      },
                                    ),
                                  ),
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
                    onPageChanged: (pageNumber) {
                      setState(() {
                        currentPage = pageNumber;
                        getResponseData(pageNumber: pageNumber);
                      });
                    },
                    pageTotal: pageTotal ?? 0,
                    pageInit: 1,
                    threshold: 3,
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
