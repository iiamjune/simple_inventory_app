import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/button.dart';
import 'package:flutter_application_1/widgets/dropdown.dart';
import 'package:flutter_application_1/widgets/textformfield.dart';

import '../../constants/labels.dart';
import '../../services/navigation_service.dart';
import '../../services/product/product_service.dart';
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
  String? priceError;
  String? priceFormatError;
  String? price;

  void initData() async {
    token = await SharedPref(context).getString("token");
  }

  void getAddData() async {
    setState(() {
      isProcessing = true;
    });
    setState(() {
      if (priceController.text.isNotEmpty) {
        if (validatePrice(priceController.text)) {
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

    data = await ProductService(context).addProduct(
      token: token!,
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
    });
    setState(() {
      if (errors != null) {
        storeProductNameError(errors);
        storeImageLinkError(errors);
        storePriceError(errors);
      }
    });
  }

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

  void storeProductNameError(Map<String, dynamic>? errors) {
    if (errors!.containsKey("name")) {
      productNameError = errors["name"][0];
    }
  }

  void storeImageLinkError(Map<String, dynamic>? errors) {
    if (errors!.containsKey("image_link")) {
      imageLinkError = errors["image_link"][0];
    }
  }

  void storePriceError(Map<String, dynamic>? errors) {
    if (errors!.containsKey("price")) {
      priceError = errors["price"][0];
      final number = num.tryParse("0.6");
    }
  }

  bool validatePrice(String price) {
    final number = double.tryParse(price);
    if (number == null) {
      return false;
    }
    return true;
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
