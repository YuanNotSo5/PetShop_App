import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:pet_shop/models/Order/order.dart';
import 'package:pet_shop/models/Order/product_order.dart';
import 'package:pet_shop/models/Product/cart.dart';
import 'package:pet_shop/models/Product/product.dart';
import 'package:pet_shop/servies/Cart/cart_service.dart';
import 'package:pet_shop/servies/Order/order_service.dart';

class CartController extends GetxController {
  static CartController instance = Get.find();
  RxList<Product> itemList = List<Product>.empty(growable: true).obs;
  RxList<ProductOrder> itemCartList =
      List<ProductOrder>.empty(growable: true).obs;
  Rx<Cart?> cart = Cart(id: "id", user: "user", products: []).obs;

  RxBool isCartLoading = false.obs;

  @override
  void onInit() {
    getCartList();
    super.onInit();
  }

  //todo [Get list cart]
  Future<void> getCartList() async {
    try {
      isCartLoading(true);
      var result = await CartService().getAll();
      if (result != null) {
        // cart.value = CartFromJson(result.body);
        itemCartList.assignAll(ItemsCartFromJson(result.body));
      } else {
        print("Failed to load orders: result is null");
      }
    } catch (e) {
      print("Error loading cart: $e");
    } finally {
      isCartLoading(false);
      print("Final cart length: ${itemCartList.length}");
    }
  }

  Future<bool> addToCart(String productId, int quantity, double? price) async {
    try {
      isCartLoading(true);
      EasyLoading.show(
        status: 'Loading',
        dismissOnTap: false,
      );

      var result = await CartService().addToCart(productId, quantity, price);
      if (result.statusCode == 200) {
        EasyLoading.showSuccess("Thêm vào giỏ hàng thành công");
        return true;
      } else {
        EasyLoading.showError("Try again");
        return false;
      }
    } catch (e) {
      return false;
    } finally {
      isCartLoading(false);
      EasyLoading.dismiss();
    }
  }

  Future<bool> substractFromCart(String productId) async {
    try {
      isCartLoading(true);

      var result = await CartService().substractItem(productId);
      if (result.statusCode == 200) {
        // EasyLoading.showSuccess("Nice");
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    } finally {
      isCartLoading(false);
    }
  }

  Future<bool> addOneToCart(
      String productId, int quantity, double? price) async {
    quantity = 1;
    try {
      isCartLoading(true);

      var result = await CartService().addToCart(productId, quantity, price);
      if (result.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    } finally {
      isCartLoading(false);
    }
  }

  Future<bool> removeItem(String productId) async {
    try {
      isCartLoading(true);
      EasyLoading.show(
        status: 'Loading',
        dismissOnTap: false,
      );
      var result = await CartService().removeItem(productId);
      if (result.statusCode == 200) {
        // EasyLoading.showSuccess("Nice");

        return true;
      } else {
        // EasyLoading.showError("Try again");

        return false;
      }
    } catch (e) {
      return false;
    } finally {
      isCartLoading(false);
      EasyLoading.dismiss();
    }
  }
}
