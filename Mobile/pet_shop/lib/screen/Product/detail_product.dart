import 'dart:io';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:oktoast/oktoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pet_shop/config/cofig.dart';
import 'package:pet_shop/config/validators/transform.dart';
import 'package:pet_shop/screen/Home/components/selection_component/selection_title.dart';
import 'package:pet_shop/screen/Product/components/product_showing_grid.dart';
import 'package:readmore/readmore.dart';
import 'package:fan_carousel_image_slider/fan_carousel_image_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:pet_shop/components/Header/header_appbar.dart';
import 'package:pet_shop/screen/Product/product_detail_popup.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

import 'package:pet_shop/config/constant.dart';
import 'package:pet_shop/controllers/Account/auth_controller.dart';
import 'package:pet_shop/controllers/Product/product_controller.dart';
import 'package:pet_shop/models/Product/product.dart';
import 'package:pet_shop/route/route_generator.dart';
import 'package:pet_shop/screen/Product/Review/product_review_screen.dart';
import 'package:pet_shop/screen/Product/components/product_info_column.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailProduct extends StatefulWidget {
  final Product? product;
  final String idProduct;

  const DetailProduct({Key? key, this.product, required this.idProduct})
      : super(key: key);

  @override
  _DetailProductState createState() => _DetailProductState();
}

class _DetailProductState extends State<DetailProduct> {
  ProductController proController = Get.find<ProductController>();
  bool isFavorite = false;
  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    await proController.getFavOfProduct(widget.idProduct);
    var isSuccess = await proController.getProductById(widget.idProduct);
    await proController.getRecommendProduct(widget.idProduct);
    await proController.getProductReview(widget.idProduct);
    if (isSuccess) {}
  }

  Future<void> handleRefresh() async {
    var isSuccess = await proController.getProductById(widget.idProduct);
    if (isSuccess) {}
  }

  @override
  void dispose() {
    super.dispose();
    proController.product.value = null;
  }

  String phoneNumber = "0901807173";
  String url = Config.url;

  @override
  Widget build(BuildContext context) {
    int initialPageIndex = 0;
    initialPageIndex =
        initialPageIndex.clamp(0, widget.product!.slide.length - 1);
    return Scaffold(
      appBar: Header_Appbar(
        context: context,
        name: "",
        isShowingCart: true,
      ),
      backgroundColor: CustomAppColor.lightBackgroundColor_Home,
      body: RefreshIndicator(
        onRefresh: () async {
          handleRefresh();
        },
        child: Stack(
          children: [
            SingleChildScrollView(
              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Obx(() {
                        final product = proController.product.value;

                        return SizedBox(
                          height: 350,
                          width: MediaQuery.of(context).size.width,
                          child: FanCarouselImageSlider.sliderType1(
                            sliderHeight: 250,
                            autoPlay: true,
                            // Nếu product từ controller là null, sử dụng slide của widget.product
                            imagesLink: product?.slide ?? widget.product!.slide,
                            isAssets: false,
                            initalPageIndex: initialPageIndex,
                          ),
                        );
                      }),
                      // !!!!!!!!!!!!!!!!!!!!!!!!!!!!
                      Container(
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.white,
                        ),
                        child: Column(children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Obx(() {
                                final product = proController.product.value;

                                return Container(
                                  width:
                                      MediaQuery.of(context).size.width / 1.2,
                                  child: Text(
                                    product?.name ?? widget.product!.name,
                                    softWrap: true,
                                    style: TextStyle(
                                        color: Colors.black87,
                                        fontWeight: FontWeight.w900,
                                        fontSize: 18),
                                  ),
                                );
                              })
                            ],
                          ),
                          SizedBox(height: 5),
                          Obx(
                            () {
                              final product = proController.product.value;

                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Số lượng: (${product?.quantity ?? widget.product!.quantity})",
                                    style: TextStyle(
                                      color: Colors.black45,
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    "${TransformCustomApp().formatCurrency(product?.promotion.toInt() ?? widget.product!.promotion.toInt())}",
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                          SizedBox(height: 5),
                          Container(
                              width: MediaQuery.of(context).size.width - 50,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                        shape: WidgetStatePropertyAll(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                        backgroundColor: WidgetStatePropertyAll(
                                            Colors.yellow[300]),
                                        padding: WidgetStatePropertyAll(
                                          EdgeInsetsDirectional.all(10),
                                        ),
                                      ),
                                      onPressed: () {},
                                      child: Obx(() {
                                        final product =
                                            proController.product.value;

                                        return Text(
                                          product?.category.name ??
                                              widget.product!.category.name,
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.pink,
                                              fontWeight: FontWeight.w500),
                                        );
                                      }),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Obx(
                                        () {
                                          bool isFavorite = ProductController
                                              .instance.isFav.value;
                                          return _buildActionIcon(
                                            isFavorite
                                                ? Icons.favorite
                                                : Icons.favorite_border,
                                            isFavorite
                                                ? Color(0xFFDB3022)
                                                : Colors.grey,
                                            () {
                                              if (AuthController
                                                      .instance.isLogin ==
                                                  false) {
                                                Navigator.of(context)
                                                    .pushNamed(Routes.sign_in);
                                              } else {
                                                ProductController.instance
                                                    .updateFavOfProduct(
                                                        widget.product!.id);
                                              }
                                            },
                                            BorderRadius.circular(10),
                                          );
                                        },
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          checkpermission_call(phoneNumber);
                                        },
                                        child: Container(
                                          margin: EdgeInsets.only(left: 7),
                                          height: 50,
                                          width: 50,
                                          decoration: BoxDecoration(
                                            color: Color(0x1F989797),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Center(
                                            child: Icon(
                                              Icons.call,
                                              color: Color(0xFFDB3022),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              )),
                        ]),
                      ),
                      // !!!!!!!!!!!!!!!!!!!
                      Row(
                        children: [
                          Text(
                            '',
                            style: TextStyle(
                                color: Colors.black54,
                                fontWeight: FontWeight.w500,
                                fontSize: 14),
                          ),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.white,
                        ),
                        child: Column(children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "Các thành phần",
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 13,
                              ),
                            ),
                          ),
                          Obx(() {
                            final product = proController.product.value;
                            return Container(
                              child: Wrap(
                                spacing: 15.0,
                                runSpacing: 15.0,
                                children: List.generate(
                                    product?.color.length ??
                                        widget.product!.color.length, (index) {
                                  return Container(
                                    child: InfoColumn(
                                      value: product?.color[index] ??
                                          widget.product!.color[index],
                                      color: Colors.yellow,
                                    ),
                                  );
                                }),
                              ),
                            );
                          }),
                          Row(
                            children: [
                              ElevatedButton.icon(
                                onPressed: () {
                                  // Handle button press
                                },
                                iconAlignment: IconAlignment.end,
                                icon: Icon(Icons.check, color: Colors.white),
                                label: Text('Đã kiểm duyệt',
                                    style: TextStyle(color: Colors.white)),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors
                                      .green, // Set the button background color
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        20), // Rounded corners
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Obx(() {
                                final product = proController.product.value;
                                return HtmlWidget(
                                  product?.description ??
                                      widget.product!.description,
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
                                );
                              })),
                        ]),
                      ),

                      //todo [Rating Star]
                      SizedBox(height: 20),
                      Obx(() {
                        if (ProductController.instance.reviewList.isNotEmpty) {
                          return Review_Product(
                            reviewList: ProductController.instance.reviewList,
                          );
                        } else {
                          return Review_Product(
                            reviewList: [],
                          );
                        }
                      }),
                      // //todo [Recommend]
                      SizedBox(height: 20),
                      Container(
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.white,
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Text(
                                      "Sản phẩm liên quan",
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Obx(() {
                              final products =
                                  ProductController.instance.productRecommended;
                              print(
                                  'Products: ${products.length}'); // Debug print
                              if (products.isNotEmpty) {
                                return ProductShowingGrid(
                                    productList: products);
                              } else {
                                return Container(
                                  height: 50,
                                  child: Center(
                                    child:
                                        Text("Chưa tìm được sản phẩm phù hợp"),
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
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(8),
        color: Colors.white,
        child: Obx(() {
          final product = proController.product.value;
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: ProductDetailPopup(
                  productId: product?.id ?? widget.product!.id,
                  price: product?.promotion ?? widget.product!.promotion,
                  quantity: product?.quantity ?? widget.product!.quantity,
                  productImg: product?.image ?? widget.product!.image,
                  productName: product?.name ?? widget.product!.name,
                ),
              ),
              SizedBox(width: 6),
              GestureDetector(
                onTap: () {
                  handleShareInfo(
                    url,
                    product?.image ?? widget.product!.image,
                    product?.name ?? widget.product!.name,
                  );
                },
                child: Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    color: Color(0x1F989797),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.share,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildActionIcon(
      IconData icon, Color color, VoidCallback onPressed, BorderRadius border) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: EdgeInsets.only(left: 10),
        height: 50,
        width: 50,
        decoration:
            BoxDecoration(color: Color(0x1F989797), borderRadius: border),
        child: Center(
          child: Icon(
            icon,
            color: color,
          ),
        ),
      ),
    );
  }

  //todo [Handle Phone Call]
  checkpermission_call(String number) async {
    var phoneStatus = await Permission.phone.status;
    if (!phoneStatus.isGranted) await Permission.phone.request();
    if (await Permission.phone.isGranted) {
      makeACallToShop(number);
    } else {
      showToast(
        "Bạn chưa cấp quyền để thực hiện việc gọi",
        position: ToastPosition.bottom,
      );
    }
  }

  void makeACallToShop(String number) async {
    Uri dialNumber = Uri(scheme: 'tel', path: number);
    await launchUrl(dialNumber);
  }

  //todo [Handle Share]
  void handleShareInfo(String url, String img, String title) async {
    final urlImag = Uri.parse(img);
    final response = await http.get(urlImag);
    final bytes = response.bodyBytes;

    final temp = await getTemporaryDirectory();
    final path = "${temp.path}/image.jpg";
    File(path).writeAsBytesSync(bytes);
    await Share.shareXFiles([XFile(path)], text: "${title} tại ${url}");
  }
}

class DetailProductArguments {
  final String idProduct;
  final Product? product;

  DetailProductArguments({required this.idProduct, this.product});
}
