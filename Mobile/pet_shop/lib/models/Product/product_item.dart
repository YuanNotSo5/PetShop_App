import 'package:flutter/material.dart';

class product_item {
  final String? image, title, description;
  final int? price, size, id;
  final Color? color;

  product_item(
      {this.id,
      this.image,
      this.title,
      this.price,
      this.description,
      this.size,
      this.color});
}

List<product_item> products = [
  product_item(
      id: 1,
      title: "OC",
      price: 234,
      size: 12,
      description: "a",
      image: "a",
      color: Colors.white)
];
