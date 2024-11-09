import 'dart:convert';
import 'package:pet_shop/models/Product/product.dart';

class ProductOrder {
  final String id;
  final Product product;
  int quantity;
  double price;
  bool selected;

  ProductOrder({
    required this.id,
    required this.product,
    required this.quantity,
    required this.price,
    this.selected = false,
  });

  factory ProductOrder.fromJson(Map<String, dynamic> data) => ProductOrder(
        id: data['_id'],
        product: Product.fromJson(data['product']),
        quantity: data['quantity'],
        price: data['price'].toDouble() ?? 0.0,
        selected: false,
      );

  // Define a setter for quantity to allow updating it
  set setQuantity(int newQuantity) {
    quantity = newQuantity;
  }

  @override
  String toString() {
    return 'ProductOrder{id: $id, product: $product, quantity: $quantity, price: $price, selected: $selected}';
  }
}

List<ProductOrder> productOrderListFromJson(String val) {
  final data = json.decode(val);
  return List<ProductOrder>.from(
      data['products'].map((details) => ProductOrder.fromJson(details)));
}
