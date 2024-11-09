import 'dart:convert';

LoginResponseModel loginResponseJson(String str) =>
    LoginResponseModel.fromJson(json.decode(str));

class LoginResponseModel {
  LoginResponseModel({
    required this.status,
    required this.msg,
    required this.data,
  });

  late final int status;
  late final String msg;
  late final Data data;

  LoginResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    msg = json['msg'];
    data = Data.fromJson(json['data']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['msg'] = msg;
    _data['data'] = data.toJson();
    return _data;
  }
}

class Data {
  Data({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.password,
    required this.registrationDate,
    required this.v,
  });

  late final String id;
  late final String fullName;
  late final String email;
  late final String phoneNumber;
  late final String password;
  late final String registrationDate;
  late final int v;

  Data.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    fullName = json['FullName'];
    email = json['Email'];
    phoneNumber = json['PhoneNumber'];
    password = json['Password'];
    registrationDate = json['RegistrationDate'];
    v = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['_id'] = id;
    _data['FullName'] = fullName;
    _data['Email'] = email;
    _data['PhoneNumber'] = phoneNumber;
    _data['Password'] = password;
    _data['RegistrationDate'] = registrationDate;
    _data['__v'] = v;
    return _data;
  }
}
