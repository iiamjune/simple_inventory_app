import 'package:flutter/material.dart';

import '../constants/labels.dart';

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
  Map<String, dynamic> productData = {};

  void initData() async {}

  @override
  void initState() {
    // TODO: implement initState
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
                        backgroundImage: null,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("Created at:"),
                          Text(""),
                          Text("Updated at:"),
                          Text(""),
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
                          onSaved: (value) {},
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: Label.productName),
                        ),
                        SizedBox(height: 20.0),
                        TextFormField(
                          enabled: isEditing,
                          onSaved: (value) {},
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: Label.imageLink),
                        ),
                        SizedBox(height: 20.0),
                        TextFormField(
                          enabled: isEditing,
                          onSaved: (value) {},
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: Label.description),
                        ),
                        SizedBox(height: 20.0),
                        TextFormField(
                          enabled: isEditing,
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
