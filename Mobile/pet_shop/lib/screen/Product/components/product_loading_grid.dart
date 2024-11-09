import 'package:flutter/material.dart';
import 'package:pet_shop/screen/Product/components/product_card_loading.dart';

class ProductLoadingGrid extends StatelessWidget {
  const ProductLoadingGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        childAspectRatio: 2 / 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        maxCrossAxisExtent: 200,
      ),
      physics: BouncingScrollPhysics(),
      
      padding: EdgeInsets.all(10),
      itemCount: 6,
      itemBuilder: (context, index) => const ProductCardLoading(),
    );
  }
}
