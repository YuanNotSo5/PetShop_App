import 'dart:io';
import 'dart:typed_data';

import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pet_shop/config/constant.dart';
import 'package:pet_shop/config/secure_storage/security_storage.dart';
import 'package:pet_shop/controllers/Account/auth_controller.dart';
import 'package:pet_shop/controllers/Order/order_controller.dart';
import 'package:pet_shop/controllers/Predict/predict_controller.dart';
import 'package:pet_shop/controllers/Product/cart_controller.dart';
import 'package:pet_shop/controllers/Product/product_controller.dart';
import 'package:pet_shop/models/ModelPredict/model_product.dart';
import 'package:pet_shop/route/route_generator.dart';
import 'package:pet_shop/screen/CartAndPayment/cart_screen.dart';
import 'package:pet_shop/screen/Home/home_screen.dart';
import 'package:pet_shop/screen/Order/order_screen.dart';
import 'package:pet_shop/screen/Profile/FavScreen/favorite_screen.dart';
import 'package:pet_shop/screen/Profile/profile_screen.dart';
import 'package:oktoast/oktoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pet_shop/servies/ModelPredict/predict_service.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({Key? key}) : super(key: key);

  @override
  _NavigationScreenState createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  ProductController productController = Get.find<ProductController>();
  OrderController orderController = Get.find<OrderController>();
  AuthController authController = Get.find<AuthController>();

  int pageIndex = 0;
  //todo [Predict]
  String isImageUploaded = "";
  bool isLoading = false;
  final ImagePicker picker = ImagePicker();

  List<Widget> pages = [
    HomeScreen(),
    // CartScreen(),
    OrderScreen(),
    FavoriteScreen(),
    ProfileScreen(),
  ];

  //Pick and Take options
  Uint8List? _image;
  File? selectedIMage;
  void _onItemTapped(int index) async {
    // if (index != 0 && AuthController.instance.isLogin == false) {
    if (index != 0 &&
        await SecurityStorage().readSecureData("token") == false) {
      Navigator.of(context).pushNamed(Routes.sign_in);
    } else {
      setState(
        () {
          pageIndex = index;
          productController.getAllFavoriteProduct();
          orderController.getAllStatusOrder();
          authController.getProfile();
        },
      );
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: pageIndex,
        children: pages,
      ),
      floatingActionButton: SafeArea(
        child: FloatingActionButton(
          // todo: [Scan dog action]
          onPressed: () {
            showImagePickerOption(context);
          },
          child: Icon(
            Icons.qr_code,
            size: 20,
            color: Colors.white,
          ),
          backgroundColor: CustomAppColor.primaryRedColor,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar(
        height: 60,
        shadow: Shadow(
          color: Colors.black.withOpacity(0.2),
          offset: Offset(0, 4),
          blurRadius: 10,
        ),
        icons: [
          CupertinoIcons.house_alt_fill,
          CupertinoIcons.rectangle_on_rectangle_angled,
          CupertinoIcons.heart_fill,
          CupertinoIcons.profile_circled,
        ],
        inactiveColor: Colors.black.withOpacity(0.5),
        activeColor: Color(0xFFDB3022),
        gapLocation: GapLocation.center,
        activeIndex: pageIndex,
        notchSmoothness: NotchSmoothness.softEdge,
        leftCornerRadius: 10,
        iconSize: 25,
        rightCornerRadius: 10,
        elevation: 0,
        onTap: _onItemTapped,
      ),
    );
  }

  // todo: [Check Permission]
  checkpermission_opencamera() async {
    var cameraStatus = await Permission.camera.status;
    // ! Instruction
    //cameraStatus.isGranted == has access to application
    //cameraStatus.isDenied == does not have access to application, you can request again for the permission.
    //cameraStatus.isPermanentlyDenied == does not have access to application, you cannot request again for the permission.
    //cameraStatus.isRestricted == because of security/parental control you cannot use this permission.
    //cameraStatus.isUndetermined == permission has not asked before.

    if (!cameraStatus.isGranted) await Permission.camera.request();

    if (await Permission.camera.isGranted) {
      _pickImageFromCamera();
    } else {
      showToast("Provide Camera permission to use camera.",
          position: ToastPosition.bottom);
    }
  }

  check_gallerry_permission() async {
    if (await Permission.storage.request().isGranted) {
      _pickImageFromGallery();
    } else {
      print('No permission provided');
    }
  }

  void openCamera() {
    Navigator.of(context).pushNamed(Routes.scanner);
  }

  // todo [Options pick]
  void showImagePickerOption(BuildContext context) {
    showModalBottomSheet(
        backgroundColor: Colors.white,
        context: context,
        builder: (builder) {
          return Padding(
            padding: const EdgeInsets.only(left: 18.0, right: 18.0),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 4.5,
              child: Row(
                children: [
                  IconPicker(
                    check_gallerry_permission,
                    // _pickImageFromGallery,
                    Text("Gallery"),
                    Icons.image,
                  ),
                  IconPicker(
                    checkpermission_opencamera,
                    Text("Camera"),
                    Icons.camera_alt_rounded,
                  ),
                ],
              ),
            ),
          );
        });
  }

  Expanded IconPicker(void Function() function, Text named, IconData icon) {
    return Expanded(
      child: InkWell(
        onTap: () {
          function();
        },
        child: SizedBox(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 65,
                color: Colors.black,
              ),
              named, // Sử dụng Text widget đã được truyền vào
            ],
          ),
        ),
      ),
    );
  }

  //todo [Pick Action]
  //Gallery
  Future _pickImageFromGallery() async {
    // final returnImage = await ImagePicker()
    //     .pickImage(source: ImageSource.gallery, imageQuality: 50);
    // if (returnImage == null) return;
    // setState(() {
    //   selectedIMage = File(returnImage.path);
    //   _image = File(returnImage.path).readAsBytesSync();
    // });
    // Navigator.of(context).pop();

    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      // Uint8List bytes = await image.readAsBytes();
      Navigator.of(context).pushNamed(Routes.pred_list, arguments: image);
    } else {
      print("Error _pickImage");
    }
  }

  //Camera
  Future _pickImageFromCamera() async {
    // final returnImage =
    //     await ImagePicker().pickImage(source: ImageSource.camera);
    // if (returnImage == null) return;
    // setState(() {
    //   selectedIMage = File(returnImage.path);
    //   _image = File(returnImage.path).readAsBytesSync();
    // });
    // Navigator.of(context).pop();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      Navigator.of(context).pushNamed(Routes.pred_list, arguments: image);
    }
  }
}
