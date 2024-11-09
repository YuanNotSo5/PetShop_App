import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:pet_shop/config/secure_storage/security_storage.dart';
import 'package:pet_shop/controllers/Order/order_controller.dart';
import 'package:pet_shop/models/Account/user_model.dart';
import 'package:pet_shop/servies/Account/account_api_service.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();
  Rxn<UserInfo> user = Rxn<UserInfo>();
  RxBool isLogin = false.obs;

  @override
  void onInit() {
    super.onInit();
    checkLogin();
  }

  //!Register
  Future<bool> signUp(
      {required String email,
      required String password,
      required String phone}) async {
    try {
      EasyLoading.show(
        status: 'Loading',
        dismissOnTap: false,
      );

      var result = await AccountApiService.signup(
          email: email.trim(), password: password.trim(), phone: phone);
      if (result.statusCode == 200) {
        var data = json.decode(result.body);

        if (data == "Email is exist") {
          EasyLoading.showError("Email này đã được sử dụng");
          return false;
        }
        EasyLoading.showSuccess(
            "Thành công! Vui lòng kiểm tra thư trong hòm thư của bạn");
        return true;
      } else {
        EasyLoading.showError(
            "Số điện thoại này đã được dùng để đăng ký tài khoản khác");
        return false;
      }
    } catch (e) {
      EasyLoading.showError(
          "Hệ thống đang xảy ra lỗi $e, vui lòng thử lại sau");
      return false;
    } finally {
      EasyLoading.dismiss();
    }
  }

  //! [SET STATUS]
  String? get token => user.value?.token;

  void setUser(UserInfo? newUser) {
    user.value = newUser;
  }

  void clear() {
    user.value = null;
  }

  // !Check Login
  void checkLogin() async {
    bool isCheckLogin = await SecurityStorage().readSecureData("token");
    isLogin(isCheckLogin);
  }

  //! Log out
  // Future<bool> logout() async {
  //   List<Future<void>> deleteFutures = [
  //     SecurityStorage().deleteSecureData("token"),
  //     SecurityStorage().deleteSecureData("phone"),
  //     SecurityStorage().deleteSecureData("username"),
  //     SecurityStorage().deleteSecureData("image"),
  //     SecurityStorage().deleteSecureData("password"),
  //     SecurityStorage().deleteSecureData("id"),
  //     SecurityStorage().deleteSecureData("email"),
  //     SecurityStorage().deleteSecureData("noti_id"),
  //     SecurityStorage().deleteSecureData("address"),
  //   ];
  //   try {
  //     await Future.wait(deleteFutures);
  //     isLogin(false);
  //     EasyLoading.showSuccess("Đăng xuất thành công");
  //     return true;
  //   } catch (e) {
  //     return false;
  //   } finally {
  //     EasyLoading.dismiss();
  //   }
  // }

  Future<bool> logout() async {
    List<Future<void>> deleteFutures = [
      SecurityStorage().deleteSecureData("token"),
      SecurityStorage().deleteSecureData("phone"),
      SecurityStorage().deleteSecureData("username"),
      SecurityStorage().deleteSecureData("image"),
      SecurityStorage().deleteSecureData("password"),
      SecurityStorage().deleteSecureData("id"),
      SecurityStorage().deleteSecureData("email"),
      SecurityStorage().deleteSecureData("noti_id"),
      SecurityStorage().deleteSecureData("address"),
    ];
    try {
      await Future.wait(deleteFutures);
      isLogin(false);

      WidgetsBinding.instance.addPostFrameCallback((_) {
        EasyLoading.showSuccess("Đăng xuất thành công");
      });

      // Optionally, delay dismissing to ensure the message is shown
      await Future.delayed(Duration(milliseconds: 500));
      return true;
    } catch (e) {
      return false;
    } finally {
      await Future.delayed(Duration(milliseconds: 500));
      EasyLoading.dismiss();
    }
  }

  //!Login
  Future<int> login({
    required String email,
    required String password,
  }) async {
    try {
      EasyLoading.show(
        status: 'Loading',
        dismissOnTap: false,
      );
      var result = await AccountApiService.login(
          email: email.trim(), password: password.trim());
      if (result.statusCode == 200) {
        EasyLoading.showSuccess("Chào mừng đến với Pet Shop");
        isLogin(true);
        var data = json.decode(result.body);
        var userData = data['user'];
        var token = data['token'] ?? '';
        SecurityStorage().writeSecureData("token", token);

        user.value = UserInfo.fromJson({...userData, 'token': token});
        SecurityStorage().writeSecureData("phone", user.value!.phone);
        SecurityStorage().writeSecureData("username", user.value!.username);
        SecurityStorage().writeSecureData("image", user.value!.image);
        SecurityStorage().writeSecureData("password", user.value!.password);
        SecurityStorage().writeSecureData("id", user.value!.id);
        SecurityStorage().writeSecureData("email", user.value!.email);
        SecurityStorage().writeSecureData("address", user.value!.address);
        SecurityStorage().writeSecureData(
            "noti_id", user.value!.id_device); // ? get notification allow
        return 1;
      } else {
        var data = json.decode(result.body);
        isLogin(false);
        if (data['message']?.trim() == "wrong password!") {
          EasyLoading.showError("Xin kiểm tra lại mật khẩu của bạn");
          return -1;
        } else if (data['message']?.trim() == "Unregistered account!") {
          EasyLoading.showError("Không tồn tại gmail này");
          return -2;
        } else if (data['message']?.trim() == "Account is not active!") {
          EasyLoading.showError(
              "Tài khoản này chưa được kích hoạt, vui lòng kích hoạt tài khoản");
          return -3;
        }
        EasyLoading.showError("Hệ thống đang xảy ra lỗi, vui lòng thử lại sau");
        return 0;
      }
    } catch (e) {
      EasyLoading.showError(
          "Hệ thống đang xảy ra lỗi $e, vui lòng thử lại sau");
      isLogin(false);
      return 0;
    } finally {
      EasyLoading.dismiss();
    }
  }

  //!Forget Password
  Future<int> getOTP({
    required String email,
  }) async {
    try {
      EasyLoading.show(
        status: 'Loading',
        dismissOnTap: false,
      );
      var result = await AccountApiService.getOTP(email: email.trim());
      if (result.statusCode == 200) {
        EasyLoading.showSuccess("Mã OTP đã được gửi tới email của bạn");
        return 1;
      } else {
        var data = json.decode(result.body);
        var message = data['message'];
        if (message?.trim() == "Unregistered account!") {
          EasyLoading.showError("Email của bạn chưa được đăng ký");
          return -1;
        } else if (message?.trim() == "Account is not active!") {
          EasyLoading.showError(
              "Bạn chưa kích hoạt tài khoản, vui lòng kiểm tra email");
          return -2;
        } else if (message?.trim() == "Error sending email") {
          EasyLoading.showError(
              "Đã xảy ra lỗi trong quá trình gửi thư. Vui lòng thử lại sau!");
          return -3;
        }
        EasyLoading.showError(
            "Xảy ra sự cố với email của bạn, vui lòng kiểm tra!");
        return 0;
      }
    } catch (e) {
      EasyLoading.showError(
          "Hệ thống đang xảy ra lỗi $e, vui lòng thử lại sau");
      return 0;
    } finally {
      EasyLoading.dismiss();
    }
  }

  // ! Verify OTP
  Future<int> verifyOTP({
    required String email,
    required String otp,
  }) async {
    try {
      EasyLoading.show(
        status: 'Loading',
        dismissOnTap: false,
      );
      var result = await AccountApiService.verifyOTP(
          email: email.trim(), otp: otp.trim());
      if (result.statusCode == 200) {
        EasyLoading.showSuccess("Xác thực thành công");
        return 1;
      } else {
        var data = json.decode(result.body);
        var message = data['message'];
        if (message?.trim() == "OTP has expired!") {
          EasyLoading.showError("Mã OTP này đã hết hạn");
          return -1;
        } else if (message?.trim() == "Invalid OTP") {
          EasyLoading.showError("Mã OTP không chính xác!");
          return -2;
        }
        EasyLoading.showError(
            "Xảy ra sự cố với máy chủ. Vui lòng thao tác lại sau vài phút");
        return 0;
      }
    } catch (e) {
      EasyLoading.showError(
          "Hệ thống đang xảy ra lỗi $e, vui lòng thử lại sau");
      return 0;
    } finally {
      EasyLoading.dismiss();
    }
  }

  // !Update Password OTP
  Future<int> updatePasswordOtp({
    required String email,
    required String password,
  }) async {
    try {
      EasyLoading.show(
        status: 'Loading',
        dismissOnTap: false,
      );
      var result = await AccountApiService.updatePassOtp(
          email: email.trim(), password: password.trim());
      if (result.statusCode == 200) {
        EasyLoading.showSuccess(
            "Cập nhật mật khẩu thành công! Vui lòng đăng nhập lại");
        return 1;
      } else {
        var data = json.decode(result.body);
        var message = data['message'];
        if (message?.trim() ==
            "New password cannot be the same as the old password") {
          EasyLoading.showError(
              "Mật khẩu mới không được trùng với mật khẩu cũ");
          return -1;
        }
        EasyLoading.showError(
            "Xảy ra sự cố với máy chủ. Vui lòng thao tác lại sau vài phút 1");
        return 0;
      }
    } catch (e) {
      EasyLoading.showError(
          "Hệ thống đang xảy ra lỗi $e, vui lòng thử lại sau");
      return 0;
    } finally {
      EasyLoading.dismiss();
    }
  }

  // ! Activate Acc
  Future<int> activateAcc({
    required String activationCode,
  }) async {
    try {
      EasyLoading.show(
        status: 'Loading',
        dismissOnTap: false,
      );
      var result =
          await AccountApiService.activateAcc(activatecode: activationCode);
      if (result.statusCode == 200) {
        EasyLoading.showSuccess("Tài khoản kích hoạt thành công");
        return 1;
      } else if (result.statusCode == 404) {
        EasyLoading.showError("Mã kích hoạt không hợp lệ");
        return 0;
      }
      EasyLoading.showError(
          "Xảy ra sự cố với máy chủ. Vui lòng thao tác lại sau vài phút 2");
      return 0;
    } catch (e) {
      EasyLoading.showError(
          "Hệ thống đang xảy ra lỗi $e, vui lòng thử lại sau");
      return 0;
    } finally {
      EasyLoading.dismiss();
    }
  }

  // !Update Password
  Future<int> updatePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      EasyLoading.show(
        status: 'Loading',
        dismissOnTap: false,
      );

      String id = await SecurityStorage().getSecureData("id");
      var result = await AccountApiService().updatePassword(
        id: id,
        newPassword: newPassword.trim(),
        oldPassword: oldPassword.trim(),
      );
      var data = json.decode(result.body);
      var message = data['message'];
      if (result.statusCode == 200) {
        EasyLoading.showSuccess("Cập nhật mật khẩu thành công!");
        return 1;
      } else if (result.statusCode == 400) {
        if (message?.trim() == "Incorrect current password") {
          EasyLoading.showError("Mật khẩu không đúng!");
          return -1;
        }
        EasyLoading.showError("Mật khẩu mới không được trùng với mật khẩu cũ");
        return -2;
      }
      EasyLoading.showError(
          "Xảy ra sự cố với máy chủ. Vui lòng thao tác lại sau vài phút 3");
      return 0;
    } catch (e) {
      EasyLoading.showError(
          "Hệ thống đang xảy ra lỗi $e, vui lòng thử lại sau");
      return 0;
    } finally {
      EasyLoading.dismiss();
    }
  }

  // ! Add device notifictation
  Future<int> addDevice({
    String? id_device,
  }) async {
    try {
      print("pppppppppppppppp $id_device");

      EasyLoading.show(
        status: 'Loading',
        dismissOnTap: false,
      );
      var result = await AccountApiService().addDevice(
        id_device: id_device ?? "",
      );
      if (result.statusCode == 200) {
        // EasyLoading.showSuccess("Xin chàoooooo");
        return 1;
      }
      EasyLoading.showError(
          "Xảy ra sự cố với máy chủ. Vui lòng thao tác lại sau vài phút 4");
      return 0;
    } catch (e) {
      EasyLoading.showError(
          "Hệ thống đang xảy ra lỗi $e, vui lòng thử lại sau");
      return 0;
    } finally {
      EasyLoading.dismiss();
    }
  }

  // !Update Info
  // Future<int> updateInfo({
  //   String? username,
  //   String? phone,
  //   String? address,
  // }) async {
  //   try {
  //     EasyLoading.show(
  //       status: 'Loading',
  //       dismissOnTap: false,
  //     );

  //     String id = await SecurityStorage().getSecureData("id");

  //     Map<String, String> body = {};

  //     if (username != null && username.isNotEmpty) {
  //       body['username'] = username;
  //     }

  //     if (phone != null && phone.isNotEmpty) {
  //       body['phone'] = phone;
  //     }

  //     if (address != null && address.isNotEmpty) {
  //       body['address'] = address;
  //     }

  //     var result = await AccountApiService().updateInfo(
  //       id: id,
  //       username: body['username'],
  //       phone: body['phone'],
  //       address: body['address'],
  //     );

  //     var data = json.decode(result.body);
  //     var message = data['message'];

  //     if (result.statusCode == 200) {
  //       print("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");

  //       EasyLoading.showSuccess("Cập nhật thành công!");
  //       return 1;
  //     } else {
  //       EasyLoading.showError(
  //         "Xảy ra sự cố với máy chủ. Vui lòng thao tác lại sau vài phút.",
  //       );
  //       return 0;
  //     }
  //   } catch (e) {
  //     EasyLoading.showError(
  //       "Hệ thống đang xảy ra lỗi $e, vui lòng thử lại sau",
  //     );
  //     return 0;
  //   } finally {
  //     EasyLoading.dismiss();
  //     await getProfile();
  //   }
  // }
  Future<int> updateInfo({
    String? username,
    String? phone,
    String? address,
  }) async {
    try {
      EasyLoading.show(
        status: 'Loading',
        dismissOnTap: false,
      );

      String id = await SecurityStorage().getSecureData("id");

      Map<String, String> body = {};

      if (username != null && username.isNotEmpty) {
        body['username'] = username;
      }

      if (phone != null && phone.isNotEmpty) {
        body['phone'] = phone;
      }

      if (address != null && address.isNotEmpty) {
        body['address'] = address;
      }

      var result = await AccountApiService().updateInfo(
        id: id,
        username: body['username'],
        phone: body['phone'],
        address: body['address'],
      );

      var data = json.decode(result.body);
      var message = data['message'];

      if (result.statusCode == 200) {
        print("Update successful: $message");

        WidgetsBinding.instance.addPostFrameCallback((_) {
          EasyLoading.showSuccess("Cập nhật thành công!");
        });

        // Optionally, delay dismissing to ensure the message is shown
        await Future.delayed(Duration(milliseconds: 500));
        return 1;
      } else {
        EasyLoading.showError(
          "Xảy ra sự cố với máy chủ. Vui lòng thao tác lại sau vài phút.",
        );
        return 0;
      }
    } catch (e) {
      EasyLoading.showError(
        "Hệ thống đang xảy ra lỗi $e, vui lòng thử lại sau",
      );
      return 0;
    } finally {
      await Future.delayed(Duration(milliseconds: 500));
      EasyLoading.dismiss();
      await getProfile();
    }
  }

  //! Get Profile
  Future<Object?> getProfile() async {
    try {
      EasyLoading.show(
        status: 'Loading',
        dismissOnTap: false,
      );
      var result = await AccountApiService().getInfo();
      if (result.statusCode == 200) {
        var data = json.decode(result.body);
        var userData = data['data'];

        user.value = UserInfo.fromJson({...userData});
      }
      return user.value;
    } catch (e) {
      EasyLoading.showError(
          "Hệ thống đang xảy ra lỗi $e, vui lòng thử lại sau");
      return null;
    } finally {
      EasyLoading.dismiss();
    }
  }
}
