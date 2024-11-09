import 'dart:convert';
import 'package:pet_shop/models/Product/product.dart';

List<FavoriteProduct> favoriteListFromJson(String val) =>
    List<FavoriteProduct>.from(json
        .decode(val)['data']
        .map((banner) => FavoriteProduct.fromJson(banner)));

class FavoriteProduct {
  final String id;
  final String userId;
  final Product product;

  FavoriteProduct({
    required this.id,
    required this.userId,
    required this.product,
  });

  factory FavoriteProduct.fromJson(Map<String, dynamic> data) {
    return FavoriteProduct(
      id: data['_id'],
      // userId: User.fromJson(data['UserId']),
      userId: data['UserID'],
      product: Product.fromJson(data['ProductID']),
    );
  }
  @override
  String toString() {
    return 'FavoriteProduct{id: $id, userId: $userId, products: $product}';
  }
}
