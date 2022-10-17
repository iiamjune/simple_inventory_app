import '../models/product/product_data_model.dart';

abstract class ProductRepositoryInterface {
  Future<Map<String, dynamic>?> getProductList(
      {required String token, int? pageNumber});
  Future<ProductDataModel?> getProduct(
      {required String token, required String productID});
  Future<Map<String, dynamic>?> editProduct(
      {required String token,
      required String productID,
      required String name,
      required String imageLink,
      required String description,
      required String price,
      required bool isPublished});
  Future<Map<String, dynamic>?> addProduct(
      {required String token,
      required String name,
      required String imageLink,
      required String description,
      required String price,
      required bool isPublished});
  Future<int> deleteProduct({
    required String token,
    required String productID,
  });
}
