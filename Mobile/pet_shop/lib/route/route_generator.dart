import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pet_shop/config/constant.dart';
import 'package:pet_shop/controllers/Account/auth_controller.dart';
import 'package:pet_shop/controllers/Home/home_controller.dart';
import 'package:pet_shop/controllers/Order/order_controller.dart';
import 'package:pet_shop/controllers/Predict/predict_controller.dart';
import 'package:pet_shop/controllers/Product/cart_controller.dart';
import 'package:pet_shop/controllers/Product/filter_controller.dart';
import 'package:pet_shop/controllers/Product/product_controller.dart';
import 'package:pet_shop/models/Home/Banners/ad_banner.dart';
import 'package:pet_shop/models/ModelPredict/model_product.dart';
import 'package:pet_shop/models/Order/order.dart';
import 'package:pet_shop/models/Order/product_order.dart';
import 'package:pet_shop/models/Product/category.dart';
import 'package:pet_shop/models/Product/product.dart';
import 'package:pet_shop/payment/payment_screen.dart';
import 'package:pet_shop/recognize_model/model.dart';
import 'package:pet_shop/screen/Account/forget_screen.dart';
import 'package:pet_shop/screen/Account/login_screen.dart';
import 'package:pet_shop/screen/Account/otp_verify_screen.dart';
import 'package:pet_shop/screen/Account/preAccess.dart';
import 'package:pet_shop/screen/Account/recovery_screen.dart';
import 'package:pet_shop/screen/Account/register_new_member.dart';
import 'package:pet_shop/screen/Account/signup_screen.dart';
import 'package:pet_shop/screen/Camera/camera_screen.dart';
import 'package:pet_shop/screen/Camera/scan_screen.dart';
import 'package:pet_shop/screen/CartAndPayment/cart_screen.dart';
import 'package:pet_shop/screen/Home/components/carousel_slider/banner_details.dart';
import 'package:pet_shop/screen/Home/components/carousel_slider/carousel_loading.dart';
import 'package:pet_shop/screen/Home/components/selection_component/selection_title.dart';
import 'package:pet_shop/screen/Navigation/navigation_screen.dart';
import 'package:pet_shop/screen/Order/order_details_screen.dart';
import 'package:pet_shop/screen/Order/order_screen.dart';
import 'package:pet_shop/screen/Order/order_summary_screen.dart';
import 'package:pet_shop/screen/Payment/payment.dart';
import 'package:pet_shop/screen/Predict/list_predict.dart';
import 'package:pet_shop/screen/Product/Category/category_screen.dart';
import 'package:pet_shop/screen/Profile/UpdateProfile/update_profile.dart';
import 'package:pet_shop/screen/Profile/UpdateProfile/update_profile_order.dart';
import 'package:pet_shop/screen/Profile/profile_screen.dart';
import 'package:pet_shop/screen/Rate/rate_screen.dart';
import 'package:pet_shop/screen/Product/ProductCategory/product_category.dart';
import 'package:pet_shop/screen/Product/detail_product.dart';
import 'package:pet_shop/screen/Product/Recognize/dog_details_page.dart';
import 'package:pet_shop/screen/Product/Review/product_review_screen.dart';

import 'package:pet_shop/screen/SplashScreen/on_boarding.dart';
import 'package:pet_shop/screen/SplashScreen/splash_screen.dart';

class Routes {
  static const String homepage = "/";
  static const String onBoarding = "/on_boarding";
  static const String splashScreen = "/splash_screen";
  static const String sign_in = "/signin";
  static const String sign_up = "/signup";
  static const String details = '/details';
  static const String forget_password = "/forget_password";
  static const String recovery_password = "/recovery_password";
  static const String register_member = "/register_member";
  static const String otp_verified = "/otp_verified";
  static const String camera = "/camera";
  static const String scanner = "/scan";
  static const String pred_list = "/pred_list";
  static const String snackBarScreen = "/test";
  static const String testModelScreen = "/test_model";
  static const String productCard = "/product_card";
  static const String preAccessScreen = "/pre";
  static const String order_view = "/order_view";
  static const String dog_detail = "/dog_detail";
  static const String order_sumary = "/ordder_summary";
  static const String product_category = "/product_category";
  static const String list_category = "/list_category";
  static const String rate_comment = "/comment";
  static const String order_detail = "/order_detail";
  static const String cart = "/cart";
  static const String pay = "/pay";
  static const String bannerDetails = "/banner_detail";
  static const String updateProfile = "/updateProfile";
  static const String profile = "/profile";
  static const String updateProfileOrder = "/order_profile";
}

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    Get.put(AuthController());
    Get.put(PredictController());
    Get.put(HomeController());
    Get.put(ProductController());
    Get.put(OrderController());
    Get.put(CartController());
    Get.put(FilterController());
    final args = settings.arguments;
    switch (settings.name) {
      case Routes.splashScreen:
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case Routes.onBoarding:
        return MaterialPageRoute(builder: (_) => OnBoarding());
      case Routes.homepage:
        return MaterialPageRoute(builder: (_) => NavigationScreen());
      case Routes.details:
        if (args is DetailProductArguments) {
          return MaterialPageRoute(
            builder: (_) => DetailProduct(
              idProduct: args.idProduct,
              product: args.product,
            ),
          );
        }
        return _errorRoute();
      case Routes.order_detail:
        if (args is Order) {
          return MaterialPageRoute(
              builder: (_) => OrderDetailsScreen(
                    item: args,
                  ));
        }
        return _errorRoute();
      case Routes.bannerDetails:
        if (args is AdBanner) {
          return MaterialPageRoute(
              builder: (_) => BannerDetails(
                    banner: args,
                  ));
        }
        return _errorRoute();
      case Routes.pred_list:
        if (args is XFile) {
          return MaterialPageRoute(
            builder: (_) => ListPredict(
              image: args,
            ),
          );
        }
        return _errorRoute();
      case Routes.dog_detail:
        if (args is DogDetailsArguments) {
          return MaterialPageRoute(
            builder: (_) => DogDetailsPage(
              name: args.name,
              imgPath: args.imgPath,
              listProducts: args.listProducts,
            ),
          );
        }
        return _errorRoute();
      case Routes.product_category:
        if (args is SelectionTitleArguments) {
          return MaterialPageRoute(
            builder: (_) => ProductCategory(
              productList: args.productList,
              name: args.name,
              idCate: args.idCate,
              isSearch: args.isSearch,
            ),
          );
        }
        return _errorRoute();
      case Routes.updateProfile:
        return MaterialPageRoute(builder: (_) => UpdateProfile());
      case Routes.updateProfileOrder:
        if (args is int) {
          return MaterialPageRoute(
            builder: (_) => UpdateProfileOrder(
              totalOrder: args,
            ),
          );
        }
        return _errorRoute();
      // return MaterialPageRoute(builder: (_) => UpdateProfileOrder());
      case Routes.profile:
        return MaterialPageRoute(builder: (_) => ProfileScreen());
      case Routes.sign_in:
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case Routes.cart:
        return MaterialPageRoute(builder: (_) => CartScreen());
      case Routes.list_category:
        if (args is List<Category>) {
          return MaterialPageRoute(
            builder: (_) => CategoryScreen(
              categories: args,
            ),
          );
        }
        return _errorRoute();

      case Routes.rate_comment:
        if (args is ProductUnreviewed) {
          return MaterialPageRoute(
            builder: (_) => RateScreen(productUnreviewed: args),
          );
        }
        return _errorRoute();
      case Routes.order_sumary:
        // return MaterialPageRoute(builder: (_) => OrderSummaryScreen());
        if (args is List<ProductOrder>) {
          return MaterialPageRoute(
            builder: (_) => OrderSummaryScreen(
              selectedItems: args,
            ),
          );
        }
        return _errorRoute();
      case Routes.order_view:
        if (args is List<Order>) {
          return MaterialPageRoute(
              builder: (_) => OrderScreen(orderList: args));
        }
        return _errorRoute();
      case Routes.register_member:
        return MaterialPageRoute(builder: (_) => SignupScreen());
      case Routes.pay:
        return MaterialPageRoute(
            builder: (_) => Dashboard(
                  title: "A",
                  version: "a",
                ));

      case Routes.forget_password:
        return MaterialPageRoute(builder: (_) => ForgetScreen());
      case Routes.recovery_password:
        if (args is String) {
          return MaterialPageRoute(builder: (_) => RecoveryScreen(email: args));
        }
        return _errorRoute();
      case Routes.sign_up:
        return MaterialPageRoute(builder: (_) => RegisterNewMember());
      // case Routes.camera:
      //   return MaterialPageRoute(builder: (_) => CameraScreen());
      // case Routes.scanner:
      //   return MaterialPageRoute(builder: (_) => ScanScreen());
      case Routes.productCard:
        return MaterialPageRoute(builder: (_) => CarouselLoading());

      case Routes.testModelScreen:
        return MaterialPageRoute(builder: (_) => Model());
      case '/pre':
        return MaterialPageRoute(builder: (_) => PreAccess());

      case Routes.otp_verified:
        if (args is String) {
          return MaterialPageRoute(
              builder: (_) => OtpVerifyScreen(email: args));
        }
        return _errorRoute();

      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        backgroundColor: CustomAppColor.lightBackgroundColor_Home,
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('Error'),
        ),
      );
    });
  }
}
