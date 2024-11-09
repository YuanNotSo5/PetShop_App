// import 'package:flutter/material.dart';
// import 'package:pet_shop/screen/CartAndPayment/cart_screen.dart';
// import 'package:pet_shop/components/container_button_model.dart';

// class ProductDetailPopup extends StatelessWidget {
//   // const ProductDetailPopup({Key? key}) : super(key: key);
//   final iStyle = TextStyle(
//       color: Colors.black87, fontWeight: FontWeight.w600, fontSize: 18);
//   List<Color> colors = [Colors.red, Colors.green, Colors.indigo, Colors.amber];
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: () {
//         showModalBottomSheet(
//             backgroundColor: Colors.transparent,
//             context: context,
//             builder: (context) => Container(
//                   height: MediaQuery.of(context).size.height / 2.5,
//                   decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.only(
//                           topLeft: Radius.circular(30),
//                           topRight: Radius.circular(30))),
//                   child: Padding(
//                     padding: EdgeInsets.all(30),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   "Size: ",
//                                   style: iStyle,
//                                 ),
//                                 SizedBox(
//                                   height: 20,
//                                 ),
//                                 Text(
//                                   "Color: ",
//                                   style: iStyle,
//                                 ),
//                                 SizedBox(
//                                   height: 20,
//                                 ),
//                                 Text(
//                                   "Total: ",
//                                   style: iStyle,
//                                 ),
//                                 SizedBox(
//                                   height: 20,
//                                 ),
//                               ],
//                             ),
//                             SizedBox(
//                               width: 30,
//                             ),
//                             Column(
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Row(
//                                   children: [
//                                     Row(
//                                       children: [
//                                         SizedBox(
//                                           width: 10,
//                                         ),
//                                         Text(
//                                           "1 kg",
//                                           style: iStyle,
//                                         ),
//                                         SizedBox(
//                                           width: 30,
//                                         ),
//                                         Text(
//                                           "10 kg",
//                                           style: iStyle,
//                                         ),
//                                         SizedBox(
//                                           width: 30,
//                                         ),
//                                         Text(
//                                           "20 kg",
//                                           style: iStyle,
//                                         ),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                                 SizedBox(
//                                   height: 20,
//                                 ),
//                                 Container(
//                                   child: Row(
//                                     children: [
//                                       for (var i = 0; i < 4; i++)
//                                         Container(
//                                           margin: EdgeInsets.symmetric(
//                                               horizontal: 6),
//                                           height: 28,
//                                           width: 28,
//                                           decoration: BoxDecoration(
//                                               color: colors[i],
//                                               borderRadius:
//                                                   BorderRadius.circular(20)),
//                                         )
//                                     ],
//                                   ),
//                                 ),
//                                 SizedBox(height: 20),
//                                 Row(
//                                   children: [
//                                     SizedBox(
//                                       width: 10,
//                                     ),
//                                     Text("-", style: iStyle),
//                                     SizedBox(
//                                       width: 30,
//                                     ),
//                                     Text(
//                                       "1",
//                                       style: iStyle,
//                                     ),
//                                     SizedBox(
//                                       width: 30,
//                                     ),
//                                     Text(
//                                       "+",
//                                       style: iStyle,
//                                     )
//                                   ],
//                                 )
//                               ],
//                             )
//                           ],
//                         ),
//                         SizedBox(
//                           height: 30,
//                         ),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               "Total Payment",
//                               style: iStyle,
//                             ),
//                             Text(
//                               "\$400",
//                               style: TextStyle(
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.bold,
//                                   color: Color(0xFFDB3022)),
//                             )
//                           ],
//                         ),
//                         SizedBox(
//                           height: 20,
//                         ),
//                         InkWell(
//                           onTap: () {
//                             Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) => CartScreen(),
//                                 ));
//                           },
//                           child: ContainerButtonModel(
//                             containerWidth: MediaQuery.of(context).size.width,
//                             itext: "Check out",
//                             bgColor: Color(0xFFDB3022),
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                 ));
//       },
//       child: ContainerButtonModel(
//         containerWidth: MediaQuery.of(context).size.width / 1.5,
//         itext: "Buy Now",
//         bgColor: Color(0xFFDB3022),
//       ),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:get/get.dart';
// import 'package:pet_shop/controllers/Product/cart_controller.dart';
// import 'package:pet_shop/components/container_button_model.dart';

// class ProductDetailPopup extends StatefulWidget {
//   final int quantity;
//   final double price;
//   final String productId;

//   const ProductDetailPopup({
//     Key? key,
//     required this.quantity,
//     required this.price,
//     required this.productId,
//   }) : super(key: key);

//   @override
//   _ProductDetailPopupState createState() => _ProductDetailPopupState();
// }

// class _ProductDetailPopupState extends State<ProductDetailPopup> {
//   late ValueNotifier<int> _quantityNotifier;

//   @override
//   void initState() {
//     super.initState();
//     _quantityNotifier = ValueNotifier<int>(1);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final iStyle = TextStyle(
//       color: Colors.black87,
//       fontWeight: FontWeight.w600,
//       fontSize: 18,
//     );

//     List<Color> colors = [
//       Colors.red,
//       Colors.green,
//       Colors.indigo,
//       Colors.amber
//     ];

//     return InkWell(
//       onTap: () {
//         showModalBottomSheet(
//           backgroundColor: Colors.transparent,
//           context: context,
//           builder: (context) => Container(
//             height: MediaQuery.of(context).size.height / 2.5,
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.only(
//                 topLeft: Radius.circular(30),
//                 topRight: Radius.circular(30),
//               ),
//             ),
//             child: Padding(
//               padding: EdgeInsets.all(30),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           // Text(
//                           //   "Size: ",
//                           //   style: iStyle,
//                           // ),
//                           // SizedBox(
//                           //   height: 20,
//                           // ),
//                           // Text(
//                           //   "Color: ",
//                           //   style: iStyle,
//                           // ),
//                           // SizedBox(
//                           //   height: 20,
//                           // ),
//                           Text(
//                             "Total: ",
//                             style: iStyle,
//                           ),
//                           SizedBox(
//                             height: 20,
//                           ),
//                         ],
//                       ),
//                       SizedBox(
//                         width: 30,
//                       ),
//                       Column(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           // Row(
//                           //   children: [
//                           //     InkWell(
//                           //       onTap: () {
//                           //         if (_quantityNotifier.value > 1) {
//                           //           _quantityNotifier.value--;
//                           //         }
//                           //       },
//                           //       child: Row(
//                           //         children: [
//                           //           SizedBox(
//                           //             width: 10,
//                           //           ),
//                           //           Text(
//                           //             "1 kg",
//                           //             style: iStyle,
//                           //           ),
//                           //           SizedBox(
//                           //             width: 30,
//                           //           ),
//                           //           Text(
//                           //             "10 kg",
//                           //             style: iStyle,
//                           //           ),
//                           //           SizedBox(
//                           //             width: 30,
//                           //           ),
//                           //           Text(
//                           //             "20 kg",
//                           //             style: iStyle,
//                           //           ),
//                           //         ],
//                           //       ),
//                           //     ),
//                           //   ],
//                           // ),
//                           // SizedBox(
//                           //   height: 20,
//                           // ),
//                           // Container(
//                           //   child: Row(
//                           //     children: [
//                           //       for (var i = 0; i < 4; i++)
//                           //         Container(
//                           //           margin: EdgeInsets.symmetric(horizontal: 6),
//                           //           height: 28,
//                           //           width: 28,
//                           //           decoration: BoxDecoration(
//                           //             color: colors[i],
//                           //             borderRadius: BorderRadius.circular(20),
//                           //           ),
//                           //         )
//                           //     ],
//                           //   ),
//                           // ),
//                           // SizedBox(height: 20),
//                           Row(
//                             children: [
//                               InkWell(
//                                 onTap: () {
//                                   if (_quantityNotifier.value > 1) {
//                                     _quantityNotifier.value--;
//                                   }
//                                 },
//                                 child: Text(
//                                   "-",
//                                   style: iStyle,
//                                 ),
//                               ),
//                               SizedBox(
//                                 width: 30,
//                               ),
//                               ValueListenableBuilder<int>(
//                                 valueListenable: _quantityNotifier,
//                                 builder: (context, value, _) {
//                                   return Text(
//                                     "$value",
//                                     style: iStyle,
//                                   );
//                                 },
//                               ),
//                               SizedBox(
//                                 width: 30,
//                               ),
//                               InkWell(
//                                 onTap: () {
//                                   if (_quantityNotifier.value <
//                                       widget.quantity) {
//                                     _quantityNotifier.value++;
//                                   }
//                                 },
//                                 child: Text(
//                                   "+",
//                                   style: iStyle,
//                                 ),
//                               ),
//                             ],
//                           )
//                         ],
//                       )
//                     ],
//                   ),
//                   SizedBox(
//                     height: 30,
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         "Total Payment",
//                         style: iStyle,
//                       ),
//                       ValueListenableBuilder<int>(
//                         valueListenable: _quantityNotifier,
//                         builder: (context, value, _) {
//                           return Text(
//                             "\$${value * widget.price}",
//                             style: TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold,
//                               color: Color(0xFFDB3022),
//                             ),
//                           );
//                         },
//                       ),
//                     ],
//                   ),
//                   SizedBox(
//                     height: 20,
//                   ),
//                   Obx(() {
//                     return InkWell(
//                       onTap: () {
//                         CartController.instance.addToCart(
//                             widget.productId,
//                             _quantityNotifier.value,
//                             _quantityNotifier.value * widget.price);

//                         Fluttertoast.showToast(
//                           msg:
//                               "Quantity: ${_quantityNotifier.value}\nTotal Price: \$${_quantityNotifier.value * widget.price}",
//                           toastLength: Toast.LENGTH_LONG,
//                           gravity: ToastGravity.BOTTOM,
//                           backgroundColor: Colors.black54,
//                           textColor: Colors.white,
//                           fontSize: 16.0,
//                         );

//                         // Set quantity back to 1
//                         _quantityNotifier.value = 1;

//                         // Close the bottom sheet
//                         Navigator.pop(context);
//                       },
//                       child: ContainerButtonModel(
//                         containerWidth: MediaQuery.of(context).size.width,
//                         itext: "Check out",
//                         bgColor: Color(0xFFDB3022),
//                       ),
//                     );
//                   })
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//       child: ContainerButtonModel(
//         containerWidth: MediaQuery.of(context).size.width / 1.5,
//         itext: "Buy Now",
//         bgColor: Color(0xFFDB3022),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _quantityNotifier.dispose();
//     super.dispose();
//   }
// }
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:pet_shop/config/secure_storage/security_storage.dart';
import 'package:pet_shop/controllers/Account/auth_controller.dart';
import 'package:pet_shop/controllers/Product/cart_controller.dart';
import 'package:pet_shop/components/container_button_model.dart';

class ProductDetailPopup extends StatefulWidget {
  final int quantity;
  final double price;
  final String productId;

  const ProductDetailPopup({
    Key? key,
    required this.quantity,
    required this.price,
    required this.productId,
  }) : super(key: key);

  @override
  _ProductDetailPopupState createState() => _ProductDetailPopupState();
}

class _ProductDetailPopupState extends State<ProductDetailPopup> {
  late ValueNotifier<int> _quantityNotifier;
  AuthController authorController = Get.find<AuthController>();
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

    return InkWell(
      onTap: () {
        showModalBottomSheet(
          backgroundColor: Colors.transparent,
          context: context,
          builder: (context) => Container(
            height: MediaQuery.of(context).size.height / 2.5,
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Total: ",
                            style: iStyle,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  if (_quantityNotifier.value > 1) {
                                    _quantityNotifier.value--;
                                  }
                                },
                                child: Text(
                                  "-",
                                  style: iStyle,
                                ),
                              ),
                              SizedBox(
                                width: 30,
                              ),
                              ValueListenableBuilder<int>(
                                valueListenable: _quantityNotifier,
                                builder: (context, value, _) {
                                  return Text(
                                    "$value",
                                    style: iStyle,
                                  );
                                },
                              ),
                              SizedBox(
                                width: 30,
                              ),
                              InkWell(
                                onTap: () {
                                  if (_quantityNotifier.value <
                                      widget.quantity) {
                                    _quantityNotifier.value++;
                                  }
                                },
                                child: Text(
                                  "+",
                                  style: iStyle,
                                ),
                              ),
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total Payment",
                        style: iStyle,
                      ),
                      ValueListenableBuilder<int>(
                        valueListenable: _quantityNotifier,
                        builder: (context, value, _) {
                          return Text(
                            "\$${value * widget.price}",
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
                  SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () {
                      CartController.instance.addToCart(
                          widget.productId,
                          _quantityNotifier.value,
                          _quantityNotifier.value * widget.price);

                      Fluttertoast.showToast(
                        msg:
                            "Quantity: ${_quantityNotifier.value}\nTotal Price: \$${_quantityNotifier.value * widget.price}",
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.BOTTOM,
                        backgroundColor: Colors.black54,
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );

                      // Set quantity back to 1
                      _quantityNotifier.value = 1;

                      // Close the bottom sheet
                      Navigator.pop(context);
                    },
                    child: ContainerButtonModel(
                      containerWidth: MediaQuery.of(context).size.width,
                      itext: "Check out",
                      bgColor: Color(0xFFDB3022),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      child: ContainerButtonModel(
        containerWidth: MediaQuery.of(context).size.width / 1.5,
        itext: "Buy Now",
        bgColor: Color(0xFFDB3022),
      ),
    );
  }

  @override
  void dispose() {
    _quantityNotifier.dispose();
    super.dispose();
  }
}
