import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:pet_shop/config/cofig.dart';
import 'package:pet_shop/models/ModelPredict/model_product.dart';

class Model extends StatefulWidget {
  @override
  _ModelState createState() => _ModelState();
}

class _ModelState extends State<Model> {
  String isImageUploaded = "";
  bool isLoading = false;

  final ImagePicker picker = ImagePicker();

  Future<void> predictImage(Uint8List bytes, String fileName) async {
    print("Predicting image: $fileName");
    var predictionResult = await UploadApiImage().uploadImage(bytes, fileName);
    if (predictionResult != null) {
      setState(() {
        // Update UI with prediction result if needed
        print("Prediction result: $predictionResult");
        Navigator.of(context).pushReplacementNamed('/');
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      print("Failed to predict image.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  isImageUploaded == ""
                      ? const SizedBox()
                      : SizedBox(
                          height: 350,
                          width: 350,
                          child: Image.network(
                            isImageUploaded,
                          ),
                        ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent),
                    onPressed: () async {
                      final XFile? image =
                          await picker.pickImage(source: ImageSource.camera);
                      if (image != null) {
                        setState(() {
                          isLoading = true;
                        });
                        Uint8List bytes = await image.readAsBytes();
                        await predictImage(bytes, image.name);
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        "Take Photo from Camera",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent),
                    onPressed: () async {
                      final XFile? image =
                          await picker.pickImage(source: ImageSource.gallery);
                      if (image != null) {
                        setState(() {
                          isLoading = true;
                        });
                        Uint8List bytes = await image.readAsBytes();
                        await predictImage(bytes, image.name);
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        "Pick Image from Gallery",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class UploadApiImage {
  var client = http.Client();
  var url = Uri.http(Config.apiURL, Config.predict);
  RxList<ModelProduct> predList = List<ModelProduct>.empty(growable: true).obs;

  Future<dynamic> uploadImage(Uint8List bytes, String fileName) async {
    // Uri url = Uri.parse("http://192.168.1.191:3000/aa");
    Uri url = Uri.parse("http://192.168.1.191:3100/api/recognize/predict");
    var request = http.MultipartRequest("POST", url);
    var myFile = http.MultipartFile(
      "file",
      http.ByteStream.fromBytes(bytes),
      bytes.length,
      filename: fileName,
    );
    request.files.add(myFile);
    try {
      final respones = await request.send();
      if (respones.statusCode == 201) {
        var data = await respones.stream.bytesToString();
        print(data);
        // predList.assignAll(predListFromJson(data));

        return jsonDecode(data);
      }
    } catch (e) {
      return null;
    } finally {
      // for (var i = 0; i < predList.length; i++) {
      //   print("aaaaaa ${predList[i].probability}");
      // }
      print("wwwwwwwwww ${predList.length}");
    }
  }
}
