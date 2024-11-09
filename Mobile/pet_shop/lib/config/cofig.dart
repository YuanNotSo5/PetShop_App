// ![Payment]
class ZaloPayConfig {
  static const String appId = "2553";
  static const String key1 = "PcY4iZIKFCIdgZvA6ueMcMHHUbRLYjPL";
  static const String key2 = "kLtgPl8HHhfvMuDHPwKfgfsY4Ydm9eIz";

  static const String appUser = "Pet Shop";
  static int transIdDefault = 1;
}

class Config {
  // ! [Notification]
  static const String oneSignalApp = "e8134ccc-3926-4e95-9b88-b697078421df";
  static const String addDevice = "/api/user/add_device";
  // ! [Token store]
  // https://khachhang.ghn.vn/account
  // https://viblo.asia/p/su-dung-api-giao-hang-nhanh-de-tinh-gia-cuoc-van-chuyen-1Je5EQB45nL
  static const String storeTokenGHN = "039fcd55-5630-11ef-9216-121022568175";
  static const String shopId = "5251508";
  static const int shopDistrict = 1461; //Gò Vấp
  // ! [Get Address]
  static const String getProvince =
      "https://online-gateway.ghn.vn/shiip/public-api/master-data/province";
  static const String getDistrict =
      "https://online-gateway.ghn.vn/shiip/public-api/master-data/district";
  static const String getWard =
      "https://online-gateway.ghn.vn/shiip/public-api/master-data/ward";
  static const String getFee =
      "https://online-gateway.ghn.vn/shiip/public-api/v2/shipping-order/fee";

  //! Server
  static const String appName = "Shopping App";
  static const String url = "https://pet_shop";
  // static const String apiURL = "192.168.1.191:3100";
  static const String apiURL = "render-petshop.onrender.com";

  //!News
  static const String bannerAPI = "/api/news/search";
  static const String bannerNewAPI = "/api/news/searchNew";
  static const String getBannerIdAPI = "/api/news/";
  //!Register
  static const String apiSignUp = "/api/auth/register";
  //!Login--hết giờ
  static const String loginAPI = "/api/auth/login";
  static const String activateAPI = "/api/auth/activate/";

  //! Forget password
  static const String getOtpAPI = "/api/auth/forget_password";
  static const String verifyOtpAPI = "/api/auth/verify_otp";
  static const String updatePassOtpAPI = "/api/auth/update_forget_password";

  // ! Category
  static const String categoryAPI = "/api/category/searchMobile";
  static const String categorySearchByName = "/api/category/searchByNameMobile";
  static const String categoryContainProducts = "/api/category/productsM/";
  static const String searchProductsBySlug = "/api/category/searchBySlug/";
  static const String getIdBySlug = "/api/category//getIdBySlud/";
  // http://localhost:3100/api/category/products/6694177f68ad0eb07017e421?page=1&&limit=1

  // ! Profile
  static const String getProfile = "/api/user/profileM";
  static const String updatePasswordAPI = "/api/auth/update_password";
  static const String updateInfoUser = "/api/user/";

  // ! Product
  static const String productAPI = "/api/product/search";
  static const String productSearchName = "/api/product/searchByNameMobile/";
  static const String productSearchPrice = "/api/product/searchByPrice/";
  static const String recommendedProduct = "/api/product/recommend/";
  static const String getNewProduct = "/api/product/getNewProduct/";
  static const String getPopularProduct = "/api/product/getPopularProduct";
  static const String getHighRecommendProduct =
      "/api/product/getHighRecommendProduct";
  static const String filterProduct = "/api/product/filterProduct";
  static const String getProductByID = "/api/product/getPM/";

  // !Comment
  static const String productGetReviews = "/api/product/";
  static const String productPostReviews = '/api/product/';

  //!Order
  // ? post
  static const String createOrderAPI = "/api/order";
  static const String getUserOrder = "/api/order/user";
  static const String getLastestAddress = "/api/order/latestOrderAddress";
  static const String getOrderStauts = "/api/order/viewM/";
  static const String getUnreviewdItem = "/api/order/getUnreviewdItem";
  static const String updateIsConfirm = "/api/order/updateConfirm";
  static const String updateCancelOrder = "/api/order/";
  //http://localhost:3100/api/order/change-state/66954066178464e463889d48
  // http://localhost:3100/api/order/searchByName?name=350
  // http://localhost:3100/api/order/669486dd598f9574912217dc --sửa
  // http://localhost:3100/api/order/ordersByTotal?minTotal=200&maxTotal=500
  // http://localhost:3100/api/order/ordersByMonth?month=6&year=2024
  // http://localhost:3100/api/order/uniqueAddresses

  //!Favorite
  static const String favoriteGetAllAPI = "/api/favourites/getAll";
  static const String favoriteAPI = "api/favourites/";
  static const String updateFavAPI = "api/favourites/";

  //!Cart
  static const String cartAPI = "api/cart/";
  static const String deleteCartAPI = "api/cart/clear";
  static const String subtractCartAPI = "api/cart/sub";

  //!Predict
  static const String predict = "/api/recognize/predict";
}
