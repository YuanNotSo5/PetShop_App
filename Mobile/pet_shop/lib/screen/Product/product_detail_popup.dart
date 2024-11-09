import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:pet_shop/config/secure_storage/security_storage.dart';
import 'package:pet_shop/config/validators/transform.dart';
import 'package:pet_shop/controllers/Product/cart_controller.dart';
import 'package:pet_shop/components/container_button_model.dart';
import 'package:pet_shop/config/constant.dart';
import 'package:pet_shop/route/route_generator.dart';

class ProductDetailPopup extends StatefulWidget {
  final int quantity;
  final double price;
  final String productId;
  final String productImg;
  final String productName;

  const ProductDetailPopup({
    Key? key,
    required this.quantity,
    required this.price,
    required this.productId,
    required this.productImg,
    required this.productName,
  }) : super(key: key);

  @override
  _ProductDetailPopupState createState() => _ProductDetailPopupState();
}

class _ProductDetailPopupState extends State<ProductDetailPopup> {
  late ValueNotifier<int> _quantityNotifier;
  String selectedAge = "6 month";

  @override
  void initState() {
    super.initState();
    _quantityNotifier = ValueNotifier<int>(1);
  }

  @override
  Widget build(BuildContext context) {
    final iStyle = TextStyle(
      color: Colors.black87,
      fontWeight: FontWeight.w600,
      fontSize: 18,
    );

    List<Color> colors = [
      Colors.red,
      Colors.green,
      Colors.indigo,
      Colors.amber
    ];

    return Expanded(
      child: InkWell(
        onTap: () async {
          if (widget.quantity > 0) {
            if (await SecurityStorage().readSecureData("token")) {
              showModalBottomSheet(
                backgroundColor: Colors.transparent,
                context: context,
                builder: (context) => Container(
                  height: MediaQuery.of(context).size.height / 2.3,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(30),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            Row(
                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                //todo [Image]
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: Colors.grey,
                                      width: 0.5,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 5,
                                        offset: Offset(0, 5),
                                      ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      widget.productImg,
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),

                                //todo [Name and Price]
                                Expanded(
                                  child: Container(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          widget.productName,
                                          softWrap: true,
                                          style: TextStyle(
                                            color: Colors.black87,
                                            fontWeight: FontWeight.w900,
                                            fontSize: 12,
                                          ),
                                        ),
                                        ValueListenableBuilder<int>(
                                          valueListenable: _quantityNotifier,
                                          builder: (context, value, _) {
                                            return Text(
                                              "${TransformCustomApp().formatCurrency((value * widget.price).toInt())}",
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFFDB3022),
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),

                            //todo [Options]
                            // _buildSelectionRow(
                            //   "Age",
                            //   ["6 month", "12 month"],
                            //   selectedAge,
                            //   (value) {
                            //     setState(() {
                            //       selectedAge = value;
                            //     });
                            //   },
                            // ),

                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Số Lượng:",
                                      style: TextStyle(
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        IconButton(
                                          style: ButtonStyle(
                                            shape: MaterialStatePropertyAll(
                                              RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                side: BorderSide(
                                                    color: Colors.grey),
                                              ),
                                            ),
                                            backgroundColor:
                                                MaterialStatePropertyAll(
                                                    Colors.white),
                                          ),
                                          icon: Icon(
                                            CupertinoIcons.minus,
                                            color: Colors.grey,
                                          ),
                                          onPressed: () {
                                            if (_quantityNotifier.value > 1) {
                                              _quantityNotifier.value--;
                                            }
                                          },
                                        ),
                                        SizedBox(width: 5),
                                        // Sử dụng Container để cố định độ rộng của text
                                        Container(
                                          width:
                                              50, // Đặt chiều rộng cố định cho số lượng
                                          alignment: Alignment
                                              .center, // Đảm bảo số lượng nằm giữa
                                          child: ValueListenableBuilder<int>(
                                            valueListenable: _quantityNotifier,
                                            builder: (context, value, _) {
                                              return Text(
                                                "$value",
                                                style: iStyle,
                                              );
                                            },
                                          ),
                                        ),
                                        SizedBox(width: 5),
                                        IconButton(
                                          style: ButtonStyle(
                                            shape: MaterialStatePropertyAll(
                                              RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                side: BorderSide(
                                                    color: Colors.grey),
                                              ),
                                            ),
                                            backgroundColor:
                                                MaterialStatePropertyAll(
                                                    Colors.white),
                                          ),
                                          icon: Icon(
                                            CupertinoIcons.add,
                                            color: Colors.grey,
                                          ),
                                          onPressed: () {
                                            if (_quantityNotifier.value <
                                                widget.quantity) {
                                              _quantityNotifier.value++;
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  CartController.instance.addToCart(
                                      widget.productId,
                                      _quantityNotifier.value,
                                      // _quantityNotifier.value * widget.price);
                                      widget.price);

                                  _quantityNotifier.value = 1;

                                  Navigator.pop(context);
                                },
                                child: ContainerButtonModel(
                                  containerWidth:
                                      MediaQuery.of(context).size.width,
                                  itext: "Thêm Vào Giỏ Hàng",
                                  bgColor: CustomAppColor.primaryColorOrange,
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              );
            } else {
              Navigator.of(context).pushNamed(Routes.sign_in);
            }
          }
        },
        child: ContainerButtonModel(
          containerWidth: MediaQuery.of(context).size.width / 1.27,
          itext: "Mua Ngay",
          bgColor: widget.quantity > 0
              ? CustomAppColor.primaryColorOrange
              : CustomAppColor.lightAccentColor,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _quantityNotifier.dispose();
    super.dispose();
  }
}

Widget _buildSelectionRow(String title, List<String> options,
    String selectedValue, ValueChanged<String> onSelected) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: options.map((option) {
          final isSelected = selectedValue == option;
          return InkWell(
            onTap: () {
              onSelected(option);
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              margin: EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color:
                    isSelected ? Colors.green.shade100 : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isSelected ? Colors.green : Colors.grey,
                ),
              ),
              child: Text(option,
                  style: TextStyle(
                      color: isSelected ? Colors.green : Colors.black)),
            ),
          );
        }).toList(),
      ),
    ],
  );
}
