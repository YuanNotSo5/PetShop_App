import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pet_shop/config/constant.dart';
import 'package:pet_shop/controllers/Home/home_controller.dart';
import 'package:pet_shop/controllers/Predict/predict_controller.dart';
import 'package:pet_shop/models/ModelPredict/model_product.dart';
import 'package:pet_shop/models/Product/product.dart';
import 'package:pet_shop/route/route_generator.dart';
import 'package:pet_shop/screen/Home/components/selection_component/selection_title.dart';
import 'package:pet_shop/servies/ModelPredict/predict_service.dart';

class ListPredict extends StatefulWidget {
  final XFile image;
  const ListPredict({Key? key, required this.image}) : super(key: key);

  @override
  _ListPredictState createState() => _ListPredictState();
}

class _ListPredictState extends State<ListPredict> {
  List<ModelProduct>? predList;
  bool isLoading = true;
  PredictController predictController = Get.find<PredictController>();
  HomeController homeController = Get.find<HomeController>();

  final Map<String, String> breedImages = {
    "beagle": "assets/images/_project/Predict/beagle.jpg",
    "bull_mastiff": "assets/images/_project/Predict/bull_mastiff.jpg",
    "chihuahua": "assets/images/_project/Predict/chihuahua.jpg",
    "dandie_dinmont": "assets/images/_project/Predict/dandie_dinmont.jpg",
    "doberman": "assets/images/_project/Predict/doberman.jpg",
    "eskimo_dog": "assets/images/_project/Predict/eskimo_dog.jpg",
    "golden_retriever": "assets/images/_project/Predict/golden_retriever.jpg",
    "irish_terrier": "assets/images/_project/Predict/irish_terrier.jpg",
    "labrador_retriever":
        "assets/images/_project/Predict/labrador_retriever.jpg",
    "malamute": "assets/images/_project/Predict/malamute.jpg",
    "malinois": "assets/images/_project/Predict/malinois.jpg",
    "maltese_dog": "assets/images/_project/Predict/maltese_dog.jpg",
    "miniature_pinscher":
        "assets/images/_project/Predict/miniature_pinscher.jpg",
    "miniature_poodle": "assets/images/_project/Predict/miniature_poodle.jpg",
    "norfolk_terrier": "assets/images/_project/Predict/norfolk_terrier.jpg",
    "pembroke": "assets/images/_project/Predict/pembroke.jpg",
    "pomeranian": "assets/images/_project/Predict/pomeranian.jpg",
    "pug": "assets/images/_project/Predict/pug.jpg",
    "siberian_husky": "assets/images/_project/Predict/siberian_husky.jpg",
    "staffordshire_bullterrier":
        "assets/images/_project/Predict/staffordshire_bullterrier.jpg",
    "toy_poodle": "assets/images/_project/Predict/toy_poodle.jpg",
    "yorkshire_terrier": "assets/images/_project/Predict/yorkshire_terrier.jpg",
  };

  @override
  void initState() {
    super.initState();
    fetchPrediction();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    homeController.getData();
    super.dispose();
  }

  void fetchPrediction() async {
    Uint8List bytes = await widget.image.readAsBytes();
    var res = await PredictService().predict(bytes, widget.image.name);
    setState(() {
      predList = predListFromJson(res);
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomAppColor.lightBackgroundColor_Home,
      appBar: AppBar(
        title: Text('Kết quả dự đoán'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : predList == null || predList!.isEmpty
              ? Center(child: Text('Không thể tìm thấy giống chó phù hợp'))
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Dựa trên thông tin được cung cấp\nĐây là những giống chó có khả năng tương thích với bạn',
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: predList!.length,
                        itemBuilder: (context, index) {
                          String breed = predList![index]
                              .label
                              .toLowerCase()
                              .replaceAll(' ', '_')
                              .trim();
                          return itemCard(breed);
                        },
                      ),
                    ),
                  ],
                ),
    );
  }

  GestureDetector itemCard(String breed) {
    String? imagePath = breedImages[breed];
    return GestureDetector(
      onTap: () async {
        var isSuccess = await predictController.getProductsBySlug(breed);
        var isGet = await predictController.getIdBySlug(breed);
        if (await isSuccess && await isGet) {
          Navigator.of(context).pushNamed(
            Routes.product_category,
            arguments: SelectionTitleArguments(
              idCate: predictController.idCatefory.value,
              name: 'Sản phẩm dịch vụ của $breed',
              productList: predictController.productList,
            ),
          );
        }
      },
      child: Container(
        width: 350,
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 3),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 5,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                imagePath ?? "assets/images/_project/Account/black_dog.png",
                width: 120,
                height: 120,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    breed
                        .split('_')
                        .map(
                            (word) => word[0].toUpperCase() + word.substring(1))
                        .join(' '),
                    style: TextStyle(fontSize: 18, color: Colors.black),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DogDetailsArguments {
  final String name;
  final String imgPath;
  final List<Product> listProducts;
  DogDetailsArguments(
      {required this.name, required this.imgPath, required this.listProducts});
}
