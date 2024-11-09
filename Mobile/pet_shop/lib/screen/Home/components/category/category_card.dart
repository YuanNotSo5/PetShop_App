import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pet_shop/controllers/Product/product_controller.dart';
import 'package:pet_shop/models/Product/category.dart';
import 'package:pet_shop/route/route_generator.dart';
import 'package:pet_shop/screen/Home/components/selection_component/selection_title.dart';
import 'package:shimmer/shimmer.dart';

class CategoryCard extends StatelessWidget {
  final Category category;
  final double height;
  const CategoryCard({Key? key, required this.category, this.height = 0.0})
      : super(key: key);

  //todo [Toast]
  void _showToast(BuildContext context, String id) {
    // Fluttertoast.showToast(
    //   msg: "Banner ID: $id",
    //   toastLength: Toast.LENGTH_SHORT,
    //   gravity: ToastGravity.BOTTOM,
    //   backgroundColor: Colors.black,
    //   textColor: Colors.white,
    // );
  }

  //todo [Handle Find Products In Category]
  void _showListProducts(BuildContext context, String id,
      {String? page, String? limit}) async {
    var isSuccess = ProductController.instance
        .getProductsByCategory(category.id, page: page, limit: limit);
    if (await isSuccess) {
      Navigator.of(context).pushNamed(
        Routes.product_category,
        arguments: SelectionTitleArguments(
          idCate: category.id,
          name: category.name,
          productList: ProductController.instance.productList,
        ),
      );
    }
  }

  //todo [Card]
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showToast(context, category.id);
        _showListProducts(context, category.id, page: "", limit: "");
      },
      child: Padding(
        padding: EdgeInsets.fromLTRB(10, 10, 5, 10),
        child: CachedNetworkImage(
          imageUrl: category.image,
          imageBuilder: (context, imageProvider) => Material(
            elevation: 8,
            shadowColor: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: 270,
              height: height != 0.0 ? height : 140,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.fill,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  category.name,
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),
          ),
          placeholder: (context, url) => Material(
            elevation: 8,
            shadowColor: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(10),
            child: Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.white,
              child: Container(
                width: 270,
                height: 140,
                decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
          errorWidget: (context, url, error) => Container(
            color: Colors.red,
            child: const Icon(Icons.error, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
