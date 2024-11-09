import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pet_shop/config/cofig.dart';

class CategoryService {
  var client = http.Client();

  //todo [Get List Category]
  Future<dynamic> get() async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };
    var url = Uri.https(Config.apiURL, Config.categoryAPI);

    var response = await client.get(Uri.parse('$url'), headers: requestHeaders);

    return response;
  }

  //todo [Get Products Of Category]
  Future<dynamic> getProductInCategory(
      String _id, String? page, String? limit) async {
    final queryParameters = {
      if (page != null && page.isNotEmpty) 'page': page,
      if (limit != null && limit.isNotEmpty) 'limit': limit,
    };

    var url = Uri.https(
        Config.apiURL, Config.categoryContainProducts + _id, queryParameters);

    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };
    var response =
        await client.post(url, headers: requestHeaders, body: jsonEncode({}));

    return response;
  }

  //todo [Search Category By Name]
  Future<dynamic> searchByName(
      String regrex, String? page, String? limit) async {
    final queryParameters = {
      if (page != null && page.isNotEmpty) 'page': page,
      if (limit != null && limit.isNotEmpty) 'limit': limit,
      'name': regrex
    };

    var url =
        Uri.https(Config.apiURL, Config.categorySearchByName, queryParameters);

    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };
    print(url);
    var response = await client.get(url, headers: requestHeaders);

    return response;
  }

  //todo [Search Category By Slug]
  Future<dynamic> searchProductsBySlug(
      String slug, String? page, String? limit) async {
    final queryParameters = {
      if (page != null && page.isNotEmpty) 'page': page,
      if (limit != null && limit.isNotEmpty) 'limit': limit,
    };

    var url = Uri.https(Config.apiURL, "${Config.searchProductsBySlug}$slug");

    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };
    var response = await client.get(url, headers: requestHeaders);
    return response;
  }

  Future<dynamic> getIdBySlug(String slug, String? page, String? limit) async {
    final queryParameters = {
      if (page != null && page.isNotEmpty) 'page': page,
      if (limit != null && limit.isNotEmpty) 'limit': limit,
    };

    var url = Uri.https(Config.apiURL, "${Config.getIdBySlug}$slug");

    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };
    var response = await client.get(url, headers: requestHeaders);
    return response;
  }
}
