// To parse this JSON data, do
//
//     final productModel = productModelFromJson(jsonString);

import 'dart:convert';

ProductModel productModelFromJson(String str) =>
    ProductModel.fromJson(json.decode(str));

String productModelToJson(ProductModel data) => json.encode(data.toJson());

class ProductModel {
  ProductModel({
    required this.name,
    required this.imageLink,
    required this.description,
    required this.price,
    required this.isPublished,
  });

  String name;
  String imageLink;
  dynamic description;
  String price;
  bool isPublished;

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        name: json["name"],
        imageLink: json["image_link"],
        description: json["description"],
        price: json["price"],
        isPublished: json["is_published"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "image_link": imageLink,
        "description": description,
        "price": price,
        "is_published": isPublished,
      };
}
