import 'package:flutter/material.dart';
import 'package:pet_shop/screen/Home/components/category/category_card.dart';

import '../../../../models/Product/category.dart';

class CategoryShowing extends StatelessWidget {
  final List<Category> categories;
  const CategoryShowing({Key? key, required this.categories}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      padding: EdgeInsets.only(right: 10, bottom: 10),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: categories.length,
        itemBuilder: (context, index) =>
            CategoryCard(category: categories[index]),
      ),
    );
  }
}
