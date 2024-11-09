import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:pet_shop/config/cofig.dart';
import 'package:pet_shop/config/secure_storage/security_storage.dart';
import 'package:pet_shop/controllers/Account/auth_controller.dart';

class CartService {
  var client = http.Client();
  AuthController authController = Get.find<AuthController>();
  Map<String, String> requestHeaders = {};

  Future<void> init() async {
    String token = await SecurityStorage().getSecureData("token");
    requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': '${token}',
    };
  }

  Future<dynamic> getAll() async {
    await init();
    var url = Uri.https(Config.apiURL, Config.cartAPI);
    var response =
        await client.get(Uri.parse('${url}'), headers: requestHeaders);

    return response;
  }

  Future<dynamic> addToCart(
      String productId, int quantity, double? price) async {
    await init();

    var url = Uri.https(Config.apiURL, Config.cartAPI);
    var body = {
      "productId": productId,
      "quantity": quantity,
      "price": price ?? 0
    };

    var response = await client.post(Uri.parse('${url}'),
        headers: requestHeaders, body: jsonEncode(body));

    return response;
  }

  Future<dynamic> substractItem(String productId) async {
    var url = Uri.https(Config.apiURL, Config.subtractCartAPI);
    var body = {
      "productId": productId,
    };
    await init();

    var response = await client.post(Uri.parse('${url}'),
        headers: requestHeaders, body: jsonEncode(body));

    return response;
  }

  Future<dynamic> removeItem(String productId) async {
    var url = Uri.https(Config.apiURL, Config.cartAPI);
    var body = {
      "productId": productId,
    };
    await init();

    var response = await client.delete(Uri.parse('${url}'),
        headers: requestHeaders, body: jsonEncode(body));

    return response;
  }
}
