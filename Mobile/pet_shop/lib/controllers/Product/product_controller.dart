import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:pet_shop/config/snack_bar_inform/snackbar_custom.dart';
import 'package:pet_shop/models/Account/user_model.dart';
import 'package:pet_shop/models/Pagination/pagination.dart';
import 'package:pet_shop/models/Product/category.dart';
import 'package:pet_shop/models/Product/favorite_product.dart';
import 'package:pet_shop/models/Product/product.dart';
import 'package:pet_shop/models/Product/review.dart';
import 'package:pet_shop/servies/Product/category_service.dart';
import 'package:pet_shop/servies/Product/favorite_product_service.dart';
import 'package:pet_shop/servies/Product/product_service.dart';

class ProductController extends GetxController {
  static ProductController instance = Get.find();

  //todo [Fav]
  RxList<Product> favoriteList = <Product>[].obs;
  RxBool isFav = false.obs;
  RxList<Product> productList = <Product>[].obs;
  RxList<Product> productListSearch = <Product>[].obs;
  RxList<Product> productRecommended = <Product>[].obs;

  //todo [Review List]
  List<Review> reviewList = <Review>[].obs;

  Rx<PaginatedList> pages = PaginatedList(
    totalDocs: 0,
    limit: 0,
    totalPages: 0,
    page: 0,
    pagingCounter: 0,
    hasPrevPage: false,
    hasNextPage: false,
    prevPage: null,
    nextPage: null,
  ).obs;
  RxBool isFavoriteLoading = false.obs;
  RxBool isProductLoading = false.obs;
  RxBool isReviewLoading = false.obs;

  // todo [Category]
  RxList<Category> categoryList = List<Category>.empty(growable: true).obs;
  RxBool isCategoryLoading = false.obs;

  //
  Rxn<Product> product = Rxn<Product>();

  @override
  void onInit() {
    getAllFavoriteProduct();
    super.onInit();
  }

  //! Category
  //todo [Search Category By Name]
  Future<bool> getCategoryByName(String regrex,
      {String? page, String? limit}) async {
    try {
      isCategoryLoading(true);
      var result = await CategoryService().searchByName(regrex, page, limit);
      if (result != null) {
        categoryList.assignAll(categoryListFromJson(result.body));
        pages.value = paginatedListFromJson(result.body);
      }
    } catch (e) {
      print("Exception while fetching with Category Search By Name: $e");
      return false;
    } finally {
      isCategoryLoading(false);
      print("Final Category Search By Name length: ${categoryList.length}");
      return true;
    }
  }

  //todo [Fav Products]
  void getAllFavoriteProduct() async {
    try {
      isFavoriteLoading(true);

      var results = await FavoriteProductService().getAll();
      if (results != null && results.statusCode == 200) {
        favoriteList.assignAll(productFavListFromJson(results.body));
      }
    } catch (e) {
      print("Exception while fetching favorite products: $e");
    } finally {
      isFavoriteLoading(false);

      print("Final Favorite length: ${favoriteList.length}");
    }
  }

  Future<bool> getFavOfProduct(String id) async {
    dynamic data;
    bool result = false;
    try {
      isFavoriteLoading(true);

      var results = await FavoriteProductService().getFavOfProduct(id);
      if (results != null && results.statusCode == 200) {
        data = jsonDecode(results.body);
        result = data['data'] as bool;
      }
      isFav(result);
      return result;
    } catch (e) {
      print("Exception while fetching favorite products: $e");
      isFav(false);

      return false;
    } finally {
      isFavoriteLoading(false);
      print("is Fav $result");
    }
  }

  void toggleFavorite() {
    isFav.value = !isFav.value;
  }

  void updateFavOfProduct(String id) async {
    dynamic data;
    bool result = false;
    try {
      isFavoriteLoading(true);
      toggleFavorite();

      var results = await FavoriteProductService().updateFav(id);

      if (results != null && results.statusCode == 200) {
        data = jsonDecode(results.body);
        result = data['data'] as bool;
      }
      if (result) {}
    } catch (e) {
      print("Exception while fetching favorite products: $e");
    } finally {
      getAllFavoriteProduct();

      isFavoriteLoading(false);
      print("is Fav $result");
    }
  }

  //todo [Products in category]
  Future<bool> getProductsByCategory(String id,
      {String? page, String? limit}) async {
    try {
      isProductLoading(true);
      var result =
          await CategoryService().getProductInCategory(id, page, limit);
      if (result != null) {
        productList.assignAll(productListInCate(result.body));
      }
    } catch (e) {
      print("Exception while fetching category with products: $e");
      return false;
    } finally {
      isProductLoading(false);

      print("Final Products list In Cate length: ${productList.length}");
      return true;
    }
  }

  //todo [Products by Id]
  Future<bool> getProductById(
    String id,
  ) async {
    try {
      EasyLoading.show(
        status: 'Loading',
        dismissOnTap: false,
      );
      isProductLoading(true);
      var result = await ProductService().getById(id);
      if (result != null) {
        var data = json.decode(result.body);
        var tmp = data["data"];
        product.value = Product.fromJson(tmp);
      }
    } catch (e) {
      print("Exception while fetching category with products: $e");
      return false;
    } finally {
      isProductLoading(false);
      EasyLoading.dismiss();

      print("Final Products list In Cate length: ${productList.length}");
      return true;
    }
  }

  Future<List<Product>> getMoreProductByCategory(String id,
      {String? page, String? limit}) async {
    List<Product> products = [];
    try {
      isProductLoading(true);
      var result =
          await CategoryService().getProductInCategory(id, page, limit);
      if (result != null && result.body != null) {
        products = productListInCate(result.body);
      }
    } catch (e) {
      print("Exception while fetching category with products: $e");
    } finally {
      isProductLoading(false);
    }
    return products;
  }

  //todo [Product Search By Name]
  Future<bool> getProductByName(String regrex,
      {String? page, String? limit}) async {
    try {
      isProductLoading(true);
      var result = await ProductService().searchByName(regrex, page, limit);

      if (result != null) {
        productListSearch.assignAll(productListFromJson(result.body));
        pages.value = paginatedListFromJson(result.body);
      }
    } catch (e) {
      print("Exception while fetching with products Search: $e");
      return false;
    } finally {
      isProductLoading(false);
      print("Final Products Search length: ${productListSearch.length}");
      return true;
    }
  }

  //todo [Product Search By Price]
  Future<bool> getProductByPrice(double min, double max,
      {String? page, String? limit}) async {
    try {
      isReviewLoading(true);
      var result = await ProductService().searchByPrice(min, max, page, limit);
      if (result != null) {
        productListSearch.assignAll(productListFromJson(result.body));
        pages.value = paginatedListFromJson(result.body);
      }
    } catch (e) {
      print("Exception while fetching with reviews: $e");
      return false;
    } finally {
      isReviewLoading(false);

      print("Final Products Price length: ${productListSearch.length}");
      return true;
    }
  }

  //todo [Product Reviews]
  Future<bool> getProductReview(String productId,
      {String? page, String? limit}) async {
    try {
      isProductLoading(true);
      var result =
          await ProductService().searchReviewsOfProduct(productId, page, limit);
      if (result != null) {
        reviewList.assignAll(reviewsListFromJson(result.body));
        // pages.value = paginatedListFromJson(result.body);
      }
    } catch (e) {
      print("Exception while fetching with products review: $e");
      return false;
    } finally {
      isProductLoading(false);

      print("Final Products Searreviewch length: ${reviewList.length}");
      return true;
    }
  }

  //todo [Product Recommend]
  Future<bool> getRecommendProduct(String id) async {
    try {
      isProductLoading(true);
      var result = await ProductService().recommendProduct(id);
      if (result != null) {
        productRecommended
            .assignAll(productListRecommendedFromJson(result.body));
      }
    } catch (e) {
      print("Exception while fetching category with products: $e");
      return false;
    } finally {
      isProductLoading(false);
      print(
          "Final Products Recommend list In Cate length: ${productList.length}");
      return true;
    }
  }
}
