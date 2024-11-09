import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:pet_shop/models/Product/product.dart';
import 'package:pet_shop/screen/Home/components/selection_component/selection_title.dart';
import 'package:pet_shop/screen/Product/components/product_showing_grid.dart';
import 'package:readmore/readmore.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class DogDetailsPage extends StatefulWidget {
  final String name;
  final String imgPath;
  final List<Product> listProducts;
  const DogDetailsPage(
      {super.key,
      required this.name,
      required this.imgPath,
      required this.listProducts});

  @override
  State<DogDetailsPage> createState() => _DogDetailsPageState();
}

class _DogDetailsPageState extends State<DogDetailsPage> {
  String? userId;

  final TextStyle titleTextStyle = const TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 20,
      color: Color.fromRGBO(82, 60, 154, 1));

  final TextStyle viewAllTextStyle = const TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 20,
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 300,
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          height: 300,
                          width: MediaQuery.of(context).size.width,
                          color: Colors.lightBlue,
                          alignment: Alignment.center,
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 30),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border:
                                    Border.all(color: Colors.white, width: 1),
                              ),
                              child: CircleAvatar(
                                radius: 80,
                                backgroundImage: AssetImage(widget.imgPath ??
                                    'assets/images/_project/Account/black_dog.png'),
                              ),
                            ),
                            Text(widget.name,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 30,
                                    color: Color.fromRGBO(82, 60, 154, 1))),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: HtmlWidget(
                          "widget.product.description",
                          customWidgetBuilder: (element) {
                            return ReadMoreText(
                              element.text,
                              trimLines: 5,
                              colorClickableText: Colors.pink,
                              trimMode: TrimMode.Line,
                              trimCollapsedText: '\n Xem thêm',
                              trimExpandedText: '\n Thu nhỏ',
                              moreStyle: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white,
                  ),
                  child: Column(
                    children: [
                      Obx(() {
                        if (widget.listProducts.isNotEmpty) {
                          return ProductShowingGrid(
                              productList: widget.listProducts);
                        } else {
                          return Container(
                            height: 50,
                            child: Center(
                              child: Text("Chưa tìm được sản phẩm phù hợp"),
                            ),
                          );
                        }
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
