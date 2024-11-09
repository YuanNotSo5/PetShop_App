import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:pet_shop/components/container_button_model.dart';
import 'package:pet_shop/config/validators/transform.dart';
import 'package:pet_shop/controllers/Home/home_controller.dart';
import 'package:pet_shop/controllers/Product/cart_controller.dart';
import 'package:pet_shop/models/Order/product_order.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pet_shop/route/route_generator.dart';
import 'package:readmore/readmore.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<ProductOrder> items = [];
  HomeController homeController = Get.find<HomeController>();
  @override
  void initState() {
    super.initState();
    CartController.instance.getCartList();
  }

  @override
  void dispose() async {
    await homeController.getData();
    super.dispose();
  }

  double getTotal(List<ProductOrder> cartItems) {
    double total = 0;
    for (var cartItem in cartItems) {
      if (cartItem.selected) {
        total += cartItem.quantity * cartItem.product.promotion;
      }
    }
    return total;
  }

  void checkout() {
    List<ProductOrder> selectedItems =
        items.where((item) => item.selected).toList();

    if (selectedItems.isEmpty) {
      Fluttertoast.showToast(
        msg: "Vui lòng chọn sản phẩm bạn muốn mua",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return;
    }

    Navigator.of(context)
        .pushNamed(Routes.order_sumary, arguments: selectedItems);
  }

  @override
  Widget build(BuildContext context) {
    final CartController cartController = Get.find();

    return WillPopScope(
      onWillPop: () async {
        homeController.getData();
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("Giỏ hàng"),
          leading: BackButton(),
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.black,
          elevation: 0,
          centerTitle: true,
        ),
        body: Obx(() {
          // if (cartController.isCartLoading.value) {
          //   return Center(child: CircularProgressIndicator());
          // }
          items = cartController.itemCartList;

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return Slidable(
                      // direction: Axis.horizontal,
                      key: ValueKey(
                          items[index].id), // Use id instead of product.id
                      startActionPane: ActionPane(
                        motion: ScrollMotion(),
                        children: [
                          SlidableAction(
                            onPressed: (context) {
                              setState(() {
                                CartController.instance
                                    .removeItem(items[index].product.id);
                                items.removeAt(index);
                              });
                            },
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            icon: Icons.delete,
                            label: 'Delete',
                          ),
                        ],
                      ),
                      endActionPane: ActionPane(
                        motion: ScrollMotion(),
                        children: [
                          SlidableAction(
                            onPressed: (context) {
                              setState(() {
                                CartController.instance
                                    .removeItem(items[index].product.id);
                                items.removeAt(index);
                              });
                            },
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            icon: Icons.delete,
                            label: 'Xóa',
                          ),
                        ],
                      ),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            items[index].selected = !items[index].selected;
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: Offset(0, 3),
                              ),
                            ],
                            border: Border.all(color: Colors.black26),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Checkbox(
                                    value: items[index].selected,
                                    onChanged: (val) {
                                      setState(() {
                                        items[index].selected = val!;
                                      });
                                    },
                                    splashRadius: 20,
                                    activeColor: Colors.orange,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      items[index].product.image,
                                      height: 150,
                                      width: 80,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 3,
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            items[index].product.name,
                                            style: TextStyle(
                                                color: Colors.black87,
                                                fontWeight: FontWeight.w900,
                                                fontSize: 15),
                                          ),
                                          SizedBox(height: 10),
                                          Text(
                                            "${TransformCustomApp().formatCurrency((items[index].quantity * items[index].product.promotion).toInt())}",
                                            style: TextStyle(
                                                color: Color(0xFFDB3022),
                                                fontSize: 15,
                                                fontWeight: FontWeight.w900),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  //todo [Minus Button]
                                  IconButton(
                                    style: ButtonStyle(
                                        shape: WidgetStatePropertyAll(
                                            CircleBorder(
                                                side: BorderSide(
                                                    color: Colors.green))),
                                        backgroundColor: WidgetStatePropertyAll(
                                            Colors.white)),
                                    icon: Icon(CupertinoIcons.minus,
                                        color: Colors.green),
                                    onPressed: () {
                                      CartController.instance.substractFromCart(
                                          items[index].product.id);
                                      setState(() {
                                        if (items[index].quantity > 1) {
                                          items[index].quantity--;
                                        }
                                      });
                                    },
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),

                                  //todo [Number Quantity]
                                  Text(
                                    "${items[index].quantity}",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),

                                  //todo [Plus Button]
                                  IconButton(
                                    style: ButtonStyle(
                                        shape: WidgetStatePropertyAll(
                                            CircleBorder(
                                                side: BorderSide(
                                                    color: Color(0xFFDB3022)))),
                                        backgroundColor: WidgetStatePropertyAll(
                                            Colors.white)),
                                    icon: Icon(CupertinoIcons.plus,
                                        color: Color(0xFFDB3022)),
                                    onPressed: () {
                                      CartController.instance.addOneToCart(
                                          items[index].product.id, 1, 1);
                                      setState(() {
                                        if (items[index].quantity <
                                            items[index].product.quantity) {
                                          items[index].quantity++;
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                  '${items[index].quantity} là sản phẩm tối đa còn lại'),
                                              duration: Duration(seconds: 2),
                                            ),
                                          );
                                        }
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Chọn tất cả",
                          style: TextStyle(fontSize: 16),
                        ),
                        Checkbox(
                          value: items.every((product) => product.selected),
                          onChanged: (val) {
                            setState(() {
                              for (var product in items) {
                                product.selected = val!;
                              }
                            });
                          },
                          splashRadius: 20,
                          activeColor: Colors.orange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ],
                    ),
                    Divider(
                      height: 20,
                      thickness: 1,
                      color: Colors.black,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Tổng tiền",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                        Text(
                          "${TransformCustomApp().formatCurrency(getTotal(items).toInt())}",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFFDB3022),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30),
                    InkWell(
                      onTap: checkout,
                      child: ContainerButtonModel(
                        itext: "Thanh Toán",
                        containerWidth: MediaQuery.of(context).size.width,
                        bgColor: Color(0xFFDB3022),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
