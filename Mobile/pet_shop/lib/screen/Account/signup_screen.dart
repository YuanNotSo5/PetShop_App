import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:pet_shop/config/cofig.dart';
import 'package:pet_shop/controllers/Account/auth_controller.dart';
import 'package:pet_shop/route/route_generator.dart';
import 'package:pet_shop/screen/Account/login_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pet_shop/config/cofig.dart';
import 'package:pet_shop/config/constant.dart';
import 'package:pet_shop/config/responsive/responsive_widget.dart';
import 'package:pet_shop/config/validators/validation.dart';

import 'package:http/http.dart' as http;

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  AuthController authController = Get.find<AuthController>();

  //Form
  GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  TextEditingController _userController = TextEditingController();
  final FocusNode _userFocusNode = FocusNode();

  @override
  void dispose() {
    // Dispose controllers
    _userController.dispose();

    // Dispose focus nodes
    _userFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Get.put(AuthController());

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SizedBox(
        height: height,
        width: width,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ResponsiveWidget.isSmallScreen(context)
                ? const SizedBox()
                : Expanded(
                    child: Container(
                      height: height,
                      color: Colors.blue,
                      child: Center(
                        child: Text(
                          "AdminExpress",
                          style: GoogleFonts.raleway().copyWith(
                              fontSize: 48,
                              color: Colors.white,
                              fontWeight: FontWeight.w800),
                        ),
                      ),
                    ),
                  ),
            Expanded(
              child: Container(
                height: height,
                color: Colors.amber,
                child: Stack(
                  children: [
                    // ! [Image Decoration]
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Image(
                        image: AssetImage(
                            "assets/images/_project/Account/dog_sunglasses.png"),
                        width: 300,
                      ),
                    ),

                    //! [Input Form]
                    SingleChildScrollView(
                      padding: const EdgeInsets.only(bottom: 40),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: height * 0.2,
                          ),

                          // ? [Input Form/Content]
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal:
                                    ResponsiveWidget.isSmallScreen(context)
                                        ? height * 0.032
                                        : height * 0.12),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                // TODO [Input Form/Content/Intro Text]
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: "",
                                          style: GoogleFonts.raleway().copyWith(
                                              fontSize: 35.0,
                                              color: CustomAppColor.textColor1,
                                              fontWeight: FontWeight.normal),
                                        ),
                                        TextSpan(
                                          text: "Welcome!",
                                          style: GoogleFonts.raleway().copyWith(
                                              fontSize: 35.0,
                                              color: CustomAppColor.textColor2,
                                              fontWeight: FontWeight.w800),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: height * 0.02,
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Vui lòng nhập mã kích hoạt, để có thể sử dụng tài khoản của bạn. Mã kích hoạt ở hòm thư Email của bạn. Nếu không tìm thấy vui lòng kiểm tra mục Spam',
                                    style: GoogleFonts.raleway().copyWith(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: height * 0.034,
                                ),

                                // TODO [Input Form/Content/Form]
                                Form(
                                  key: globalKey,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          "Mã kích hoạt của bạn",
                                          style: GoogleFonts.raleway().copyWith(
                                              fontSize: 16.0,
                                              color: CustomAppColor.textColor1,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 6.0,
                                      ),
                                      TextFormField(
                                        maxLength: 6,
                                        controller: _userController,
                                        focusNode: _userFocusNode,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                          ),
                                          hintText: 'Nhập mã kích hoạt',
                                          prefixIcon: Container(
                                            margin: const EdgeInsets.only(
                                                right: 16.0),
                                            padding: const EdgeInsets.all(10.0),
                                            decoration: const BoxDecoration(
                                              border: Border(
                                                right: BorderSide(
                                                    width: 1.0,
                                                    color: Color(0xAAAA000000)),
                                              ),
                                            ),
                                            child:
                                                Icon(Icons.qr_code_2_outlined),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.orange,
                                                width: 2.0),
                                          ),
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 20.0, horizontal: 10.0),
                                        ),
                                        autofillHints: [AutofillHints.username],
                                        keyboardType: TextInputType.name,
                                        validator: (name) {
                                          if (name == null ||
                                              name.length != 6) {
                                            return 'Name must be exactly 6 characters long';
                                          }
                                          return null;
                                        },
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                      ),

                                      // Row(
                                      //   mainAxisAlignment:
                                      //       MainAxisAlignment.start,
                                      //   crossAxisAlignment:
                                      //       CrossAxisAlignment.start,
                                      //   children: [
                                      //     Flexible(
                                      //       child: Container(
                                      //         height: 56,
                                      //         // width: 50,
                                      //         margin: EdgeInsets.fromLTRB(
                                      //             0, 10, 3, 30),
                                      //         decoration: BoxDecoration(
                                      //           borderRadius:
                                      //               BorderRadius.circular(4),
                                      //           border: Border.all(
                                      //               color: Colors.grey),
                                      //         ),
                                      //         child: Center(
                                      //           child: Text(
                                      //             "+84",
                                      //             style: TextStyle(
                                      //                 color: Colors.black,
                                      //                 fontWeight:
                                      //                     FontWeight.bold),
                                      //           ),
                                      //         ),
                                      //       ),
                                      //     ),
                                      //     Flexible(
                                      //       flex: 6,
                                      //       child: Container(
                                      //         margin: EdgeInsets.fromLTRB(
                                      //             3, 10, 0, 0),
                                      //         child:
                                      //             // TextFormField(
                                      //             //   maxLines: 1,
                                      //             //   maxLength: 10,
                                      //             //   decoration: InputDecoration(
                                      //             //     contentPadding:
                                      //             //         EdgeInsets.all(6),
                                      //             //     hintText: "Mobile Phone",
                                      //             //     enabledBorder:
                                      //             //         OutlineInputBorder(
                                      //             //       borderSide: BorderSide(
                                      //             //           color: Colors.grey,
                                      //             //           width: 1),
                                      //             //     ),
                                      //             //     border: OutlineInputBorder(
                                      //             //       borderSide: BorderSide(
                                      //             //           color: Colors.grey,
                                      //             //           width: 1),
                                      //             //     ),
                                      //             //     focusedBorder:
                                      //             //         OutlineInputBorder(
                                      //             //       borderSide: BorderSide(
                                      //             //           color: Colors.blue,
                                      //             //           width: 1),
                                      //             //     ),
                                      //             //   ),
                                      //             //   keyboardType:
                                      //             //       TextInputType.number,
                                      //             // ),
                                      //             TextFormField(
                                      //           maxLength: 10,
                                      //           controller: _userController,
                                      //           focusNode: _userFocusNode,
                                      //           decoration: InputDecoration(
                                      //             border: OutlineInputBorder(
                                      //               borderRadius:
                                      //                   BorderRadius.circular(
                                      //                       5.0),
                                      //             ),
                                      //             hintText:
                                      //                 'Enter phone number',
                                      //             focusedBorder:
                                      //                 OutlineInputBorder(
                                      //               borderSide: BorderSide(
                                      //                   color: Colors.orange,
                                      //                   width: 2.0),
                                      //             ),
                                      //             contentPadding:
                                      //                 EdgeInsets.symmetric(
                                      //                     vertical: 20.0,
                                      //                     horizontal: 10.0),
                                      //           ),
                                      //           keyboardType:
                                      //               TextInputType.number,
                                      //           // validator: (name) => TValidation
                                      //           //     .validatePhoneNumber(name),
                                      //           autovalidateMode:
                                      //               AutovalidateMode
                                      //                   .onUserInteraction,
                                      //         ),
                                      //       ),
                                      //     )
                                      //   ],
                                      // ),

                                      SizedBox(
                                        height: height * 0.009,
                                      ),
                                      // TODO [Input Form/Content/Form/Button]
                                      SizedBox(
                                        height: height * 0.01,
                                      ),
                                      MouseRegion(
                                        cursor: SystemMouseCursors
                                            .click, // Thay đổi con trỏ chuột thành hình bàn tay
                                        child: GestureDetector(
                                          onTap: () {
                                            if (globalKey.currentState!
                                                .validate()) {
                                              HandleActivate(
                                                  _userController.text);
                                            }
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.all(16),
                                            decoration: BoxDecoration(
                                              color: CustomAppColor
                                                  .primaryColorOrange,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Center(
                                              child: Text(
                                                "Đăng ký",
                                                style: GoogleFonts.raleway()
                                                    .copyWith(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      // TODO [Input Form/Content/Form/Sign In]
                                      SizedBox(
                                        height: height * 0.03,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Đã có tài khoản? ",
                                            style:
                                                GoogleFonts.raleway().copyWith(
                                              fontSize: 16.0,
                                              color: CustomAppColor.textColor1,
                                              fontWeight: FontWeight.w200,
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context)
                                                  .pushReplacementNamed(
                                                      Routes.sign_in);
                                            },
                                            style: TextButton.styleFrom(
                                              padding: EdgeInsets.zero,
                                              minimumSize: Size(0, 0),
                                              tapTargetSize:
                                                  MaterialTapTargetSize
                                                      .shrinkWrap,
                                            ),
                                            child: Text(
                                              "Đăng nhập",
                                              style: GoogleFonts.raleway()
                                                  .copyWith(
                                                fontSize: 16.0,
                                                color:
                                                    CustomAppColor.textColor2,
                                                fontWeight: FontWeight.w800,
                                              ),
                                            ),
                                          ),
                                        ],
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
    );
  }

  //Handle Activate
  void HandleActivate(String activateCode) async {
    var activeStatus = authController.activateAcc(activationCode: activateCode);
    switch (await activeStatus) {
      case 1:
        Navigator.of(context).pushReplacementNamed(Routes.sign_in);
        break;
      case 0:
        break;
      default:
        break;
    }
  }
}
