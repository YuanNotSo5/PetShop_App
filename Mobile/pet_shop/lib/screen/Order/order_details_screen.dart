import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:pet_shop/config/constant.dart';
import 'package:pet_shop/config/secure_storage/security_storage.dart';
import 'package:pet_shop/config/validators/transform.dart';
import 'package:pet_shop/controllers/Home/home_controller.dart';
import 'package:pet_shop/controllers/Order/order_controller.dart';
import 'package:pet_shop/models/Order/order.dart';
import 'package:pet_shop/models/Order/product_order.dart';
import 'package:pet_shop/models/Product/product.dart';
import 'package:pet_shop/components/container_button_model.dart';

class OrderDetailsScreen extends StatefulWidget {
  final Order item;

  const OrderDetailsScreen({Key? key, required this.item}) : super(key: key);

  @override
  _OrderDetailsScreenState createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  String name = "";
  String phone = "";
  bool isLoading = true;
  OrderController orderController = Get.find<OrderController>();
  HomeController homeController = Get.find<HomeController>();

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    String fetchedPhone = await SecurityStorage().getSecureData("phone");
    String fetchedName = await SecurityStorage().getSecureData("username");
    setState(() {
      phone = fetchedPhone;
      name = fetchedName;
      isLoading = false;
    });
  }

  @override
  void dispose() {
    homeController.getData();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: Text('Thông tin đơn hàng'),
      ),
      backgroundColor: CustomAppColor.lightBackgroundColor_Home,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            OrderInfoSection(
              item: widget.item,
            ),
            // SizedBox(height: 16),
            // ShippingInfoSection(
            //   order: widget.item,
            // ),
            SizedBox(height: 16),
            AddressInfoSection(
              phone: phone,
              address: widget.item.address,
              username: name,
            ),
            SizedBox(height: 16),
            SelectedItemsSection(items: widget.item.products),
            SizedBox(height: 16),
            TotalAmountSection(total: widget.item.orderTotal),
            SizedBox(height: 16),
            PaymentMethodSection(billing: widget.item.billing),
            SizedBox(height: 16),
            TimeSection(
              order: widget.item,
            ),
            // SizedBox(height: 16),
            // OrderSummarySection(
            //   order: widget.item,
            // ),
          ],
        ),
      ),
      bottomNavigationBar: widget.item.status.trim() != "final" &&
              widget.item.status.trim() != "rejected"
          ? GestureDetector(
              onTap: () {
                widget.item.status.trim() == "pending"
                    ? handleCancelOrder(widget.item)
                    : (widget.item.status.trim() == "approved" ||
                            (widget.item.status.trim() == "final" &&
                                !widget.item.isConfirm))
                        ? handleFinalOrder(widget.item)
                        : handelRebuyOrder();
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                margin: EdgeInsets.all(10),
                height: 60,
                decoration: BoxDecoration(
                  color: widget.item.status.trim() == "approved"
                      ? Colors.grey
                      : CustomAppColor.primaryColorOrange,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    widget.item.status.trim() == "pending"
                        ? "Hủy đơn"
                        : (widget.item.status.trim() == "approved" ||
                                (widget.item.status.trim() == "final" &&
                                    !widget.item.isConfirm))
                            ? "Nhận đơn"
                            : "Mua lại",
                    style: GoogleFonts.raleway().copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            )
          : SizedBox(),
    );
  }

  handleFinalOrder(Order order) async {
    var isSuccess = orderController.updateIsConfirm(order.id);
    if (await isSuccess) {
      orderController.getAllStatusOrder();
      Navigator.of(context).pop();
    }
  }

  handelRebuyOrder() {}
  handleCancelOrder(Order order) async {
    var isSuccess = orderController.cancleOrder(order);
    if (await isSuccess) {
      orderController.getAllStatusOrder();
      Navigator.of(context).pop();
    }
  }
}

class OrderInfoSection extends StatelessWidget {
  final Order item;

  const OrderInfoSection({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Row(
              children: [
                Icon(
                  Icons.info_outline,
                  size: 20,
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  'Thông tin đơn hàng',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ],
            ),
          ]),
          SizedBox(
            height: 5,
          ),
          Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Mã đơn hàng: ',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: Colors.black54),
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  '${item.id}',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            children: [
              Text('Trạng thái: ',
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54)),
              Container(
                padding: EdgeInsets.symmetric(vertical: 2, horizontal: 5),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '${item.status}',
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          ),
          SizedBox(height: 8),
          SizedBox(height: 8),
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 2, horizontal: 5),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text('ĐƠN HÀNG',
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    )),
              ),
              Spacer(),
              item.status != "approved"
                  ? Container(
                      padding: EdgeInsets.symmetric(vertical: 2, horizontal: 5),
                      decoration: BoxDecoration(
                        color: Colors.amber.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'Chưa thanh toán'.toUpperCase(),
                        style: TextStyle(
                          color: Colors.amber,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  : Container(
                      padding: EdgeInsets.symmetric(vertical: 2, horizontal: 5),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'Đã thanh toán'.toUpperCase(),
                        style: TextStyle(
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
            ],
          ),
        ],
      ),
    );
  }
}

class ShippingInfoSection extends StatelessWidget {
  final Order order;

  const ShippingInfoSection({super.key, required this.order});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Thông tin vận chuyển',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(height: 8),
          Text('${order.address}'),
          SizedBox(height: 8),
        ],
      ),
    );
  }
}

class AddressInfoSection extends StatelessWidget {
  final String phone;
  final String address;
  final String username;

  const AddressInfoSection(
      {super.key,
      required this.phone,
      required this.address,
      required this.username});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Container(
          width: constraints.maxWidth,
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.local_shipping,
                    size: 20,
                  ),
                  SizedBox(
                    width: 7,
                  ),
                  Text(
                    'Địa chỉ giao hàng',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Padding(
                padding: EdgeInsets.only(left: 27),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      username,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5),
                    Text(phone, style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 5),
                    Text(TransformCustomApp().formatAddress(address),
                        style: TextStyle(color: Colors.black54)),
                    SizedBox(height: 8),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class SelectedItemsSection extends StatelessWidget {
  final List<ProductOrder> items;

  const SelectedItemsSection({super.key, required this.items});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.shopping_cart,
                size: 20,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                'Mặt hàng đã chọn',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ],
          ),
          SizedBox(height: 5),
          SizedBox(
            height: 350,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Divider(
                    height: 20,
                  ),
                  Column(
                    children: items
                        .map(
                          (item) => ItemRow(
                            imageUrl: item.product.image,
                            title: item.product.name,
                            price: item.price.toInt(),
                            quantity: item.quantity,
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ItemRow extends StatelessWidget {
  final String imageUrl;
  final String title;
  final int price;
  final int quantity;

  const ItemRow({
    Key? key,
    required this.imageUrl,
    required this.title,
    required this.price,
    required this.quantity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: 5),
        child: Column(
          children: [
            Row(
              children: [
                Image.network(
                  imageUrl,
                  width: 70,
                  height: 100,
                  fit: BoxFit.cover,
                ),
                SizedBox(width: 15),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15)),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "${TransformCustomApp().formatCurrency(price.toInt())}",
                              style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15),
                            ),
                            Text(
                              "x${quantity}",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 12),
                            ),
                          ]),
                    ],
                  ),
                ),
              ],
            ),
            Divider(
              height: 30,
            ),
          ],
        ));
  }
}

class TotalAmountSection extends StatelessWidget {
  final int total;

  const TotalAmountSection({super.key, required this.total});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Thành tiền',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              Text('${TransformCustomApp().formatCurrency(total)}',
                  style: TextStyle(
                      color: Colors.red, fontWeight: FontWeight.bold)),
            ],
          ),
          // SizedBox(height: 8),
          // Text('Vui lòng thanh toán ₫40.660 khi nhận hàng.'),
        ],
      ),
    );
  }
}

class PaymentMethodSection extends StatelessWidget {
  final String billing;

  const PaymentMethodSection({super.key, required this.billing});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Phương thức thanh toán',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ],
          ),
          SizedBox(height: 5),
          Row(
            children: [
              Expanded(
                child: Container(
                  alignment: AlignmentDirectional.center,
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 40),
                  decoration: BoxDecoration(
                    color: Colors.amber.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    billing == "cod"
                        ? 'Thanh Toán Khi Nhận Hàng'
                        : "Đã Thanh Toán Bằng ZaloPay".toUpperCase(),
                    style: TextStyle(
                      color: Colors.amber,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

class OrderSummarySection extends StatelessWidget {
  final Order order;

  const OrderSummarySection({super.key, required this.order});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Summary',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text('UserId: ${order.id}'),
          SizedBox(height: 8),
          Text('Order Total: ${order.orderTotal}'),
          SizedBox(height: 8),
          Text('Address: ${order.address}'),
          SizedBox(height: 8),
          Text('Status: ${order.status}'),
          SizedBox(height: 8),
          Text('Description: ${order.description}'),
          SizedBox(height: 8),
        ],
      ),
    );
  }
}

class TimeSection extends StatelessWidget {
  final Order order;

  const TimeSection({super.key, required this.order});
  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('hh:mm, dd/MM/yyyy').format(order.date);

    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.summarize_outlined,
                size: 20,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                'Thời gian đặt hàng',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Thời gian đặt hàng: ',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: Colors.black54),
              ),
              Text(
                '${formattedDate}',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     Text(
          //       'Thời gian cập nhật: ',
          //       style: TextStyle(
          //           fontWeight: FontWeight.bold,
          //           fontSize: 13,
          //           color: Colors.black54),
          //     ),
          //     Text(
          //       '${formattedDate}',
          //       style: TextStyle(
          //         fontSize: 13,
          //         color: Colors.black54,
          //       ),
          //     ),
          //   ],
          // )
        ],
      ),
    );
  }
}
