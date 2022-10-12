// To parse this JSON data, do
//
//     final productModel = productModelFromJson(jsonString);

import 'dart:convert';

ProductDataModel productDataModelFromJson(String str) =>
    ProductDataModel.fromJson(json.decode(str));

String productDataModelToJson(ProductDataModel data) =>
    json.encode(data.toJson());

class ProductDataModel {
  ProductDataModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.imageLink,
    this.description,
    required this.price,
    required this.isPublished,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  int userId;
  String name;
  String imageLink;
  dynamic description;
  String price;
  int isPublished;
  DateTime createdAt;
  DateTime updatedAt;

  factory ProductDataModel.fromJson(Map<String, dynamic> json) =>
      ProductDataModel(
        id: json["id"],
        userId: json["user_id"],
        name: json["name"],
        imageLink: json["image_link"],
        description: json["description"],
        price: json["price"],
        isPublished: json["is_published"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "name": name,
        "image_link": imageLink,
        "description": description,
        "price": price,
        "is_published": isPublished,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
