import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pet_shop/components/Header/header_appbar.dart';
import 'package:pet_shop/config/constant.dart';
import 'package:pet_shop/config/validators/transform.dart';
import 'package:pet_shop/controllers/Account/auth_controller.dart';
import 'package:pet_shop/controllers/Order/order_controller.dart';
import 'package:pet_shop/models/Order/order.dart';
import 'package:intl/intl.dart';
import 'package:pet_shop/route/route_generator.dart';
import 'package:pet_shop/screen/Order/component/custom_tab_bar.dart';

class OrderScreen extends StatefulWidget {
  final List<Order> orderList;

  const OrderScreen({Key? key, this.orderList = const []}) : super(key: key);

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  OrderController orderController = Get.find<OrderController>();

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    await orderController.getListOrderStaus("pending");
    await orderController.getListOrderStaus("approved");
    await orderController.getListOrderStaus("rejected");
    await orderController.getListOrderStaus("final");
    await orderController.getUnreviewedList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomAppColor.lightBackgroundColor_Home,
      appBar: Header_Appbar(
        isBack: false,
        isShowingCart: true,
        context: context,
      ),
      body: RefreshIndicator(
        onRefresh: getData,
        child: Container(
          height: MediaQuery.of(context).size.height,
          color: Colors.pink,
          child: CustomTabBar(
            pendingList: OrderController.instance.orderPending,
            approvedList: OrderController.instance.orderApproved,
            successList: OrderController.instance.ordersSuccess,
            cancelList: OrderController.instance.orderCancel,
            unpreviewList: OrderController.instance.unreviewdList,
          ),
        ),
      ),
    );
  }
}

class OrderCard extends StatefulWidget {
  final Order order;
  final String shopName;
  final String orderNumber;
  final DateTime orderTime;
  final String paymentStatus;
  final String productDescription;
  final int totalItems;
  final int totalPrice;
  final String deliveryStatus;
  final bool isDelivered;

  OrderCard({
    required this.shopName,
    required this.orderNumber,
    required this.orderTime,
    required this.paymentStatus,
    required this.productDescription,
    required this.totalItems,
    required this.totalPrice,
    required this.deliveryStatus,
    required this.isDelivered,
    required this.order,
  });

  @override
  _OrderCardState createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  OrderController orderController = Get.find<OrderController>();
  bool _buttonVisible = true;

  @override
  Widget build(BuildContext context) {
    final bool isFinalStatus = widget.deliveryStatus.trim() == "final";

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(
          color: Colors.black12,
        ),
      ),
      shadowColor: Colors.black,
      color: Colors.white,
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              Navigator.of(context)
                  .pushNamed(Routes.order_detail, arguments: widget.order);
              print(
                  'Order ID: ${widget.orderNumber}'); // In ra orderNumber khi tap vào Card
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundImage:
                            AssetImage('assets/images/_project/Logo/logo.png'),
                        radius: 16,
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(widget.shopName,
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(children: [
                        Icon(Icons.shopping_cart),
                        SizedBox(width: 5),
                        Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 2, horizontal: 5),
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
                        SizedBox(width: 5),
                        SizedBox(
                          width: 110,
                          child: Text("#${widget.orderNumber}",
                              overflow: TextOverflow.fade,
                              softWrap: false,
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ]),
                      Text(
                        'Giỏ hàng',
                        style: TextStyle(color: Colors.green),
                        textAlign: TextAlign.end,
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      SizedBox(width: 30),
                      Icon(Icons.date_range_outlined,
                          color: Colors.grey, size: 18),
                      SizedBox(width: 5),
                      Text(
                          '${TransformCustomApp().formateDateTime(widget.orderTime)}',
                          style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                  SizedBox(height: 5),
                  Container(
                    margin: EdgeInsets.only(left: 30),
                    padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      widget.paymentStatus.trim() == "paypal"
                          ? "Đã thanh toán bằng ZaloPay"
                          : "Thanh toán khi nhận hàng",
                      style: TextStyle(color: Colors.orange),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 30),
                    padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        '${widget.totalItems} sản phẩm',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Divider(),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text('Tổng thanh toán: ',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold)),
                            Text(
                                '${TransformCustomApp().formatCurrency(widget.totalPrice.toInt())}',
                                style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.local_shipping,
                          color: _getDeliveryStatusColor(
                              widget.deliveryStatus.trim())),
                      SizedBox(width: 8),
                      Text(
                        _getDeliveryStatusText(widget.deliveryStatus.trim()),
                        style: TextStyle(
                            color: _getDeliveryStatusColor(
                                widget.deliveryStatus.trim())),
                      ),
                      Spacer(),
                      Icon(Icons.arrow_forward_ios,
                          size: 16, color: Colors.grey),
                    ],
                  ),
                  Divider(),
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 10, right: 10, bottom: 20),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Text(
                    'Vui lòng chỉ nhấn "Đã nhận được hàng" khi đơn hàng đã được giao đến bạn và sản phẩm nhận được không có vấn đề nào.',
                    textAlign: TextAlign.justify,
                    maxLines: 5,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.grey, fontSize: 10),
                  ),
                ),
                SizedBox(width: 10),
                widget.order.isConfirm == false
                    ? Expanded(
                        flex: 1,
                        child: Visibility(
                          visible: _buttonVisible,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              padding: MaterialStateProperty.all(
                                  EdgeInsetsDirectional.symmetric(
                                      horizontal: 5)),
                              backgroundColor: MaterialStateProperty.all(
                                  isFinalStatus
                                      ? Colors.green
                                      : Colors.grey[400]),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5))),
                              fixedSize: MaterialStateProperty.all(
                                  Size.fromWidth(130)),
                            ),
                            onPressed: widget.isDelivered
                                ? null
                                : () async {
                                    var isSuccess = orderController
                                        .updateIsConfirm(widget.order.id);
                                    if (await isSuccess) {
                                      orderController.getAllStatusOrder();
                                    }
                                  },
                            child: Text(
                              'Đã nhận được hàng',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 12),
                              maxLines: 2,
                            ),
                          ),
                        ),
                      )
                    : SizedBox.shrink(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getDeliveryStatusText(String status) {
    switch (status) {
      case "pending":
        return "Chờ xác nhận";
      case "approved":
        return "Đang giao";
      case "final":
        return "Đã nhận";
      case "cancel":
        return "Hủy đơn";
      default:
        return "Đơn hàng bị hủy";
    }
  }

  Color _getDeliveryStatusColor(String status) {
    switch (status) {
      case "pending":
        return Colors.orange; // Màu sắc cho trạng thái 'pending'
      case "approved":
        return Colors.blue; // Màu sắc cho trạng thái 'approved'
      case "final":
        return Colors.green; // Màu sắc cho trạng thái 'final'
      case "cancel":
        return Colors.red; // Màu sắc cho trạng thái 'cancel'
      default:
        return Colors.grey; // Màu sắc cho trạng thái không xác định
    }
  }
}
