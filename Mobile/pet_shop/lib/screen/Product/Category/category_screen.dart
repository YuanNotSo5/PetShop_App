import 'package:flutter/material.dart';
import 'package:pet_shop/components/Header/header_appbar.dart';
import 'package:pet_shop/config/constant.dart';
import 'package:pet_shop/models/Product/category.dart';
import 'package:pet_shop/screen/Home/components/category/category_card.dart';

class CategoryScreen extends StatelessWidget {
  final List<Category> categories;

  const CategoryScreen({Key? key, required this.categories}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomAppColor.lightBackgroundColor_Home,
      appBar: Header_Appbar(context: context),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        padding: const EdgeInsets.only(right: 10, bottom: 10),
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          physics: const BouncingScrollPhysics(),
          itemCount: categories.length,
          itemBuilder: (context, index) => CategoryCard(
            category: categories[index],
            height: 180,
          ),
        ),
      ),
    );
  }
}
