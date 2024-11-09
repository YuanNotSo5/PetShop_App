import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pet_shop/models/Address/address.dart';

class TransformCustomApp {
  String formatCurrency(int amount) {
    final format = NumberFormat.simpleCurrency(locale: 'vi_VN', name: 'VND');
    return format.format(amount);
  }

  String formateDateTime(DateTime datetime) {
    String formattedDate = DateFormat('hh:mm, dd/MM/yyyy').format(datetime);
    return formattedDate;
  }

  String formatAddress(String addressOff) {
    try {
      List<String> listAddress = addressOff.split("-");
      String cityString = listAddress[0];
      String districtString = listAddress[1];
      String wardString = listAddress[2];
      String address = listAddress[3];

      String cleanedString = cityString.replaceAll(RegExp(r'^\{|\}$'), '');
      String cleanedStringDis =
          districtString.replaceAll(RegExp(r'^\{|\}$'), '');
      String cleanedStringWard = wardString.replaceAll(RegExp(r'^\{|\}$'), '');

      //todo City
      List<String> ele = cleanedString.split(":");
      String jsonString =
          '{"${ele[2]}": "${ele[3].trim()}", "${ele[0]}":  ${ele[1]}}';
      Map<String, dynamic> userMap = jsonDecode(jsonString);
      City city = City.fromJson(userMap);

      // //todo District
      List<String> dis = cleanedStringDis.split(":");
      String jsonStringDis =
          '{"${dis[2]}": "${dis[3].trim()}", "${dis[0]}":  ${dis[1]}}';
      Map<String, dynamic> disjson = jsonDecode(jsonStringDis);
      District district = District.fromJson(disjson);

      // //todo Ward
      List<String> ward = cleanedStringWard.split(":");
      String jsonStringWard =
          '{"${ward[2]}": "${ward[3].trim()}", "${ward[0]}":  "${ward[1]}"}';
      Map<String, dynamic> wardjson = jsonDecode(jsonStringWard);
      Ward wardObject = Ward.fromJson(wardjson);
      return "${address}, ${wardObject.WardName}, ${district.DistrictName}, ${city.ProvinceName}";
    } catch (e) {
      return addressOff;
    }
  }

  Object getCodeForDeliveryFee(String addressOff) {
    try {
      List<String> listAddress = addressOff.split("-");
      String districtString = listAddress[1];
      String wardString = listAddress[2];

      String cleanedStringDis =
          districtString.replaceAll(RegExp(r'^\{|\}$'), '');
      String cleanedStringWard = wardString.replaceAll(RegExp(r'^\{|\}$'), '');

      // //todo District
      List<String> dis = cleanedStringDis.split(":");
      String jsonStringDis =
          '{"${dis[2]}": "${dis[3].trim()}", "${dis[0]}":  ${dis[1]}}';
      Map<String, dynamic> disjson = jsonDecode(jsonStringDis);
      District district = District.fromJson(disjson);

      // //todo Ward
      List<String> ward = cleanedStringWard.split(":");
      String jsonStringWard =
          '{"${ward[2]}": "${ward[3].trim()}", "${ward[0]}":  "${ward[1]}"}';
      Map<String, dynamic> wardjson = jsonDecode(jsonStringWard);
      Ward wardObject = Ward.fromJson(wardjson);

      return {
        'toDistrictId': district.DistrictID.toInt(),
        'to_ward_code': wardObject.WardCode.toString()
      };
    } catch (e) {
      return {'toDistrictId': null, 'to_ward_code': null};
    }
  }
}
