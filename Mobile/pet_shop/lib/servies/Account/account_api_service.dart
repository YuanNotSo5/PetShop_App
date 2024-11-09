import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:pet_shop/config/cofig.dart';
import 'package:pet_shop/config/secure_storage/security_storage.dart';
import 'package:pet_shop/controllers/Account/auth_controller.dart';

class AccountApiService {
  static var client = http.Client();
  AuthController authController = Get.find<AuthController>();
  Map<String, String> requestHeadersUpdate = {};

  Future<void> init() async {
    String token = await SecurityStorage().getSecureData("token");
    requestHeadersUpdate = {
      'Content-Type': 'application/json',
      'Authorization': '${token}'
    };
  }

  //!Login
  static Future<dynamic> login({
    required String email,
    required String password,
  }) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };
    var url = Uri.https(Config.apiURL, Config.loginAPI);
    var body = {
      "email": email,
      "password": password,
    };
    var response =
        await client.post(url, headers: requestHeaders, body: jsonEncode(body));

    return response;
  }

  //!Check exists token

  // !Register
  // ? Kiểm tra email - dc thì mới cho tiếp
  static Future<dynamic> signup(
      {required String email,
      required String password,
      required String phone}) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };
    var url = Uri.https(Config.apiURL, Config.apiSignUp);
    var body = {"email": email, "password": password, "phone": phone};
    var response =
        await client.post(url, headers: requestHeaders, body: jsonEncode(body));
    return response;
  }

  //! Get OTP update password
  static Future<dynamic> getOTP({
    required String email,
  }) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };
    var url = Uri.https(Config.apiURL, Config.getOtpAPI);
    var body = {
      "email": email.trim(),
    };
    var response =
        await client.post(url, headers: requestHeaders, body: jsonEncode(body));
    return response;
  }

  // ! Verify OTP password
  static Future<dynamic> verifyOTP({
    required String email,
    required String otp,
  }) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };
    var url = Uri.https(Config.apiURL, Config.verifyOtpAPI);
    var body = {
      "email": email.trim(),
      "otp": otp.trim(),
    };
    var response =
        await client.post(url, headers: requestHeaders, body: jsonEncode(body));
    return response;
  }

  //! Change Forget Password
  static Future<dynamic> updatePassOtp({
    required String email,
    required String password,
  }) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };
    var url = Uri.https(Config.apiURL, Config.updatePassOtpAPI);
    var body = {
      "email": email.trim(),
      "password": password.trim(),
    };
    var response =
        await client.post(url, headers: requestHeaders, body: jsonEncode(body));
    return response;
  }

  //! Activate Account
  static Future<dynamic> activateAcc({
    required String activatecode,
  }) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };
    var url = Uri.https(Config.apiURL, "${Config.activateAPI}$activatecode");

    var response = await client.get(url, headers: requestHeaders);
    return response;
  }

  // ! Update Password
  Future<dynamic> updatePassword(
      {required String id,
      required String oldPassword,
      required String newPassword}) async {
    await init();
    var url = Uri.https(Config.apiURL, Config.updatePasswordAPI);
    var body = {
      "_id": id,
      "oldPassword": oldPassword,
      "newPassword": newPassword
    };
    var response = await client.post(url,
        headers: requestHeadersUpdate, body: jsonEncode(body));
    return response;
  }

  // !Add device
  Future<dynamic> addDevice({String? id_device}) async {
    await init();
    var url = Uri.https(Config.apiURL, Config.addDevice);
    var body = {
      "id_device": id_device ?? "",
    };
    var response = await client.post(url,
        headers: requestHeadersUpdate, body: jsonEncode(body));
    return response;
  }

  //!Update Info
  Future<dynamic> updateInfo({
    required String id,
    String? username,
    String? phone,
    String? address,
  }) async {
    await init();

    var url = Uri.https(Config.apiURL, '${Config.updateInfoUser}$id');

    var body = <String, String>{};
    if (username != null && username.isNotEmpty) {
      body['username'] = username;
    }
    if (phone != null && phone.isNotEmpty) {
      body['phone'] = phone;
    }
    if (address != null && address.isNotEmpty) {
      body['address'] = address;
    }
    var response = await client.put(
      url,
      headers: requestHeadersUpdate,
      body: jsonEncode(body),
    );

    return response;
  }

  //! Get Profile
  Future<dynamic> getInfo() async {
    await init();

    var url = Uri.https(Config.apiURL, Config.getProfile);

    var response = await client.get(
      url,
      headers: requestHeadersUpdate,
    );
    return response;
  }
}
