import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/product_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/labels.dart';
import '../models/product_model.dart';

class Product extends StatefulWidget {
  const Product({super.key, this.appBarTitle});
  final String? appBarTitle;

  @override
  State<Product> createState() => _ProductState();
}

class _ProductState extends State<Product> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isEditing = false;
  final TextEditingController idController = TextEditingController();
  final TextEditingController userIDController = TextEditingController();
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController imageLinkController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  ProductModel? productData;
  String? token;
  String? productID;

  void initData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString("token");
    productID = prefs.getString("productID");
    productData = (await ProductService(context)
        .getProducts(token: token!, productID: productID!));
    idController.text = productData?.id.toString() ?? "";
    userIDController.text = productData?.userId.toString() ?? "";
    productNameController.text = productData?.name ?? "";
    imageLinkController.text = productData?.imageLink ?? "";
    descriptionController.text = productData?.description ?? "";
    priceController.text = productData?.price ?? "";
    setState(() {});
  }

  @override
  void initState() {
    initData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.indigo[600],
          title: Text(widget.appBarTitle ?? "Product"),
          centerTitle: true,
        ),
        body: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.disabled,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 50.0, vertical: 30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      CircleAvatar(
                        radius: 50.0,
                        backgroundColor: Colors.indigo[600],
                        backgroundImage: productData?.imageLink != null
                            ? NetworkImage(productData!.imageLink)
                            : null,
                        // backgroundImage: null,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(Label.createdAt),
                          Text(productData?.createdAt.toIso8601String() ?? ""),
                          Text(Label.updatedAt),
                          Text(productData?.updatedAt.toIso8601String() ?? ""),
                        ],
                      ),
                    ],
                  ),
                  SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Expanded(
                                flex: 1,
                                child: TextFormField(
                                  enabled: false,
                                  controller: idController,
                                  onSaved: (value) {},
                                  decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: Label.id),
                                )),
                            SizedBox(width: 10.0),
                            Expanded(
                                flex: 1,
                                child: TextFormField(
                                  enabled: false,
                                  controller: userIDController,
                                  onSaved: (value) {},
                                  decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: Label.userID),
                                )),
                          ],
                        ),
                        SizedBox(height: 20.0),
                        TextFormField(
                          enabled: isEditing,
                          controller: productNameController,
                          onSaved: (value) {},
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: Label.productName),
                        ),
                        SizedBox(height: 20.0),
                        TextFormField(
                          enabled: isEditing,
                          controller: imageLinkController,
                          onSaved: (value) {},
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: Label.imageLink),
                        ),
                        SizedBox(height: 20.0),
                        TextFormField(
                          enabled: isEditing,
                          controller: descriptionController,
                          onSaved: (value) {},
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: Label.description),
                        ),
                        SizedBox(height: 20.0),
                        TextFormField(
                          enabled: isEditing,
                          controller: priceController,
                          keyboardType: TextInputType.number,
                          onSaved: (value) {},
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: Label.price),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.indigo[600]),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0))),
                    ),
                    onPressed: () {},
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text(
                        isEditing ? Label.save : Label.edit,
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
