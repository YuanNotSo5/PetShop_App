import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:pet_shop/config/cofig.dart';
import 'package:pet_shop/config/secure_storage/security_storage.dart';
import 'package:pet_shop/controllers/Account/auth_controller.dart';

class FavoriteProductService {
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
    var url = Uri.https(Config.apiURL, Config.favoriteGetAllAPI);
    await init();

    var response =
        await client.get(Uri.parse('${url}'), headers: requestHeaders);
    return response;
  }

  Future<dynamic> getFavOfProduct(String id) async {
    var url = Uri.https(Config.apiURL, Config.favoriteAPI + id);
    await init();

    var response =
        await client.get(Uri.parse('${url}'), headers: requestHeaders);
    return response;
  }

  Future<dynamic> updateFav(String id) async {
    var url = Uri.https(Config.apiURL, Config.updateFavAPI + id);
    await init();

    var response =
        await client.put(Uri.parse('${url}'), headers: requestHeaders);
    return response;
  }
}
