import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pet_shop/components/Header/header_appbar.dart';
import 'package:pet_shop/config/constant.dart';
import 'package:pet_shop/controllers/Product/product_controller.dart';
import 'package:pet_shop/screen/Product/components/product_loading_grid.dart';
import 'package:pet_shop/screen/Product/components/product_showing_grid.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({Key? key}) : super(key: key);

  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  ProductController productController = Get.find<ProductController>();

  @override
  void initState() {
    super.initState();
    productController.getAllFavoriteProduct();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomAppColor.lightBackgroundColor_Home,
      appBar: Header_Appbar(
        context: context,
        isShowingCart: true,
        isBack: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (productController.favoriteList.isNotEmpty) {
                return ProductShowingGrid(
                    productList: productController.favoriteList);
              } else {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment:
                        CrossAxisAlignment.center, // Center horizontally
                    children: [
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.2),
                      Image.asset(
                        'assets/images/_project/Logo/logo.png',
                        width: 150,
                        height: 150,
                      ),
                      Text(
                        'Chưa có sản phẩm yêu thích',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.2),
                    ],
                  ),
                );
              }
            }),
          ),
        ],
      ),
    );
  }
}
