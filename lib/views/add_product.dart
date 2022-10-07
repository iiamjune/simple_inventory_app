import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/labels.dart';
import '../services/navigation.dart';
import '../services/product_service.dart';

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

  void initData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString("token");
  }

  void getData() async {
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
          title: Text("Add Product"),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigation(context).backToHome();
            },
          ),
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
                  SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          controller: productNameController,
                          onSaved: (value) {},
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: Label.productName),
                        ),
                        SizedBox(height: 20.0),
                        TextFormField(
                          controller: imageLinkController,
                          onSaved: (value) {},
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: Label.imageLink),
                        ),
                        SizedBox(height: 20.0),
                        TextFormField(
                          controller: descriptionController,
                          onSaved: (value) {},
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: Label.description),
                        ),
                        SizedBox(height: 20.0),
                        TextFormField(
                          controller: priceController,
                          keyboardType: TextInputType.number,
                          onSaved: (value) {},
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: Label.price),
                        ),
                        SizedBox(height: 20.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: DropdownButtonFormField<bool>(
                                  value: false,
                                  decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: Label.published),
                                  items: dropdownItems
                                      .map((item) => DropdownMenuItem<bool>(
                                            value: item,
                                            child: Text(item.toString()),
                                          ))
                                      .toList(),
                                  onChanged: (item) => setState(() {
                                        isPublished = item!;
                                      })),
                            )
                          ],
                        )
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
                    onPressed: () async {
                      getData();

                      Future.delayed(Duration(seconds: 2)).then((value) {
                        if (success) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Add successful")));
                        } else {
                          errorMessage != null
                              ? ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(errorMessage!)))
                              : null;
                        }
                      });
                      setState(() {});
                    },
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text(
                        Label.add,
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
