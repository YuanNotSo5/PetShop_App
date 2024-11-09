import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pet_shop/components/Header/header_appbar.dart';
import 'package:pet_shop/config/constant.dart';
import 'package:pet_shop/config/validators/transform.dart';
import 'package:pet_shop/controllers/Order/order_controller.dart';
import 'package:pet_shop/models/Order/order.dart';
import 'package:pet_shop/models/Product/Product.dart';
import 'package:pet_shop/route/route_generator.dart';
import 'package:pet_shop/screen/Order/order_screen.dart';
import 'package:pet_shop/screen/Product/detail_product.dart';

class CustomTabBar extends StatefulWidget {
  final List<Order> pendingList;
  final List<Order> approvedList;
  final List<Order> successList;
  final List<Order> cancelList;
  final List<ProductUnreviewed> unpreviewList;

  const CustomTabBar({
    Key? key,
    required this.pendingList,
    required this.approvedList,
    required this.successList,
    required this.cancelList,
    required this.unpreviewList,
  }) : super(key: key);

  @override
  _CustomTabBarState createState() => _CustomTabBarState();
}

class _CustomTabBarState extends State<CustomTabBar>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Tab> _tabs = [
    Tab(text: "Chờ xác nhận"),
    Tab(text: "Đang giao"),
    Tab(text: "Đã nhận"),
    Tab(text: "Hủy đơn"),
    Tab(text: "Đánh giá"),
  ];

  late List<Widget> _tabBody;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _tabBody = [
      ReuseableAppBodyWidget(
        icon: Icons.pending,
        title: "Chờ xác nhận",
        status: 'pending',
        orderListStatus: widget.pendingList,
      ),
      ReuseableAppBodyWidget(
        icon: Icons.local_shipping,
        title: "Đang giao",
        status: 'approved',
        orderListStatus: widget.approvedList,
      ),
      ReuseableAppBodyWidget(
        icon: Icons.check_circle,
        title: "Đã nhận",
        status: 'success',
        orderListStatus: widget.successList,
      ),
      ReuseableAppBodyWidget(
        icon: Icons.cancel,
        title: "Hủy đơn",
        status: 'cancel',
        orderListStatus: widget.cancelList,
      ),
      TabBodyUnreviewedItem(
        unpreviewedListStatus: widget.unpreviewList,
      ),
    ];
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomAppColor.lightBackgroundColor_Home,
      body: SafeArea(
        child: Column(
          children: [
            TabBar(
              isScrollable: true,
              controller: _tabController,
              tabs: _tabs,
              labelColor: CustomAppColor.primaryColorOrange,
              indicatorColor: CustomAppColor.primaryColorOrange,
              unselectedLabelColor: CustomAppColor.lightAccentColor,
              indicatorSize: TabBarIndicatorSize.tab,
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: _tabBody,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ReuseableAppBodyWidget extends StatefulWidget {
  final IconData icon;
  final String title;
  final String status;
  final List<Order> orderListStatus;

  const ReuseableAppBodyWidget({
    Key? key,
    required this.icon,
    required this.title,
    required this.status,
    required this.orderListStatus,
  }) : super(key: key);

  @override
  _ReuseableAppBodyWidgetState createState() => _ReuseableAppBodyWidgetState();
}

class _ReuseableAppBodyWidgetState extends State<ReuseableAppBodyWidget> {
  Future<void> _refreshOrders() async {
    await OrderController.instance.getAllStatusOrder();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refreshOrders,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Obx(() {
          // Check if orderListStatus is empty
          if (widget.orderListStatus.isEmpty) {
            return SingleChildScrollView(
              physics:
                  AlwaysScrollableScrollPhysics(), // Ensures scroll even if content is less
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment:
                      CrossAxisAlignment.center, // Center horizontally
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.2),
                    Image.asset(
                      'assets/images/_project/Logo/logo.png',
                      width: 150,
                      height: 150,
                    ),
                    Text(
                      'Không tìm thấy đơn hàng',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.2),
                  ],
                ),
              ),
            );
          } else {
            // Display the list of orders if data is available
            return ListView.builder(
              itemCount: widget.orderListStatus.length,
              itemBuilder: (context, index) {
                final order = widget.orderListStatus[index];
                // return OrderCard(
                //   shopName: 'Puppy Pet Shop',
                //   orderNumber: order.id,
                //   orderTime: order.date,
                //   paymentStatus: order.billing,
                //   productDescription:
                //       "",
                //   totalItems: order.products.length,
                //   totalPrice: order.orderTotal,
                //   deliveryStatus: order.status,
                //   isDelivered: order.status == "final" ? false : true,
                //   order: order,
                // );
                return OrderCard(
                  shopName: 'Puppy Pet Shop',
                  orderNumber: order.id,
                  orderTime: order.date,
                  paymentStatus: order.billing,
                  productDescription: "",
                  totalItems: order.totalItems, // Sử dụng getter totalItems
                  totalPrice: order.orderTotal,
                  deliveryStatus: order.status,
                  isDelivered: order.status == "final" ? false : true,
                  order: order,
                );
              },
            );
          }
        }),
      ),
    );
  }
}

class TabBodyUnreviewedItem extends StatefulWidget {
  final List<ProductUnreviewed> unpreviewedListStatus;
  const TabBodyUnreviewedItem({
    Key? key,
    required this.unpreviewedListStatus,
  }) : super(key: key);

  @override
  _TabBodyUnreviewedItemState createState() => _TabBodyUnreviewedItemState();
}

class _TabBodyUnreviewedItemState extends State<TabBodyUnreviewedItem> {
  Future<void> _refreshOrders() async {
    await OrderController.instance.getAllStatusOrder();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refreshOrders,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Obx(() {
          if (widget.unpreviewedListStatus.isEmpty) {
            return SingleChildScrollView(
              physics:
                  AlwaysScrollableScrollPhysics(), // Ensures scroll even if content is less
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment:
                      CrossAxisAlignment.center, // Center horizontally
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.2),
                    Image.asset(
                      'assets/images/_project/Logo/logo.png',
                      width: 150,
                      height: 150,
                    ),
                    Text(
                      'Bạn đã đánh giá\ntất cả sản phẩm',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.2),
                  ],
                ),
              ),
            );
          } else {
            // Display the list of products if data is available
            return ListView.builder(
              itemCount: widget.unpreviewedListStatus.length,
              itemBuilder: (context, index) {
                final product = widget.unpreviewedListStatus[index];
                return ItemUnreviewed(
                  product: product,
                );
              },
            );
          }
        }),
      ),
    );
  }
}

class ItemUnreviewed extends StatelessWidget {
  final ProductUnreviewed product;

  const ItemUnreviewed({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 5),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.grey.shade500,
          width: 0.7,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              Navigator.of(context).pushNamed(
                Routes.details,
                arguments: DetailProductArguments(
                  idProduct: product.product.id,
                  product: product.product,
                ),
              );
            },
            child: Row(
              children: [
                Image.network(
                  product.product.image ??
                      'https://tiki.vn/blog/wp-content/uploads/2023/12/tam-cho-cho-bang-sua-tam-tri-ve-1024x633.jpeg',
                  width: 70,
                  height: 100,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      'assets/images/_project/Logo/logo.png',
                      width: 70,
                      height: 100,
                      fit: BoxFit.cover,
                    );
                  },
                ),
                SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.product.name,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      Text(
                        "${TransformCustomApp().formatCurrency(product.product.promotion.toInt())}",
                        style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          InkWell(
            onTap: () {
              Navigator.of(context)
                  .pushNamed(Routes.rate_comment, arguments: product);
            },
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: CustomAppColor.primaryColorOrange,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.grey, // Màu của border
                  width: 1, // Độ rộng của border
                ),
              ),
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              child: Align(
                alignment: Alignment.center,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Đánh giá",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(width: 5),
                    Icon(
                      Icons.arrow_drop_down_outlined,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
