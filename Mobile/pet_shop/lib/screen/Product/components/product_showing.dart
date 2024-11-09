import 'package:flutter/material.dart';
import 'package:pet_shop/models/Product/product.dart';
import 'package:pet_shop/models/Product/product_item.dart';
import 'package:pet_shop/screen/Product/components/product_card_vertical.dart';

class ProductShowing extends StatelessWidget {
  final List<Product> productList;
  const ProductShowing({
    Key? key,
    required this.productList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: 340),
      child: Container(
        height: 20,
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          itemCount: productList.length,
          itemBuilder: (context, index) => ProductCardVertical(
            product: productList[index],
          ),
        ),
      ),
    );
  }
}
