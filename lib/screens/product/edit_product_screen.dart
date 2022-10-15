import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/product/product_service.dart';
import 'package:flutter_application_1/services/shared_preferences_service.dart';
import 'package:flutter_application_1/widgets/button.dart';
import 'package:flutter_application_1/widgets/dropdown.dart';
import 'package:flutter_application_1/widgets/textformfield.dart';
import 'package:validators/validators.dart';

import '../../constants/labels.dart';
import '../../models/product/product_data_model.dart';
import '../../services/navigation_service.dart';

class EditProductScreen extends StatefulWidget {
  const EditProductScreen({super.key});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isEditing = false;
  final TextEditingController idController = TextEditingController();
  final TextEditingController userIDController = TextEditingController();
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController imageLinkController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  ProductDataModel? productData;
  String? token;
  String? productID;
  List<bool> dropdownItems = [true, false];
  bool isPublished = false;
  Map<String, dynamic>? data = {};
  Map<String, dynamic>? errors = {};
  bool success = false;
  String? errorMessage;
  String appbarTitle = Label.singleProduct;
  bool urlIsValid = false;
  bool isProcessing = false;
  String? productNameError;
  String? imageLinkError;
  String? priceError;
  String? priceFormatError;
  String? price;

  /// It gets the data from the server and then set the data to the textfield
  void initData() async {
    token = await SharedPref(context).getString("token");
    productID = await SharedPref(context).getString("productID");
    productData = (await ProductService(context)
        .getProduct(token: token!, productID: productID!));
    idController.text = productData?.id.toString() ?? "";
    userIDController.text = productData?.userId.toString() ?? "";
    productNameController.text = productData?.name ?? "";
    imageLinkController.text = productData?.imageLink ?? "";
    descriptionController.text = productData?.description ?? "";
    priceController.text = productData?.price ?? "";
    isPublished = publishStatus(productData?.isPublished ?? 0);
    setState(() {});
  }

  /// It gets the data from the text fields and sends it to the server
  void getEditData() async {
    setState(() {
      isProcessing = true;
    });
    setState(() {
      if (priceController.text.isNotEmpty) {
        if (isPriceValid(priceController.text)) {
          priceFormatError = null;
          price = priceController.text;
        } else {
          price = "";
          priceFormatError = null;
          priceFormatError = ErrorMessage.invalidPrice;
        }
      } else {
        priceFormatError = null;
        price = priceController.text;
      }
    });

    data = await ProductService(context).editProduct(
      token: token!,
      productID: productID!,
      name: productNameController.text,
      imageLink: imageLinkController.text,
      description: descriptionController.text,
      price: price!,
      isPublished: isPublished,
    );
    setState(() {
      if (data!.containsKey("errors")) {
        success = false;
        errorMessage = data?["message"];
        productNameError = null;
        imageLinkError = null;
        priceError = null;
        errors = null;
        errors = data?["errors"];
        if (errors!.containsKey("price") && priceFormatError != null) {
          errors?["price"].insert(0, priceFormatError);
        }
      }
      if (data!.containsKey("id")) {
        success = true;
      }
      if (success) {
        isEditing = false;
        appbarTitle = Label.singleProduct;
        errors = null;
        priceError = null;
      }
    });
    setState(() {
      if (errors != null) {
        storeProductNameError(errors);
        storeImageLinkError(errors);
        storePriceError(errors);
      }
    });
  }

  /// If the value of isPublished is 1, return true, otherwise return false
  ///
  /// Args:
  ///   isPublished (int): 1 or 0
  ///
  /// Returns:
  ///   a boolean value.
  bool publishStatus(int isPublished) {
    if (isPublished == 1) {
      return true;
    }
    return false;
  }

  /// If the user is not editing, then set the isEditing variable to true and change the appbar title to
  /// "Edit Product". If the user is editing, then get the data from the form and send it to the server.
  /// If the server responds with a success message, then show a snackbar with a success message. If the
  /// server responds with an error message, then show a snackbar with the error message. After 3
  /// seconds, set the isProcessing variable to false
  void process() {
    if (!isEditing) {
      isEditing = true;
      appbarTitle = Label.editProduct;
    } else {
      getEditData();

      Future.delayed(const Duration(seconds: 2)).then((value) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text(Label.editSuccessful)));
        } else {
          errorMessage != null
              ? ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(errorMessage!)))
              : null;
        }
      });

      Future.delayed(const Duration(seconds: 3)).then((value) {
        setState(() {
          isProcessing = false;
        });
      });
    }
    setState(() {});
  }

  /// If the errors map contains a key called "name", then set the productNameError variable to the
  /// first element of the array that is the value of the "name" key
  ///
  /// Args:
  ///   errors (Map<String, dynamic>): The errors returned from the server.
  void storeProductNameError(Map<String, dynamic>? errors) {
    if (errors!.containsKey("name")) {
      productNameError = errors["name"][0];
    }
  }

  /// If the errors map contains a key called image_link, then set the imageLinkError variable to the
  /// first element of the array that is the value of the image_link key
  ///
  /// Args:
  ///   errors (Map<String, dynamic>): The errors returned from the server.
  void storeImageLinkError(Map<String, dynamic>? errors) {
    if (errors!.containsKey("image_link")) {
      imageLinkError = errors["image_link"][0];
    }
  }

  /// If the errors map contains a key called price, then set the priceError variable to the first
  /// element of the array that is the value of the price key
  ///
  /// Args:
  ///   errors (Map<String, dynamic>): The errors returned from the server.
  void storePriceError(Map<String, dynamic>? errors) {
    if (errors!.containsKey("price")) {
      priceError = errors["price"][0];
    }
  }

  /// It takes a string, tries to parse it as a double, and returns true if it can be parsed as a
  /// double, and false if it can't
  ///
  /// Args:
  ///   price (String): The price of the item.
  ///
  /// Returns:
  ///   A boolean value.
  bool isPriceValid(String price) {
    final number = double.tryParse(price);
    if (number == null) {
      return false;
    }
    return true;
  }

  bool isImageLinkValid(String url) {
    return isURL(url, requireTld: false);
  }

  String getImageLink(String url) {
    try {
      NetworkImage(url);
      return url;
    } catch (e) {
      print(e);
      return "https://cdn-icons-png.flaticon.com/512/71/71768.png";
    }
  }

  @override
  void initState() {
    initData();
    super.initState();
  }

  @override
  void dispose() {
    idController.dispose();
    userIDController.dispose();
    productNameController.dispose();
    imageLinkController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigation(context).backToProductList();
        return false;
      },
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            backgroundColor: Colors.indigo[600],
            title: Text(appbarTitle),
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigation(context).backToProductList();
              },
            ),
          ),
          body: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.disabled,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 50.0, vertical: 30.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        CircleAvatar(
                          radius: 40.0,
                          backgroundColor: Colors.indigo[600],
                          backgroundImage: productData?.imageLink != null
                              ? NetworkImage(
                                  getImageLink(productData!.imageLink))
                              : null,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const Text(Label.createdAt),
                            Text(
                                productData?.createdAt.toIso8601String() ?? ""),
                            const Text(Label.updatedAt),
                            Text(
                                productData?.updatedAt.toIso8601String() ?? ""),
                          ],
                        ),
                      ],
                    ),
                    SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              ProductIdField(
                                flex: 1,
                                controller: idController,
                                label: Label.id,
                              ),
                              const SizedBox(width: 10.0),
                              ProductIdField(
                                flex: 1,
                                controller: userIDController,
                                label: Label.userID,
                              ),
                            ],
                          ),
                          const SizedBox(height: 20.0),
                          ProductField(
                            enabled: isEditing,
                            controller: productNameController,
                            label: Label.productName,
                          ),
                          const SizedBox(height: 20.0),
                          ProductField(
                            enabled: isEditing,
                            controller: imageLinkController,
                            label: Label.imageLink,
                          ),
                          const SizedBox(height: 20.0),
                          ProductField(
                            enabled: isEditing,
                            controller: descriptionController,
                            label: Label.description,
                          ),
                          const SizedBox(height: 20.0),
                          ProductField(
                            enabled: isEditing,
                            label: Label.price,
                            controller: priceController,
                            errorText: priceError,
                            keyboardType: TextInputType.number,
                          ),
                          const SizedBox(height: 20.0),
                          ProductDropdown(
                            value: isPublished,
                            label: Label.published,
                            items: dropdownItems
                                .map((item) => DropdownMenuItem<bool>(
                                      value: item,
                                      child: Text(item.toString()),
                                    ))
                                .toList(),
                            onChanged: isEditing
                                ? (item) => setState(() => isPublished = item!)
                                : null,
                          ),
                        ],
                      ),
                    ),
                    MainButton(
                      // onPressed: process,
                      buttonLabel: isEditing ? Label.save : Label.edit,
                      isProcessing: isProcessing,
                      process: process,
                    ),
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
