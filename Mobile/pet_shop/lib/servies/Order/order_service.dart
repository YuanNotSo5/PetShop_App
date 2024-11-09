import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:pet_shop/config/cofig.dart';
import 'package:pet_shop/config/secure_storage/security_storage.dart';
import 'package:pet_shop/controllers/Account/auth_controller.dart';
import 'package:pet_shop/models/Order/order.dart';
import 'package:pet_shop/models/Order/product_order.dart';

class OrderService {
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

  Future<dynamic> get() async {
    var url = Uri.https(Config.apiURL, Config.getUserOrder);
    await init();

    var response = await client.get(Uri.parse('$url'), headers: requestHeaders);
    return response;
  }

  // todo [Get List Order Status]
  Future<dynamic> getOrderByStatus(String status) async {
    var url =
        Uri.https(Config.apiURL, Config.getOrderStauts, {'status': status});
    await init();
    var response = await client.get(Uri.parse('$url'), headers: requestHeaders);
    return response;
  }

  // todo [Update is confirm]
  Future<dynamic> updateIsConfirm(String id) async {
    var url = Uri.https(Config.apiURL, Config.updateIsConfirm, {'id': id});
    await init();
    var response = await client.get(Uri.parse('$url'), headers: requestHeaders);
    return response;
  }

  //todo [Cancel Order]
  Future<dynamic> cancelOrder(Order order) async {
    var url =
        Uri.https(Config.apiURL, "${Config.updateCancelOrder}${order.id}");
    await init();
    var body = {"status": "rejected"};

    var response = await client.put(Uri.parse('$url'),
        headers: requestHeaders, body: jsonEncode(body));

    return response;
  }

  // todo [Get Unreviewd Item]
  Future<dynamic> getUnreviewedItem() async {
    var url = Uri.https(Config.apiURL, Config.getUnreviewdItem);
    await init();
    var response = await client.get(Uri.parse('$url'), headers: requestHeaders);
    return response;
  }

  Future<dynamic> order(List<ProductOrder> selectedItems, int total,
      String address, String billing, String status, String description) async {
    await init();

    var url = Uri.https(Config.apiURL, Config.createOrderAPI);
    List<Map<String, dynamic>> jsonList = selectedItems.map((productOrder) {
      return {
        'product': productOrder.product.id,
        'quantity': productOrder.quantity,
        'price': productOrder.price,
      };
    }).toList();

    var body = {
      'products': jsonList,
      "orderTotal": total,
      "address": address,
      "billing": billing,
      "status": status ?? "pending",
      "description": description ?? ""
    };

    var response = await client.post(Uri.parse('$url'),
        headers: requestHeaders, body: jsonEncode(body));
    return response;
  }

  Future<dynamic> viewHistory() async {}
  Future<dynamic> changeState() async {}

  //Theo ngày tháng, giá tiền, sản phẩm
  Future<dynamic> findOrder() async {}
  Future<dynamic> findNewestAdrress() async {
    var url = Uri.https(Config.apiURL, Config.getLastestAddress);
    await init();

    var response = await client.get(Uri.parse('$url'), headers: requestHeaders);
    return response;
  }

  Future<dynamic> reOrder() async {}

  //todo [Post Reviews]
  Future<dynamic> commentProduct(
      String comment, double rating, String id_order, String idProduct) async {
    await init();
    var url = Uri.https(
        Config.apiURL, "${Config.productPostReviews}/$idProduct/reviews");

    var body = {
      'comment': comment,
      "rating": rating,
      "id_order": id_order,
    };

    var response = await client.post(Uri.parse('$url'),
        headers: requestHeaders, body: jsonEncode(body));
    return response;
  }

  //! Get List City
  Future<dynamic> getCityList() async {
    var url = Uri.parse(Config.getProvince);
    var requestHeaderNew = {
      'Content-Type': 'application/json',
      'token': '${Config.storeTokenGHN}',
    };
    var response = await client.get(url, headers: requestHeaderNew);
    final decodedBody = utf8.decode(response.bodyBytes);

    return decodedBody;
  }

  //! Get List District
  Future<dynamic> getDistrictList(int provinceId) async {
    var url = Uri.parse(Config.getDistrict);
    var requestHeaderNew = {
      'Content-Type': 'application/json',
      'token': '${Config.storeTokenGHN}',
    };
    var body = {
      'province_id': provinceId,
    };
    var response = await client.post(
      url,
      headers: requestHeaderNew,
      body: jsonEncode(body),
    );
    final decodedBody = utf8.decode(response.bodyBytes);

    return decodedBody;
  }

  //! Get List Ward
  Future<dynamic> getWardist(int districtId) async {
    var url = Uri.parse(Config.getWard);
    var requestHeaderNew = {
      'Content-Type': 'application/json',
      'token': '${Config.storeTokenGHN}',
    };
    var body = {
      'district_id': districtId,
    };
    var response = await client.post(
      url,
      headers: requestHeaderNew,
      body: jsonEncode(body),
    );
    final decodedBody = utf8.decode(response.bodyBytes);

    return decodedBody;
  }

  //! Get Fee
  Future<dynamic> getFee(int toDistrictId, int insurance_value, int? cod,
      String to_ward_code) async {
    var url = Uri.parse(Config.getFee);
    var requestHeaderNew = {
      'Content-Type': 'application/json',
      'token': '${Config.storeTokenGHN}',
      'shop_id': Config.shopId
    };
    var body = {
      "service_type_id": 2,
      "insurance_value": insurance_value,
      "coupon": null,
      "from_district_id": Config.shopDistrict,
      "to_district_id": toDistrictId,
      "to_ward_code": to_ward_code,
      "height": 15,
      "length": 15,
      "weight": 1000,
      "width": 15,
      "cod_value": cod ?? 0
    };

    var response = await client.post(
      url,
      headers: requestHeaderNew,
      body: jsonEncode(body),
    );
    final decodedBody = utf8.decode(response.bodyBytes);
    return decodedBody;
  }
}
