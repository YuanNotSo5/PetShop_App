import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pet_shop/components/Header/header_appbar.dart';
import 'package:pet_shop/config/constant.dart';
import 'package:pet_shop/config/responsive/responsive_widget.dart';
import 'package:pet_shop/config/secure_storage/security_storage.dart';
import 'package:pet_shop/config/validators/transform.dart';
import 'package:pet_shop/config/validators/validation.dart';
import 'package:pet_shop/controllers/Account/auth_controller.dart';
import 'package:pet_shop/controllers/Order/order_controller.dart';
import 'package:pet_shop/models/Address/address.dart';
import 'package:pet_shop/route/route_generator.dart';
import 'dart:convert';

class UpdateProfileOrder extends StatefulWidget {
  final int totalOrder;
  const UpdateProfileOrder({Key? key, required this.totalOrder})
      : super(key: key);

  @override
  _UpdateProfileOrderState createState() => _UpdateProfileOrderState();
}

class _UpdateProfileOrderState extends State<UpdateProfileOrder> {
  AuthController authController = Get.find<AuthController>();
  OrderController orderController = Get.find<OrderController>();
  String? username;
  String? password;

  //UserInfo
  String name = "";
  String email = "";
  String phone = "";

  //Form
  GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _userNameFocusNode = FocusNode();
  final FocusNode _addressFocusNode = FocusNode();
  final FocusNode _phoneNumberFocusNode = FocusNode();

  City? defaultCity;
  District? selectedDistrict;
  Ward? selectedWard;
  //district
  String? selectedValuedis;
  String? selectedValueCity;
  String? selectedValueward;

  @override
  void initState() {
    resetState();

    getData().then((_) {
      getListData();
    });

    getListData();

    super.initState();
  }

  void resetState() {
    selectedDistrict = null;
    selectedWard = null;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    _addressController.dispose();
    _phoneNumberController.dispose();
    _emailFocusNode.dispose();
    _userNameFocusNode.dispose();
    _addressFocusNode.dispose();
    _phoneNumberFocusNode.dispose();

    orderController.districtList.clear();
    orderController.wardList.clear();

    super.dispose();
  }

  void getListData() async {
    await orderController.getListCity();

    if (defaultCity != null) {
      await getDistrict(defaultCity!.ProvinceID);
      await getWardList(selectedDistrict!.DistrictID);
    }
    if (selectedDistrict != null) {
      getWardList(selectedDistrict!.DistrictID);
    }
  }

  Future<void> getDistrict(int provinceID) async {
    await orderController.getListDistrict(provinceID);
  }

  Future<void> getWardList(int districtID) async {
    await orderController.getWardList(districtID);
  }

  Future<void> getAddressApart(
      String cityString, String districtString, String wardString) async {
    String cleanedString = cityString.replaceAll(RegExp(r'^\{|\}$'), '');
    String cleanedStringDis = districtString.replaceAll(RegExp(r'^\{|\}$'), '');
    String cleanedStringWard = wardString.replaceAll(RegExp(r'^\{|\}$'), '');

    //todo City
    List<String> ele = cleanedString.split(":");
    String jsonString =
        '{"${ele[2]}": "${ele[3].trim()}", "${ele[0]}":  ${ele[1]}}';
    Map<String, dynamic> userMap = jsonDecode(jsonString);
    City city = City.fromJson(userMap);
    defaultCity = city;

    // //todo District
    List<String> dis = cleanedStringDis.split(":");
    String jsonStringDis =
        '{"${dis[2]}": "${dis[3].trim()}", "${dis[0]}":  ${dis[1]}}';
    Map<String, dynamic> disjson = jsonDecode(jsonStringDis);
    District district = District.fromJson(disjson);
    selectedDistrict = district;

    // //todo Ward
    List<String> ward = cleanedStringWard.split(":");
    String jsonStringWard =
        '{"${ward[2]}": "${ward[3].trim()}", "${ward[0]}":  "${ward[1]}"}';
    Map<String, dynamic> wardjson = jsonDecode(jsonStringWard);
    Ward wardObject = Ward.fromJson(wardjson);
    selectedWard = wardObject;
  }

  Future<void> getData() async {
    var isLogin = await SecurityStorage().readSecureData("token");
    if (isLogin) {
      if (!orderController.isUpdate.value) {
        var addressFromRecentlyOrder =
            await orderController.findLastestAddress();
        if (addressFromRecentlyOrder == "") {
          var result = await authController.getProfile();
          if (result != null) {
            if (authController.user.value?.address != "") {
              List<String> listAddress =
                  authController.user.value!.address.split("-");

              if (listAddress.isNotEmpty) {
                getAddressApart(listAddress[0], listAddress[1], listAddress[2]);
                _addressController =
                    TextEditingController(text: listAddress[3]);
              }
            }
          }
        } else {
          List<String> listAddress = addressFromRecentlyOrder.split("-");

          getAddressApart(listAddress[0], listAddress[1], listAddress[2]);
          _addressController = TextEditingController(text: listAddress[3]);
        }
      } else {
        List<String> listAddress = orderController.addressTmp.split("-");
        if (listAddress.isNotEmpty) {
          getAddressApart(listAddress[0], listAddress[1], listAddress[2]);
          _addressController = TextEditingController(text: listAddress[3]);
        }
      }

      String fetchedName =
          await SecurityStorage().getSecureData("username") as String;
      setState(() {
        // name = fetchedName;
        name = authController.user.value!.username;
        _usernameController = TextEditingController(text: name);
      });
      String fetchedMail =
          await SecurityStorage().getSecureData("email") as String;
      setState(
        () {
          // email = fetchedMail;
          email = authController.user.value!.email;
          _emailController = TextEditingController(text: email);
        },
      );

      String fetchedPhone =
          await SecurityStorage().getSecureData("phone") as String;
      setState(
        () {
          // phone = fetchedPhone;
          phone = authController.user.value!.phone;
          _phoneNumberController = TextEditingController(text: phone);
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async {
        bool shouldPop = await showCupertinoDialog(
          context: context,
          builder: (BuildContext context) => CupertinoAlertDialog(
            title: const Text("Thông báo"),
            content: Text("Bạn có chắc chắn muốn thoát"),
            actions: <CupertinoDialogAction>[
              CupertinoDialogAction(
                child: Text("Hủy"),
                isDestructiveAction: true,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              CupertinoDialogAction(
                child: Text("Đồng ý"),
                onPressed: () {
                  Navigator.of(context).pop(true); // Thoát
                },
              ),
            ],
          ),
        );
        return shouldPop ?? false;
      },
      child: Scaffold(
        appBar: Header_Appbar(
          context: context,
          name: "Chỉnh sửa thông tin",
        ),
        body: SizedBox(
          height: height,
          width: width,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  height: height,
                  color: CustomAppColor.lightBackgroundColor_Home,
                  child: Stack(
                    children: [
                      //! [Input Form]
                      SingleChildScrollView(
                        padding: const EdgeInsets.only(bottom: 40),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 30,
                            ),
                            // ? [Input Form/Content]
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal:
                                      ResponsiveWidget.isSmallScreen(context)
                                          ? height * 0.02
                                          : height * 0.2),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  // TODO [Input Form/Content/Form]
                                  Form(
                                    key: globalKey,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        //todo [Info]
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            "Thông tin người dùng",
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 20),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(
                                              color:
                                                  Colors.grey, // Màu của viền
                                              width: 0.05, // Độ dày của viền
                                            ),
                                            borderRadius: BorderRadius.circular(
                                                8.0), // Bo góc cho viền (tuỳ chọn)
                                          ),
                                          child: Column(
                                            children: [
                                              //todo [Username]
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  "Tên người dùng",
                                                  style: GoogleFonts.raleway()
                                                      .copyWith(
                                                          fontSize: 14.0,
                                                          color: CustomAppColor
                                                              .textColor1,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 4.0,
                                              ),
                                              TextFormField(
                                                controller: _usernameController,
                                                focusNode: _userNameFocusNode,
                                                decoration: InputDecoration(
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5.0),
                                                  ),
                                                  hintText: 'Nhập tên username',
                                                  hintStyle:
                                                      GoogleFonts.raleway()
                                                          .copyWith(
                                                    fontSize: 14.0,
                                                    color: CustomAppColor
                                                        .textColor1
                                                        .withOpacity(0.5),
                                                  ),
                                                  prefixIcon: Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            right: 16.0),
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10.0),
                                                    decoration:
                                                        const BoxDecoration(
                                                      border: Border(
                                                        right: BorderSide(
                                                            width: 1.0,
                                                            color: Color(
                                                                0xAAAA000000)),
                                                      ),
                                                    ),
                                                    child: Icon(Icons.person),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.orange,
                                                        width: 2.0),
                                                  ),
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                          vertical: 10.0,
                                                          horizontal: 10.0),
                                                ),
                                                autovalidateMode:
                                                    AutovalidateMode
                                                        .onUserInteraction,
                                                validator: (value) =>
                                                    TValidation
                                                        .validateEmptyText(
                                                  "Tên người dùng",
                                                  value,
                                                ),
                                                maxLength: 30,
                                                onEditingComplete: () =>
                                                    TextInput
                                                        .finishAutofillContext(),
                                              ),

                                              //todo [Phone]

                                              Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  "Số điện thoại",
                                                  style: GoogleFonts.raleway()
                                                      .copyWith(
                                                          fontSize: 14.0,
                                                          color: CustomAppColor
                                                              .textColor1,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 4.0,
                                              ),
                                              TextFormField(
                                                controller:
                                                    _phoneNumberController,
                                                focusNode:
                                                    _phoneNumberFocusNode,
                                                decoration: InputDecoration(
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5.0),
                                                  ),
                                                  hintText:
                                                      'Nhập số điện thoại',
                                                  hintStyle:
                                                      GoogleFonts.raleway()
                                                          .copyWith(
                                                    fontSize: 14.0,
                                                    color: CustomAppColor
                                                        .textColor1
                                                        .withOpacity(0.5),
                                                  ),
                                                  prefixIcon: Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            right: 16.0),
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10.0),
                                                    decoration:
                                                        const BoxDecoration(
                                                      border: Border(
                                                        right: BorderSide(
                                                            width: 1.0,
                                                            color: Color(
                                                                0xAAAA000000)),
                                                      ),
                                                    ),
                                                    child: Icon(Icons.phone),
                                                  ),

                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.orange,
                                                        width: 2.0),
                                                  ),
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                          vertical: 10.0,
                                                          horizontal:
                                                              10.0), // Điều chỉnh padding để tăng kích thước input
                                                ),
                                                autovalidateMode:
                                                    AutovalidateMode
                                                        .onUserInteraction,
                                                validator: (value) =>
                                                    TValidation
                                                        .validatePhoneNumber(
                                                            value),
                                                onEditingComplete: () =>
                                                    TextInput
                                                        .finishAutofillContext(),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        //todo [Địa chỉ]
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            "Địa chỉ",
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(
                                              color:
                                                  Colors.grey, // Màu của viền
                                              width: 0.05, // Độ dày của viền
                                            ),
                                            borderRadius: BorderRadius.circular(
                                                8.0), // Bo góc cho viền (tuỳ chọn)
                                          ),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 15),
                                          child: Column(
                                            children: [
                                              //todo [Thành phố]
                                              Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  "Thành phố",
                                                  style: GoogleFonts.raleway()
                                                      .copyWith(
                                                          fontSize: 14.0,
                                                          color: CustomAppColor
                                                              .textColor1,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 4.0,
                                              ),
                                              Obx(() {
                                                return DropdownButtonFormField2<
                                                    City>(
                                                  isExpanded: true,
                                                  decoration: InputDecoration(
                                                    contentPadding:
                                                        const EdgeInsets
                                                            .symmetric(
                                                            vertical: 20),
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                    ),
                                                  ),
                                                  items:
                                                      (orderController.cityList)
                                                          .map((item) =>
                                                              DropdownMenuItem<
                                                                  City>(
                                                                value: item,
                                                                child: Text(
                                                                  item.ProvinceName,
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          12),
                                                                ),
                                                              ))
                                                          .toList(),
                                                  validator: (value) {
                                                    if (value == null) {
                                                      return 'Chọn thành phố của bạn';
                                                    }
                                                    return null;
                                                  },
                                                  hint: defaultCity == null
                                                      ? Text(
                                                          'Vui lòng chọn thành phố bạn đang sống',
                                                          style: TextStyle(
                                                              fontSize: 12),
                                                        )
                                                      : null,
                                                  value: defaultCity == null
                                                      ? null
                                                      : (orderController
                                                              .cityList
                                                              .isNotEmpty
                                                          ? orderController
                                                              .cityList
                                                              .firstWhere(
                                                              (city) =>
                                                                  city.ProvinceID ==
                                                                      defaultCity
                                                                          ?.ProvinceID &&
                                                                  city.ProvinceName ==
                                                                      defaultCity
                                                                          ?.ProvinceName,
                                                              orElse: () =>
                                                                  orderController
                                                                          .cityList[
                                                                      0], // Trả về giá trị đầu tiên của danh sách nếu không tìm thấy
                                                            )
                                                          : null),
                                                  onChanged: (value) async {
                                                    //Reset
                                                    selectedDistrict = null;
                                                    selectedWard = null;

                                                    if (value != null &&
                                                        value != defaultCity) {
                                                      await getDistrict(
                                                          value.ProvinceID);
                                                      await getWardList(
                                                          orderController
                                                              .districtList[0]
                                                              .DistrictID);
                                                      setState(() {
                                                        selectedValueCity =
                                                            value.toString();
                                                        defaultCity = value;
                                                      });
                                                    }
                                                  },
                                                  onSaved: (value) async {
                                                    selectedDistrict = null;
                                                    selectedWard = null;

                                                    if (value != null) {
                                                      await getDistrict(
                                                          value.ProvinceID);
                                                      setState(() {
                                                        selectedValueCity =
                                                            value.toString();
                                                        defaultCity = value;
                                                      });
                                                    }
                                                  },
                                                  buttonStyleData:
                                                      const ButtonStyleData(
                                                    padding: EdgeInsets.only(
                                                        right: 8),
                                                  ),
                                                  iconStyleData:
                                                      const IconStyleData(
                                                    icon: Icon(
                                                      Icons.arrow_drop_down,
                                                      color: Colors.black45,
                                                    ),
                                                    iconSize: 24,
                                                  ),
                                                  dropdownStyleData:
                                                      DropdownStyleData(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                    ),
                                                    maxHeight: 200,
                                                  ),
                                                  menuItemStyleData:
                                                      const MenuItemStyleData(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 16),
                                                  ),
                                                );
                                              }),

                                              // //todo [Quận]
                                              SizedBox(
                                                height: 15,
                                              ),
                                              Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  "Quận/Huyện",
                                                  style: GoogleFonts.raleway()
                                                      .copyWith(
                                                          fontSize: 14.0,
                                                          color: CustomAppColor
                                                              .textColor1,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 4.0,
                                              ),

                                              Obx(() {
                                                print(
                                                    "aaaaaaaaaaaaaaaaaaaaaabbb ccccccccccc ${selectedDistrict}");
                                                print(
                                                    "aaaaaaaaaaaaaaaaaaaaaabbb ${orderController.districtList.isNotEmpty ? orderController.districtList.firstWhere((city) => city.DistrictID == selectedDistrict?.DistrictID && city.DistrictName == selectedDistrict?.DistrictName, orElse: () => orderController.districtList.first) : null}");
                                                return DropdownButtonFormField2<
                                                    District>(
                                                  isExpanded: true,
                                                  decoration: InputDecoration(
                                                    contentPadding:
                                                        const EdgeInsets
                                                            .symmetric(
                                                            vertical: 20),
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                    ),
                                                  ),
                                                  hint: selectedDistrict == null
                                                      ? Text(
                                                          'Vui lòng chọn quận huyện bạn đang sống',
                                                          style: TextStyle(
                                                              fontSize: 12),
                                                        )
                                                      : null,
                                                  value: (orderController
                                                          .districtList
                                                          .isNotEmpty
                                                      ? orderController.districtList.firstWhere(
                                                          (city) =>
                                                              city.DistrictID ==
                                                                  selectedDistrict
                                                                      ?.DistrictID &&
                                                              city.DistrictName ==
                                                                  selectedDistrict
                                                                      ?.DistrictName,
                                                          orElse: () =>
                                                              orderController
                                                                  .districtList
                                                                  .first)
                                                      : orderController
                                                              .districtList
                                                              .isNotEmpty
                                                          ? orderController
                                                              .districtList
                                                              .first
                                                          : null),
                                                  items: orderController
                                                      .districtList
                                                      .map((item) {
                                                    return DropdownMenuItem<
                                                        District>(
                                                      value: item,
                                                      child: Text(
                                                        item.DistrictName,
                                                        style: const TextStyle(
                                                            fontSize: 12),
                                                      ),
                                                    );
                                                  }).toList(),
                                                  validator: (value) {
                                                    if (value == null) {
                                                      return 'Vui lòng chọn quận nơi bạn ở';
                                                    }
                                                    return null;
                                                  },
                                                  onChanged: (value) async {
                                                    selectedWard = null;

                                                    if (value != null) {
                                                      await getWardList(
                                                          value.DistrictID);
                                                    }
                                                    setState(() {
                                                      selectedDistrict = value!;
                                                    });
                                                  },
                                                  onSaved: (value) async {
                                                    selectedWard = null;

                                                    if (value != null) {
                                                      await getWardList(
                                                          value.DistrictID);
                                                    }
                                                    setState(() {
                                                      selectedDistrict = value!;
                                                    });
                                                  },
                                                  buttonStyleData:
                                                      const ButtonStyleData(
                                                    padding: EdgeInsets.only(
                                                        right: 8),
                                                  ),
                                                  iconStyleData:
                                                      const IconStyleData(
                                                    icon: Icon(
                                                      Icons.arrow_drop_down,
                                                      color: Colors.black45,
                                                    ),
                                                    iconSize: 24,
                                                  ),
                                                  dropdownStyleData:
                                                      DropdownStyleData(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                    ),
                                                    maxHeight: 200,
                                                  ),
                                                  menuItemStyleData:
                                                      const MenuItemStyleData(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 16),
                                                  ),
                                                );
                                              }),

                                              // //todo [Phường]
                                              SizedBox(
                                                height: 15,
                                              ),
                                              Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  "Phường/Xã",
                                                  style: GoogleFonts.raleway()
                                                      .copyWith(
                                                          fontSize: 14.0,
                                                          color: CustomAppColor
                                                              .textColor1,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 4.0,
                                              ),

                                              Obx(() {
                                                return DropdownButtonFormField2<
                                                    Ward>(
                                                  isExpanded: true,
                                                  decoration: InputDecoration(
                                                    contentPadding:
                                                        const EdgeInsets
                                                            .symmetric(
                                                            vertical: 20),
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                    ),
                                                  ),
                                                  hint: selectedWard == null
                                                      ? Text(
                                                          'Vui lòng chọn phường xã bạn đang sống',
                                                          style: TextStyle(
                                                              fontSize: 12),
                                                        )
                                                      : null,
                                                  value: (orderController
                                                          .wardList.isNotEmpty
                                                      ? orderController.wardList.firstWhere(
                                                          (city) =>
                                                              city.WardCode ==
                                                                  selectedWard
                                                                      ?.WardCode &&
                                                              city.WardName ==
                                                                  selectedWard
                                                                      ?.WardName,
                                                          orElse: () =>
                                                              orderController
                                                                  .wardList
                                                                  .first)
                                                      : orderController.wardList
                                                              .isNotEmpty
                                                          ? orderController
                                                              .wardList.first
                                                          : null),
                                                  items: orderController
                                                      .wardList
                                                      .map((item) {
                                                    return DropdownMenuItem<
                                                        Ward>(
                                                      value: item,
                                                      child: Text(
                                                        item.WardName,
                                                        style: const TextStyle(
                                                            fontSize: 12),
                                                      ),
                                                    );
                                                  }).toList(),
                                                  validator: (value) {
                                                    if (value == null) {
                                                      return 'Vui lòng chọn phường xã nơi bạn ở';
                                                    }
                                                    return null;
                                                  },
                                                  onChanged: (value) async {
                                                    setState(() {
                                                      selectedWard = value;
                                                    });
                                                  },
                                                  onSaved: (value) async {
                                                    setState(() {
                                                      selectedWard = value!;
                                                    });
                                                  },
                                                  buttonStyleData:
                                                      const ButtonStyleData(
                                                    padding: EdgeInsets.only(
                                                        right: 8),
                                                  ),
                                                  iconStyleData:
                                                      const IconStyleData(
                                                    icon: Icon(
                                                      Icons.arrow_drop_down,
                                                      color: Colors.black45,
                                                    ),
                                                    iconSize: 24,
                                                  ),
                                                  dropdownStyleData:
                                                      DropdownStyleData(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                    ),
                                                    maxHeight: 200,
                                                  ),
                                                  menuItemStyleData:
                                                      const MenuItemStyleData(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 16),
                                                  ),
                                                );
                                              }),
                                              //todo [Địa chỉ]
                                              Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  "Địa chỉ",
                                                  style: GoogleFonts.raleway()
                                                      .copyWith(
                                                          fontSize: 14.0,
                                                          color: CustomAppColor
                                                              .textColor1,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 4.0,
                                              ),
                                              TextFormField(
                                                controller: _addressController,
                                                focusNode: _addressFocusNode,
                                                decoration: InputDecoration(
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5.0),
                                                  ),
                                                  hintText: 'Nhập địa chỉ',
                                                  hintStyle:
                                                      GoogleFonts.raleway()
                                                          .copyWith(
                                                    fontSize: 14.0,
                                                    color: CustomAppColor
                                                        .textColor1
                                                        .withOpacity(0.5),
                                                  ),
                                                  prefixIcon: Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            right: 16.0),
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10.0),
                                                    decoration:
                                                        const BoxDecoration(
                                                      border: Border(
                                                        right: BorderSide(
                                                            width: 1.0,
                                                            color: Color(
                                                                0xAAAA000000)),
                                                      ),
                                                    ),
                                                    child: Icon(Icons.house),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.orange,
                                                        width: 2.0),
                                                  ),
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                          vertical: 10.0,
                                                          horizontal: 10.0),
                                                ),
                                                autovalidateMode:
                                                    AutovalidateMode
                                                        .onUserInteraction,
                                                validator: (value) =>
                                                    TValidation
                                                        .validateEmptyText(
                                                  "Địa chỉ",
                                                  value,
                                                ),
                                                onEditingComplete: () =>
                                                    TextInput
                                                        .finishAutofillContext(),
                                              ),
                                            ],
                                          ),
                                        ),

                                        // TODO [Input Form/Content/Form/Button]
                                        SizedBox(
                                          height: height * 0.03,
                                        ),
                                        MouseRegion(
                                          cursor: SystemMouseCursors.click,
                                          child: GestureDetector(
                                            onTap: () {
                                              if (globalKey.currentState!
                                                  .validate()) {
                                                if (selectedWard == null) {
                                                  // selectedDistrict =
                                                  //     orderController
                                                  //         .districtList.first;
                                                  selectedWard = orderController
                                                      .wardList.first;
                                                }
                                                if (selectedDistrict == null) {
                                                  selectedDistrict =
                                                      orderController
                                                          .districtList.first;

                                                  selectedWard = orderController
                                                      .wardList.first;
                                                }
                                                showDialogCustom(
                                                    context,
                                                    "Bạn muốn lưu lại các thay đổi",
                                                    _usernameController.text,
                                                    _phoneNumberController.text,
                                                    _addressController.text,
                                                    defaultCity.toString(),
                                                    selectedDistrict.toString(),
                                                    selectedWard.toString(),
                                                    widget.totalOrder);
                                              }
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                color: CustomAppColor
                                                    .primaryColorOrange,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  "Cập nhật",
                                                  style: GoogleFonts.raleway()
                                                      .copyWith(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<dynamic> showDialogCustom(
      BuildContext context,
      String content,
      String userName,
      String phone,
      String address,
      String selectedValueCity,
      String selectedValuedis,
      String selectedValueward,
      int totalOrder) {
    return showCupertinoDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text("Thông báo"),
        content: Text(content),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            child: Text("Hủy"),
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          CupertinoDialogAction(
            child: Text("Đồng ý"),
            onPressed: () {
              orderController.isUpdate(true);

              handleUpdate(userName, phone, address, selectedValueCity,
                  selectedValuedis, selectedValueward, totalOrder);

              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Future<void> handleUpdate(
      String userName,
      String phone,
      String address,
      String selectedValueCity,
      String selectedValuedis,
      String selectedValueward,
      int totalOrder) async {
    String addressNew = getConcatenatedValue(
        selectedValueCity, selectedValuedis, selectedValueward, address);

    var isSuccess = authController.updateInfo(username: userName, phone: phone);
    orderController.addressTmp.value = addressNew;

    if (await isSuccess == 1) {
      SecurityStorage().writeSecureData("username", userName);
      SecurityStorage().writeSecureData("phone", phone);
      SecurityStorage().writeSecureData("address", addressNew);
      getData();
      Object code = TransformCustomApp().getCodeForDeliveryFee(addressNew);
      if (code is Map<String, dynamic>) {
        int toDistrictId = code['toDistrictId'];
        String toWardCode = code['to_ward_code'];
        await orderController.getFee(toDistrictId.toInt(), totalOrder,
            totalOrder, toWardCode.toString());
      } else {
        print("Failed to retrieve delivery fee code.");
      }
      await authController.getProfile();
      Navigator.of(context).pop();
    }
  }

  String getConcatenatedValue(String selectedValueCity, String selectedValuedis,
      String selectedValueward, String addres) {
    String city = selectedValueCity ?? '';
    String district = selectedValuedis ?? '';
    String ward = selectedValueward ?? '';
    String address = addres;

    return '$city-$district-$ward-$address';
  }
}
