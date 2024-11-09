import 'dart:convert';

import 'package:pet_shop/models/Account/user_model.dart';
import 'package:pet_shop/models/Order/product_order.dart';
import 'package:pet_shop/models/Product/product.dart';

List<Order> orderListfromJson(String val) {
  final data = jsonDecode(val);
  final docs = data['data'] as List<dynamic>;
  return List<Order>.from(docs.map((order) => Order.fromJson(order)));
}

class Order {
  final String id;
  final String user;
  final List<ProductOrder> products;
  final int orderTotal;
  final String address;
  final String billing;
  final String status;
  final String description;
  final DateTime date;
  final bool isConfirm;

  // Thêm getter để tính tổng số lượng
  int get totalItems {
    return products.fold(0, (total, current) => total + current.quantity);
  }

  factory Order.fromJson(Map<String, dynamic> data) {
    return Order(
      id: data['_id'],
      // user: UserModel.fromJson(data['user']),
      user: data['user'],
      products: List<ProductOrder>.from(
          data['products'].map((item) => ProductOrder.fromJson(item))),
      orderTotal: data['orderTotal'].toInt(),
      address: data['address'],
      billing: data['billing'],
      status: data['status'],
      description: data['description'],
      isConfirm: data['isConfirm'],
      date: DateTime.parse(data['date']),
    );
  }

  Order({
    required this.id,
    required this.user,
    required this.products,
    required this.orderTotal,
    required this.address,
    required this.billing,
    required this.status,
    required this.description,
    required this.date,
    required this.isConfirm,
  });
  @override
  String toString() {
    return 'Order{id: $id, user: ${user.toString()}, products: ${products.map((p) => p.toString()).join(', ')}, orderTotal: $orderTotal, address: $address, billing: $billing, status: $status, description: $description, date: $date}';
  }
}

//todo [GET UNREVIEWD ORDER]
class ProductUnreviewed {
  final String orderId;
  final Product product;

  ProductUnreviewed({
    required this.orderId,
    required this.product,
  });
  @override
  String toString() {
    return 'ProductUnreviewed{orderId: $orderId, product: ${product.toString()}}';
  }

  factory ProductUnreviewed.fromJson(Map<String, dynamic> json) {
    return ProductUnreviewed(
      orderId: json['orderId'],
      product: Product.fromJson(json['product']),
    );
  }
}
