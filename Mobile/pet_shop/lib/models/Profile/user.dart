import 'dart:convert';

List<User> categoryListFromJson(String val) => List<User>.from(
    json.decode(val)['data'].map((info) => User.fromJson(info)));

class User {
  final String id;
  final String FullName;
  final String Email;
  final String PhoneNumber;
  final String Password;
  final DateTime RegistrationDate;

  factory User.fromJson(Map<String, dynamic> data) => User(
        id: data['_id'],
        FullName: data['FullName'],
        Email: data['Email'],
        PhoneNumber: data['PhoneNumber'],
        Password: data['Password'],
        RegistrationDate: data['RegistrationDate'],
      );

  User(
      {required this.id,
      required this.FullName,
      required this.Email,
      required this.PhoneNumber,
      required this.Password,
      required this.RegistrationDate});
}
