import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/button.dart';
import 'package:flutter_application_1/widgets/dropdown.dart';
import 'package:flutter_application_1/widgets/textformfield.dart';

import '../../constants/labels.dart';
import '../../services/navigation_service.dart';
import '../../services/product/product_service.dart';
import '../../services/shared_preferences_service.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController imageLinkController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final List<bool> dropdownItems = [true, false];
  bool isPublished = false;
  Map<String, dynamic>? data = {};
  bool success = false;
  String? errorMessage;
  String? token;
  bool isProcessing = false;

  void initData() async {
    token = await SharedPref(context).getString("token");
  }

  void getAddData() async {
    setState(() {
      isProcessing = true;
    });
    data = await ProductService(context).addProduct(
      token: token!,
      name: productNameController.text,
      imageLink: imageLinkController.text,
      description: descriptionController.text,
      price: priceController.text,
      isPublished: isPublished,
    );
    setState(() {
      if (data!.containsKey("errors")) {
        success = false;
        errorMessage = data?["message"];
      } else {
        success = true;
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
                              controller: productNameController,
                              label: Label.productName),
                          const SizedBox(height: 20.0),
                          ProductField(
                              controller: imageLinkController,
                              label: Label.imageLink),
                          const SizedBox(height: 20.0),
                          ProductField(
                              controller: descriptionController,
                              label: Label.description),
                          const SizedBox(height: 20.0),
                          ProductField(
                            controller: priceController,
                            label: Label.price,
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
