import 'package:get/get.dart';
import 'dart:convert';

import 'package:get/get_rx/get_rx.dart';

import 'package:pet_shop/models/Product/product.dart';
import 'package:pet_shop/servies/Product/product_service.dart';

class FilterController extends GetxController {
  static FilterController instance = Get.find();

  var isChanged = false.obs;
  var isReset = false.obs;

  RxBool isLoading = false.obs;
  var currentPage = 1.obs;

  var selectedChips = <String>[].obs;
  double ratingVal = 0.0;
  double minVal = 0.0;
  double maxVal = 0.0;

  RxList<Product> productListSearch = <Product>[].obs;

  void updateFilters({
    required List<String> chips,
    required double rating,
    required double minPrice,
    required double maxPrice,
    required String idCate,
  }) async {
    selectedChips.value = chips;
    ratingVal = rating;
    minVal = minPrice;
    maxVal = maxPrice;
    var dataFilter = {
      "rating": ratingVal == 0.0 ? null : ratingVal,
      "min": minVal == 0 ? null : minVal,
      "max": maxVal == 0 ? null : maxVal,
      "isOld": selectedChips.contains("Cũ nhất") ? true : false,
      "isNew": selectedChips.contains("Mới nhất") ? true : false,
      "isAvailable": selectedChips.contains("Còn hàng") ? true : false,
      "isPopular": selectedChips.contains("Phổ biến") ? true : false,
    };
    currentPage.value = 1;

    var isSuccess =
        productFilter(dataFilter, page: "$currentPage", idCate: idCate);
    if (await isSuccess) {}
  }

  void updateChanged(bool value) {
    isChanged.value = value;
  }

  void updateCurrentPage() {
    currentPage.value += 1;
  }

  void updateReset(bool value) {
    isReset.value = value;

    if (value == true) {
      currentPage.value = 1;
      // updateChanged(false);
      this.productListSearch.clear();
    }
  }

  //todo [Product After Filter]
  Future<bool> productFilter(Map<String, Object?> dataFilter,
      {String? page, String? limit, String? idCate}) async {
    try {
      isLoading(true);
      var result =
          await ProductService().filterProduct(dataFilter, page, limit, idCate);

      if (result != null) {
        productListSearch.assignAll(productListFromJson(result.body));
      }
    } catch (e) {
      print("Exception while fetching with products Search Filter: $e");
      return false;
    } finally {
      isLoading(false);
      print("Final Products Search Filter length: ${productListSearch.length}");
      return true;
    }
  }

  //todo [Product After Filter]
  Future<List<Product>> getMoreProductFilter(
      {String? page, String? limit, String? idCate}) async {
    List<Product> products = [];
    var dataFilter = {
      "rating": ratingVal == 0.0 ? null : ratingVal,
      "min": minVal == 0 ? null : minVal,
      "max": maxVal == 0 ? null : maxVal,
      "isOld": selectedChips.contains("Cũ nhất") ? true : false,
      "isNew": selectedChips.contains("Mới nhất") ? true : false,
      "isAvailable": selectedChips.contains("Còn hàng") ? true : false,
      "isPopular": selectedChips.contains("Phổ biến") ? true : false,
    };
    try {
      isLoading(true);
      var result = await ProductService().filterProduct(
          dataFilter, currentPage.value.toString(), limit, idCate);

      if (result != null && result.body != null) {
        products = productListFromJson(result.body);
      }
    } catch (e) {
      print("Exception while fetching with products Search Filter: $e");
    } finally {
      isLoading(false);
      print("Final Products Search Filter length: ${products.length}");
    }
    productListSearch.addAll(products);
    return products;
  }
}
