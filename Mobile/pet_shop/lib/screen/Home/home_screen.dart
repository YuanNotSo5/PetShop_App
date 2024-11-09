import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pet_shop/config/constant.dart';
import 'package:pet_shop/controllers/Home/home_controller.dart';
import 'package:pet_shop/controllers/Product/product_controller.dart';
import 'package:pet_shop/screen/Home/components/banner/banner_showing.dart';
import 'package:pet_shop/screen/Home/components/carousel_slider/carousel_loading.dart';
import 'package:pet_shop/screen/Home/components/carousel_slider/carousel_slider_view.dart';
import 'package:pet_shop/screen/Home/components/category/category_loading.dart';
import 'package:pet_shop/screen/Home/components/category/category_showing.dart';
import 'package:pet_shop/screen/Home/components/selection_component/selection_title.dart';
import 'package:pet_shop/screen/Home/components/trending_bar/trending_products_bar.dart';
import 'package:pet_shop/screen/Product/components/product_loading.dart';
import 'package:pet_shop/screen/Product/components/product_showing.dart';

import '../../components/Header/header_appbar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeController homeController = Get.find<HomeController>();

  //todo [Scroll]
  final ScrollController _scrollController = ScrollController();
  bool _showScrollToTopButton = false;

  @override
  void initState() {
    super.initState();
    _refreshData();

    _scrollController.addListener(() {
      if (_scrollController.offset >= 400) {
        if (!_showScrollToTopButton) {
          setState(() {
            _showScrollToTopButton = true;
          });
        }
      } else {
        if (_showScrollToTopButton) {
          setState(() {
            _showScrollToTopButton = false;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  //todo [Load data]
  Future<void> _refreshData() async {
    await homeController.getBanners();
    await homeController.getCategory();
    await homeController.getProduct();
    await homeController.getTopNewBanner();
    await homeController.getNewProduct();
    await homeController.getHighRecommendProduct();
    await homeController.getPopularProduct();
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header_Appbar(
        context: context,
        isBack: false,
        isShowingCart: true,
        id: "Yêu Thích",
      ),
      backgroundColor: CustomAppColor.lightBackgroundColor_Home,
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: Stack(
          children: [
            SingleChildScrollView(
              controller: _scrollController,
              physics: BouncingScrollPhysics(),
              child: SafeArea(
                child: Column(
                  children: [
                    // todo [Banners Loading]
                    Obx(() {
                      // Show
                      if (homeController.bannerNewList.isNotEmpty) {
                        return CarouselSliderView(
                            bannerList: homeController.bannerNewList);
                      }
                      // Loading
                      else {
                        return CarouselLoading();
                      }
                    }),
                    // todo [Category]
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          SelectionTitle(isCategory: true, name: "Thể loại"),
                          Obx(() {
                            // Show
                            if (HomeController
                                .instance.categoryList.isNotEmpty) {
                              return CategoryShowing(
                                  categories:
                                      HomeController.instance.categoryList);
                            }
                            // Loading
                            else {
                              return CategoryLoading();
                            }
                          }),
                        ],
                      ),
                    ),

                    //todo [Trending]
                    SizedBox(height: 20),
                    TrendingProductsBar(),

                    // todo [Product]
                    SizedBox(height: 20),
                    Obx(
                      () {
                        if (homeController.categoryList.isNotEmpty) {
                          return Column(
                            children: HomeController.instance.categoryList
                                .map((category) {
                              return Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  children: [
                                    SelectionTitle(
                                      name: category.name,
                                      id: category.id,
                                    ),
                                    Obx(
                                      () {
                                        final productsByCategory =
                                            homeController.productList
                                                .where((product) =>
                                                    product.category.id ==
                                                    category.id)
                                                .toList();
                                        // Show
                                        if (productsByCategory.isNotEmpty) {
                                          return ProductShowing(
                                              productList: productsByCategory);
                                        } else {
                                          return Center(
                                            child: Container(
                                              padding: EdgeInsets.all(20),
                                              child: Text(
                                                "Chưa có sản phẩm",
                                                style: TextStyle(
                                                  color: Colors.black45,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          );
                        } else {
                          return Container();
                        }
                      },
                    ),

                    //todo [List Banner Old]
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          SelectionTitle(isCategory: true, name: "Tin tức"),
                          Obx(() {
                            if (HomeController.instance.bannerList.isNotEmpty) {
                              return BannerShowing(
                                bannerList: HomeController.instance.bannerList,
                              );
                            }
                            // Loading
                            else {
                              return Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/images/_project/Logo/logo.png',
                                      width: 150, // Adjust the size as needed
                                      height: 150, // Adjust the size as needed
                                    ),
                                    SizedBox(height: 20),
                                    Text(
                                      'Không có tin tức nào',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                          }),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // todo [Scroll to top]
            if (_showScrollToTopButton)
              Positioned(
                bottom: 20,
                right: 20,
                child: FloatingActionButton(
                  onPressed: _scrollToTop,
                  child: Icon(Icons.arrow_upward),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
