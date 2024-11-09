import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:pet_shop/config/cofig.dart';

class PredictService {
  var client = http.Client();
  var url = Uri.https(Config.apiURL, Config.predict);

  Future<dynamic> predict(Uint8List bytes, String fileName) async {
    var request = http.MultipartRequest("POST", url);
    var myFile = http.MultipartFile(
      "file",
      http.ByteStream.fromBytes(bytes),
      bytes.length,
      filename: fileName,
    );
    request.files.add(myFile);
    final respones = await request.send();
    var data = await respones.stream.bytesToString();
    return data;
  }

  Future<dynamic> getById() async {
    return;
  }
}
