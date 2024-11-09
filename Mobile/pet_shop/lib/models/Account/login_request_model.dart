class LoginRequestModel {
  LoginRequestModel({
    required this.Email,
    required this.Password,
  });
  late final String Email;
  late final String Password;

  LoginRequestModel.fromJson(Map<String, dynamic> json) {
    Email = json['Email'];
    Password = json['Password'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['Email'] = Email;
    _data['Password'] = Password;
    return _data;
  }
}
