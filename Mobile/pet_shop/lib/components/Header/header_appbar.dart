import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pet_shop/components/Search/custom_search_delegate.dart';
import 'package:pet_shop/config/constant.dart';
import 'package:badges/badges.dart' as badges;
import 'package:pet_shop/controllers/Account/auth_controller.dart';
import 'package:pet_shop/controllers/Product/product_controller.dart';
import 'package:pet_shop/models/Product/product.dart';
import 'package:pet_shop/route/route_generator.dart';
import 'package:get/get.dart';

class Header_Appbar extends StatelessWidget implements PreferredSizeWidget {
  final bool isBack;
  final String name;
  final bool isShowingCart;
  final String id;
  final List<Product> items;
  // final List<Category> cates;

  const Header_Appbar({
    super.key,
    required this.context,
    this.isBack = true,
    this.name = "",
    this.isShowingCart = false,
    this.id = "all",
    this.items = const [],
    // this.cates = const [],
  });

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      toolbarHeight: 75,
      elevation: 0,
      leadingWidth: 90, // Điều chỉnh chiều rộng để hình ảnh hiển thị đầy đủ
      leading: isBack
          ? BackButton()
          : Padding(
              padding: EdgeInsets.only(left: 0),
              child: Container(
                child: Image(
                  image: AssetImage("assets/images/_project/Logo/logo.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
      actions: isShowingCart ? icon_showing(context) : null,
    );
  }

  List<Widget> icon_showing(BuildContext context) {
    return <Widget>[
      InkWell(
        onTap: () {
          showSearch(
            context: context,
            delegate: CustomSearchDelegate(
              id: id,
              items: [],
              // categoryItems: [],
            ),
          );
        },
        child: Image(
          image: AssetImage(
            "assets/images/_project/Icons/loupe.png",
          ),
          width: 25,
        ),
      ),
      SizedBox(
        width: 20.0,
      ),
      // badges.Badge(
      //   badgeContent: Text(
      //     '3',
      //     style: TextStyle(
      //       color: Colors.white,
      //     ),
      //   ),
      //   badgeStyle: badges.BadgeStyle(
      //     badgeColor: kPrimaryColor,
      //     padding: EdgeInsets.all(7),
      //     borderRadius: BorderRadius.circular(12),
      //   ),
      //   child: InkWell(
      //     onTap: () {
      //       if (AuthController.instance.isLogin == false) {
      //         Navigator.of(context).pushNamed(Routes.sign_in);
      //       } else {
      //         Navigator.of(context).pushNamed(Routes.cart);
      //       }
      //     },
      //     child: Image(
      //       image: AssetImage(
      //         "assets/images/_project/Icons/shopping-bag-blue.png",
      //       ),
      //       width: 30,
      //       height: 30,
      //     ),
      //   ),
      // ),
      InkWell(
        onTap: () {
          if (AuthController.instance.isLogin == false) {
            Navigator.of(context).pushNamed(Routes.sign_in);
          } else {
            Navigator.of(context).pushNamed(Routes.cart);
          }
        },
        child: Image(
          image: AssetImage(
            "assets/images/_project/Icons/shopping-bag-blue.png",
          ),
          width: 30,
          height: 30,
        ),
      ),
      SizedBox(
        width: 30,
      ),
    ];
  }

  @override
  Size get preferredSize => Size.fromHeight(75.0);
}
