import 'dart:convert';
import 'package:pet_shop/models/Order/product_order.dart';

class Cart {
  final String id;
  final String user;
  final List<ProductOrder> products;

  Cart({
    required this.id,
    required this.user,
    required this.products,
  });

  @override
  String toString() {
    return 'Cart{id: $id, user: $user, products: $products}';
  }
}

Cart CartFromJson<T>(String val) {
  final data = jsonDecode(val);

  final id = data['data']['_id'] as String;
  final user = data['data']['user'] as String;
  final products = List<ProductOrder>.from(
      data['data']['products'].map((item) => ProductOrder.fromJson(item)));

  return Cart(
    id: id,
    user: user,
    products: products,
  );
}

List<ProductOrder> ItemsCartFromJson<T>(String val) {
  final data = jsonDecode(val);
  final products = List<ProductOrder>.from(
      data['data']['products'].map((item) => ProductOrder.fromJson(item)));

  return products;
}
