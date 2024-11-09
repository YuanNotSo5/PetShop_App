import 'package:http/http.dart' as http;
import 'package:pet_shop/config/cofig.dart';

class BannersService {
  var client = http.Client();
  var url = Uri.https(Config.apiURL, Config.bannerAPI);
  Map<String, String> requestHeaders = {
    'Content-Type': 'application/json',
  };
  Future<dynamic> get() async {
    var response =
        await client.post(Uri.parse('$url'), headers: requestHeaders);
    return response;
  }

  Future<dynamic> getTopNewBanner() async {
    var url = Uri.https(Config.apiURL, '${Config.bannerNewAPI}');
    var response = await client.get(Uri.parse('$url'), headers: requestHeaders);
    return response;
  }

  Future<dynamic> getById(String id) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };
    var url = Uri.https(Config.apiURL, '${Config.getBannerIdAPI}${id}');

    var response = await client.get(Uri.parse('$url'), headers: requestHeaders);

    return response;
  }
}
