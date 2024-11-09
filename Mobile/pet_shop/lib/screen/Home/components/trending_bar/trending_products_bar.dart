import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pet_shop/controllers/Home/home_controller.dart';
import 'package:pet_shop/components/Header/header_appbar.dart';
import 'package:pet_shop/config/constant.dart';
import 'package:pet_shop/models/Product/product.dart';
import 'package:pet_shop/screen/Home/components/category/category_showing.dart';
import 'package:pet_shop/screen/Product/components/product_loading.dart';
import 'package:pet_shop/screen/Product/components/product_showing.dart';

class TrendingProductsBar extends StatefulWidget {
  const TrendingProductsBar({Key? key}) : super(key: key);

  @override
  _TrendingProductsBarState createState() => _TrendingProductsBarState();
}

class _TrendingProductsBarState extends State<TrendingProductsBar>
    with SingleTickerProviderStateMixin {
  final HomeController homeController = Get.find<HomeController>();

  late TabController _tabController;
  final List<Tab> _tabs = [
    Tab(text: "Phổ biến"),
    Tab(text: "Sản phẩm đánh giá cao"),
    Tab(text: "Sản phẩm mới nhất"),
  ];

  late List<Widget> _tabBody;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);

    _tabBody = [
      TabBodyTrendingTab(listProduct: homeController.popularProductList),
      TabBodyTrendingTab(listProduct: homeController.highRecommendProductList),
      TabBodyTrendingTab(listProduct: homeController.newProductList),
    ];
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          TabBar(
            isScrollable: true,
            controller: _tabController,
            tabs: _tabs,
            labelColor: CustomAppColor.primaryColorOrange,
            indicatorColor: CustomAppColor.primaryColorOrange,
            unselectedLabelColor: CustomAppColor.lightAccentColor,
            indicatorSize: TabBarIndicatorSize.tab,
          ),
          Container(
            height: 300,
            child: TabBarView(
              controller: _tabController,
              children: _tabBody,
            ),
          ),
        ],
      ),
    );
  }
}

class TabBodyTrendingTab extends StatelessWidget {
  final List<Product> listProduct;
  const TabBodyTrendingTab({Key? key, required this.listProduct})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (listProduct.isNotEmpty) {
        return ProductShowing(productList: listProduct);
      }
      // Loading
      else {
        return ProductLoading();
      }
    });
  }
}
