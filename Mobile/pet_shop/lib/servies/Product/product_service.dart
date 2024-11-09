import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pet_shop/config/cofig.dart';

class ProductService {
  var client = http.Client();

  Future<dynamic> getAll() async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };
    var url = Uri.https(Config.apiURL, Config.productAPI);

    var response = await client.post(url, headers: requestHeaders);
    return response;
  }

  Future<dynamic> getById(String id) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };
    var url = Uri.https(Config.apiURL, '${Config.getProductByID}${id}');

    var response = await client.get(url, headers: requestHeaders);

    return response;
  }

  //todo [Get New Product]
  Future<dynamic> getNewProduct() async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };
    var url = Uri.https(Config.apiURL, Config.getNewProduct);

    var response = await client.get(url, headers: requestHeaders);
    return response;
  }

  Future<dynamic> getPopularProduct() async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };
    var url = Uri.https(Config.apiURL, Config.getPopularProduct);

    var response = await client.get(url, headers: requestHeaders);
    return response;
  }

  Future<dynamic> getHighRecommendProduct() async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };
    var url = Uri.https(Config.apiURL, Config.getHighRecommendProduct);

    var response = await client.get(url, headers: requestHeaders);
    return response;
  }

  // todo [Search]
  Future<dynamic> searchByName(
      String regrex, String? page, String? limit) async {
    final queryParameters = {
      if (page != null && page.isNotEmpty) 'page': page,
      if (limit != null && limit.isNotEmpty) 'limit': limit,
      'name': regrex
    };
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };
    var url =
        Uri.https(Config.apiURL, Config.productSearchName, queryParameters);
    var response = await client.get(url, headers: requestHeaders);
    return response;
  }

  Future<dynamic> searchByPrice(
      double min, double max, String? page, String? limit) async {
    final queryParameters = {
      if (page != null && page.isNotEmpty) 'page': page,
      if (limit != null && limit.isNotEmpty) 'limit': limit,
      'minPrice': min,
      "maxPrice": max
    };
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };
    var url = Uri.https(Config.apiURL, Config.productSearchPrice);
    var response = await client.post(url,
        headers: requestHeaders, body: jsonEncode(queryParameters));
    return response;
  }

  //Todo [Reviews of product]
  Future<dynamic> searchReviewsOfProduct(
      String productId, String? page, String? limit) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };
    var url = Uri.https(
        Config.apiURL, Config.productGetReviews + '$productId/reviews');
    var response = await client.get(url, headers: requestHeaders);
    return response;
  }

  //todo [Get recommend order]
  Future<dynamic> recommendProduct(String productId) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };
    var url =
        Uri.https(Config.apiURL, Config.recommendedProduct + '$productId');
    var response = await client.get(url, headers: requestHeaders);
    return response;
  }

  // todo [Filter Product]
  Future<dynamic> filterProduct(Map<String, Object?> dataFilter, String? page,
      String? limit, String? idCate) async {
    var url = Uri.https(Config.apiURL, Config.filterProduct);
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };
    var body = {
      if (page != null && page.isNotEmpty) 'page': page,
      if (limit != null && limit.isNotEmpty) 'limit': limit,
      'dataFilter': dataFilter,
      if (idCate != null && idCate.isNotEmpty) 'idCate': idCate
    };
    var response =
        await client.post(url, headers: requestHeaders, body: jsonEncode(body));
    return response;
  }
}
