// import 'dart:convert';
// import 'package:hive/hive.dart';
// import 'package:pet_shop/models/Product/product.dart';

// List<UserModel> userFromJson(String val) => List<UserModel>.from(
//     json.decode(val)['data'].map((user) => UserModel.fromJson(user)));

// @HiveType(typeId: 1)
// class UserModel {
//   final String id;
//   final String email;
//   final String phone;
//   final String username;
//   final String password;
//   final String role;
//   final String status;
//   final String image;
//   final List<Product> favorites;
//   final String activateCode;

//   factory UserModel.fromJson(Map<String, dynamic> data) => UserModel(
//         id: data['_id'] ?? '',
//         email: data['email'] ?? '',
//         phone: data['phone'] ?? '',
//         username: data['username'] ?? '',
//         password: data['password'] ?? '',
//         role: data['role'] ?? '',
//         status: data['status'] ?? '',
//         image: data['image'] ?? '',
//         favorites: (data['favorites'] != null
//             ? List<Product>.from(
//                 data['favorites'].map((item) => Product.fromJson(item)))
//             : []),
//         activateCode: '',
//       );

//   UserModel({
//     required this.id,
//     required this.email,
//     required this.phone,
//     required this.username,
//     required this.password,
//     required this.role,
//     required this.status,
//     required this.image,
//     required this.favorites,
//     required this.activateCode,
//   });
// }

import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:pet_shop/models/Product/product.dart';

// Function to parse JSON list to List<UserModel>
List<UserModel> userFromJson(String val) => List<UserModel>.from(
    json.decode(val)['data'].map((user) => UserModel.fromJson(user)));

@HiveType(typeId: 1)
class UserModel {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String email;
  @HiveField(2)
  final String phone;
  @HiveField(3)
  final String username;
  @HiveField(4)
  final String password;
  @HiveField(5)
  final String role;
  @HiveField(6)
  final String status;
  @HiveField(7)
  final String image;
  @HiveField(8)
  final List<Product> favorites;
  @HiveField(9)
  final String activateCode;
  // @HiveField(10)
  // final String token;

  factory UserModel.fromJson(Map<String, dynamic> data) => UserModel(
        id: data['_id'] ?? '',
        email: data['email'] ?? '',
        phone: data['phone'] ?? '',
        username: data['username'] ?? '',
        password: data['password'] ?? '',
        role: data['role'] ?? '',
        status: data['status'] ?? '',
        image: data['image'] ?? '',
        favorites: data['favorites'] != null
            ? List<Product>.from(
                data['favorites'].map((item) => Product.fromJson(item)))
            : [],
        activateCode: data['activationCode'] ?? '',
        // token: data['token'] ?? '',
      );

  UserModel({
    required this.id,
    required this.email,
    required this.phone,
    required this.username,
    required this.password,
    required this.role,
    required this.status,
    required this.image,
    required this.favorites,
    required this.activateCode,
    // required this.token,
  });
}

class UserInfo {
  final String id;
  final String email;
  final String phone;
  final String username;
  final String password;
  final String role;
  final String image;
  // final List<String> favorites;
  final String token;
  final String id_device;
  final String address;

  factory UserInfo.fromJson(Map<String, dynamic> data) => UserInfo(
        id: data['_id'] ?? '',
        email: data['email'] ?? '',
        phone: data['phone'] ?? '',
        username: data['username'] ?? '',
        password: data['password'] ?? '',
        role: data['role'] ?? '',
        image: data['image'] ?? '',
        // favorites: data['favorites'] ?? [],
        token: data['token'] ?? '',
        id_device: data['id_device'],
        address: data['address'],
      );

  UserInfo({
    required this.id,
    required this.email,
    required this.phone,
    required this.username,
    required this.password,
    required this.role,
    required this.image,
    // required this.favorites,
    required this.token,
    required this.id_device,
    required this.address,
  });

  @override
  String toString() {
    return 'UserInfo(id: $id, email: $email, phone: $phone, username: $username, role: $role, image: $image, token: $token, id_device: $id_device, address: $address)';
  }
}
