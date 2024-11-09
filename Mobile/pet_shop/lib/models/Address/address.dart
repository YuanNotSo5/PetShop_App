import 'dart:convert';

List<City> cityFromListJson(Map<String, dynamic> data) {
  final docs = data['data'] as List<dynamic>;
  return List<City>.from(docs.map((city) => City.fromJson(city)));
}

List<District> districtFromListJson(Map<String, dynamic> data) {
  final docs = data['data'] as List<dynamic>;
  return List<District>.from(docs.map((city) => District.fromJson(city)));
}

List<Ward> wardFromListJson(Map<String, dynamic> data) {
  final docs = data['data'] as List<dynamic>;
  return List<Ward>.from(docs.map((city) => Ward.fromJson(city)));
}

//todo [City]
class City {
  final int ProvinceID;
  final String ProvinceName;

  factory City.fromJson(Map<String, dynamic> data) {
    return City(
      ProvinceID: data['ProvinceID'] as int,
      ProvinceName: data['ProvinceName'] as String,
    );
  }

  City({
    required this.ProvinceID,
    required this.ProvinceName,
  });
  @override
  String toString() {
    return '{ProvinceID:$ProvinceID:ProvinceName:$ProvinceName}';
  }
}

//todo [District]
class District {
  final int DistrictID;
  final String DistrictName;

  factory District.fromJson(Map<String, dynamic> data) {
    return District(
      DistrictID: data['DistrictID'] as int,
      DistrictName: data['DistrictName'] as String,
    );
  }

  District({
    required this.DistrictID,
    required this.DistrictName,
  });

  @override
  String toString() {
    return '{DistrictID:$DistrictID:DistrictName:$DistrictName}';
  }
}

//todo [Ward]
class Ward {
  final String WardCode;
  final String WardName;

  factory Ward.fromJson(Map<String, dynamic> data) {
    return Ward(
      WardCode: data['WardCode'] as String,
      WardName: data['WardName'] as String,
    );
  }

  Ward({
    required this.WardCode,
    required this.WardName,
  });

  @override
  String toString() {
    return '{WardCode:$WardCode:WardName:$WardName}';
  }
}
