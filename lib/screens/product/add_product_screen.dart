import 'package:flutter/material.dart';
import 'package:flutter_application_1/repositories/product_repository.dart';
import 'package:flutter_application_1/widgets/button.dart';
import 'package:flutter_application_1/widgets/dropdown.dart';
import 'package:flutter_application_1/widgets/textformfield.dart';
import 'package:validators/validators.dart';

import '../../constants/labels.dart';
import '../../services/navigation_service.dart';
import '../../services/shared_preferences_service.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController imageLinkController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final List<bool> dropdownItems = [true, false];
  bool isPublished = false;
  Map<String, dynamic>? data = {};
  Map<String, dynamic>? errors = {};
  bool success = false;
  String? errorMessage;
  String? token;
  bool isProcessing = false;
  String? productNameError;
  String? imageLinkError;
  String? imageLinkFormatError;
  String? imageLink;
  String? priceError;
  String? priceFormatError;
  String? price;
  bool urlIsValid = false;

  /// `initData()` is an async function that gets the token from the shared preferences and assigns it
  /// to the `token` variable
  void initData() async {
    token = await SharedPref(context).getString("token");
  }

  /// It takes the data from the form and sends it to the server
  void getAddData() async {
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
      if (imageLinkController.text.isNotEmpty) {
        if (isImageLinkValid(imageLinkController.text)) {
          imageLinkFormatError = null;
          imageLink = imageLinkController.text;
        } else {
          imageLink = "";
          imageLinkFormatError = null;
          imageLinkFormatError = ErrorMessage.invalidImageLink;
        }
      } else {
        imageLinkFormatError = null;
        imageLink = imageLinkController.text;
      }
    });

    data = await ProductRepository(context).addProduct(
      token: token!,
      name: productNameController.text,
      imageLink: imageLink!,
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
        if (errors!.containsKey("image_link") && imageLinkFormatError != null) {
          errors?["image_link"].insert(0, imageLinkFormatError);
        }
      }
      if (data!.containsKey("id")) {
        success = true;
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

  /// It gets the data from the form, then waits 2 seconds, then checks if the data was successfully
  /// added to the database, then shows a snackbar, then navigates back to the product list page, then
  /// waits 3 seconds, then checks if the data was successfully added to the database, then sets the
  /// isProcessing variable to false
  void addProduct() {
    getAddData();

    Future.delayed(const Duration(seconds: 2)).then((value) {
      if (success) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text(Label.addSuccessful)));
        Navigation(context).backToProductList();
      } else {
        errorMessage != null
            ? ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(errorMessage!)))
            : null;
      }
    });

    Future.delayed(const Duration(seconds: 3)).then((value) {
      if (!success) {
        setState(() {
          isProcessing = false;
        });
      }
    });
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

  /// It takes a string and tries to convert it to a double. If it can't, it returns false. If it can,
  /// it returns true
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

  @override
  void initState() {
    initData();
    super.initState();
  }

  @override
  void dispose() {
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
            title: const Text(Label.addProduct),
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
                    SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          ProductField(
                            label: Label.productName,
                            controller: productNameController,
                            errorText: productNameError,
                          ),
                          const SizedBox(height: 20.0),
                          ProductField(
                            label: Label.imageLink,
                            controller: imageLinkController,
                            errorText: imageLinkError,
                          ),
                          const SizedBox(height: 20.0),
                          ProductField(
                            label: Label.description,
                            controller: descriptionController,
                          ),
                          const SizedBox(height: 20.0),
                          ProductField(
                            label: Label.price,
                            controller: priceController,
                            errorText: priceError,
                            keyboardType: TextInputType.number,
                          ),
                          const SizedBox(height: 20.0),
                          ProductDropdown(
                            value: false,
                            label: Label.published,
                            items: dropdownItems
                                .map((item) => DropdownMenuItem<bool>(
                                      value: item,
                                      child: Text(item.toString()),
                                    ))
                                .toList(),
                            onChanged: (item) => setState(() {
                              isPublished = item!;
                            }),
                          ),
                        ],
                      ),
                    ),
                    MainButton(
                      buttonLabel: Label.add,
                      isProcessing: isProcessing,
                      process: addProduct,
                    ),
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
