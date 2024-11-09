import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pet_shop/config/constant.dart';
import 'package:pet_shop/config/responsive/responsive_widget.dart';
import 'package:pet_shop/config/secure_storage/security_storage.dart';
import 'package:pet_shop/config/snack_bar_inform/snackbar_custom.dart';
import 'package:pet_shop/config/validators/validation.dart';

import 'package:pet_shop/controllers/Account/auth_controller.dart';
import 'package:pet_shop/models/Account/login_request_model.dart';
import 'package:pet_shop/route/route_generator.dart';
import 'package:pet_shop/servies/Account/account_api_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isAPIcallProcess = false;
  String? username;
  String? password;
  bool _isNotValidate = false;

  //Form
  GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  TextEditingController _userController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  var _isObscured;
  final FocusNode _userFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  @override
  void initState() {
    _isObscured = true;
    super.initState();
  }

  @override
  void dispose() {
    _userController.dispose();
    _passwordController.dispose();
    _userFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                      alignment: Alignment.topRight,
                      child: Image(
                        image: AssetImage(
                            "assets/images/_project/Account/login-dog-2.png"),
                        width: 280,
                      ),
                    ),
                    // Align(
                    //   alignment: Alignment.bottomLeft,
                    //   child: Image(
                    //     image: AssetImage(
                    //         "assets/images/_project/Account/login-dog-1.png"),
                    //     width: 250,
                    //   ),
                    // ),

                    //! [Input Form]
                    Container(
                      margin: EdgeInsets.only(top: 30),
                      child: SingleChildScrollView(
                        // padding: const EdgeInsets.only(bottom: 40),
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
                              child: Container(
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
                                              text: "Chào ",
                                              style: GoogleFonts.raleway()
                                                  .copyWith(
                                                      fontSize: 35.0,
                                                      color: CustomAppColor
                                                          .textColor1,
                                                      fontWeight:
                                                          FontWeight.normal),
                                            ),
                                            TextSpan(
                                              text: "Bạn!",
                                              style: GoogleFonts.raleway()
                                                  .copyWith(
                                                      fontSize: 35.0,
                                                      color: CustomAppColor
                                                          .textColor2,
                                                      fontWeight:
                                                          FontWeight.w800),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: height * 0.01,
                                    ),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Hãy đăng nhập\nvào tài khoản của bạn nhé!',
                                        style: GoogleFonts.raleway().copyWith(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: height * 0.02,
                                    ),

                                    // TODO [Input Form/Content/Form]
                                    Form(
                                      key: globalKey,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              "Email",
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
                                            controller: _userController,
                                            focusNode: _userFocusNode,
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5.0),
                                              ),
                                              hintText: 'Nhập email của bạn',
                                              hintStyle: GoogleFonts.raleway()
                                                  .copyWith(
                                                fontSize: 14.0,
                                                color: CustomAppColor.textColor1
                                                    .withOpacity(0.5),
                                              ),
                                              prefixIcon: Container(
                                                margin: const EdgeInsets.only(
                                                    right: 16.0),
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                decoration: const BoxDecoration(
                                                  border: Border(
                                                    right: BorderSide(
                                                        width: 1.0,
                                                        color: Color(
                                                            0xAAAA000000)),
                                                  ),
                                                ),
                                                child:
                                                    Icon(Icons.email_outlined),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.orange,
                                                    width: 2.0),
                                              ),
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      vertical: 15.0,
                                                      horizontal: 2.0),
                                            ),
                                            keyboardType:
                                                TextInputType.emailAddress,
                                            autofillHints: [
                                              AutofillHints.email
                                            ],
                                            validator: (name) =>
                                                TValidation.validateEmail(name),
                                            autovalidateMode: AutovalidateMode
                                                .onUserInteraction,
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              "Password",
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
                                            controller: _passwordController,
                                            focusNode: _passwordFocusNode,
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5.0),
                                              ),
                                              hintText: 'Nhập Password',
                                              hintStyle: GoogleFonts.raleway()
                                                  .copyWith(
                                                fontSize: 14.0,
                                                color: CustomAppColor.textColor1
                                                    .withOpacity(0.5),
                                              ),
                                              prefixIcon: Container(
                                                margin: const EdgeInsets.only(
                                                    right: 16.0),
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                decoration: const BoxDecoration(
                                                  border: Border(
                                                    right: BorderSide(
                                                        width: 1.0,
                                                        color: Color(
                                                            0xAAAA000000)),
                                                  ),
                                                ),
                                                child: Icon(
                                                    Icons.lock_outline_rounded),
                                              ),
                                              suffixIcon: Padding(
                                                padding:
                                                    const EdgeInsetsDirectional
                                                        .only(end: 12.0),
                                                child: IconButton(
                                                  icon: Icon(
                                                    _isObscured
                                                        ? Icons
                                                            .visibility_outlined
                                                        : Icons
                                                            .visibility_off_outlined,
                                                    color: Color(0xAAAA000000),
                                                  ),
                                                  onPressed: () {
                                                    setState(() {
                                                      _isObscured =
                                                          !_isObscured;
                                                    });
                                                  },
                                                ),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.orange,
                                                    width: 2.0),
                                              ),
                                              contentPadding: EdgeInsets.symmetric(
                                                  vertical: 15.0,
                                                  horizontal:
                                                      2.0), // Điều chỉnh padding để tăng kích thước input
                                            ),
                                            autovalidateMode: AutovalidateMode
                                                .onUserInteraction,
                                            validator: (value) =>
                                                TValidation.validatePassword(
                                                    value),
                                            obscureText: _isObscured,
                                            onEditingComplete: () => TextInput
                                                .finishAutofillContext(),
                                          ),
                                          // TODO [Input Form/Content/Form/Forget Password]
                                          SizedBox(
                                            height: height * 0.001,
                                          ),
                                          Align(
                                            alignment: Alignment.bottomRight,
                                            child: TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pushNamed(
                                                    Routes.forget_password);
                                              },
                                              child: Text(
                                                'Quên mật khẩu?',
                                                textAlign: TextAlign.right,
                                                style: GoogleFonts.raleway()
                                                    .copyWith(
                                                        fontSize: 14.0,
                                                        color: CustomAppColor
                                                            .textColor1,
                                                        fontWeight:
                                                            FontWeight.normal),
                                              ),
                                            ),
                                          ),
                                          // TODO [Input Form/Content/Form/Button]
                                          SizedBox(
                                            height: height * 0.001,
                                          ),
                                          MouseRegion(
                                            cursor: SystemMouseCursors.click,
                                            child: GestureDetector(
                                              onTap: () async {
                                                if (globalKey.currentState!
                                                    .validate()) {
                                                  HandleLogin(
                                                      _userController.text,
                                                      _passwordController.text);
                                                }
                                              },
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                  color: CustomAppColor
                                                      .primaryColorOrange,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    "Đăng Nhập",
                                                    style: GoogleFonts.raleway()
                                                        .copyWith(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          // TODO [Input Form/Content/Form/Social Button]
                                          // SizedBox(
                                          //   height: height * 0.04,
                                          // ),
                                          // Container(
                                          //   margin: EdgeInsets.symmetric(
                                          //       horizontal: 25.0),
                                          //   child: Row(
                                          //     children: [
                                          //       Expanded(
                                          //         child: Divider(
                                          //           thickness: 0.5,
                                          //           color: kTextLightColor,
                                          //         ),
                                          //       ),
                                          //       Padding(
                                          //         padding:
                                          //             const EdgeInsets.symmetric(
                                          //                 horizontal: 10.0),
                                          //         child: Text(
                                          //           'Or Continue with',
                                          //           style: TextStyle(
                                          //               color: Colors.grey),
                                          //         ),
                                          //       ),
                                          //       Expanded(
                                          //         child: Divider(
                                          //           thickness: 0.5,
                                          //           color: Colors.grey,
                                          //         ),
                                          //       ),
                                          //     ],
                                          //   ),
                                          // ),
                                          // SizedBox(
                                          //   height: height * 0.015,
                                          // ),
                                          // Row(
                                          //   mainAxisAlignment:
                                          //       MainAxisAlignment.center,
                                          //   children: [
                                          //     SocialButton(
                                          //         "assets/images/_project/Logo/social/google.png"),
                                          //     SizedBox(
                                          //       width: 10,
                                          //     ),
                                          //     SocialButton(
                                          //         "assets/images/_project/Logo/social/facebook.png"),
                                          //   ],
                                          // ),

                                          // TODO [Input Form/Content/Form/Sign Up]
                                          SizedBox(
                                            height: height * 0.03,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "Chưa có tài khoản? ",
                                                style: GoogleFonts.raleway()
                                                    .copyWith(
                                                  fontSize: 16.0,
                                                  color:
                                                      CustomAppColor.textColor1,
                                                  fontWeight: FontWeight.w200,
                                                ),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .pushReplacementNamed(
                                                          Routes.sign_up);
                                                },
                                                style: TextButton.styleFrom(
                                                  padding: EdgeInsets.zero,
                                                  minimumSize: Size(0, 0),
                                                  tapTargetSize:
                                                      MaterialTapTargetSize
                                                          .shrinkWrap,
                                                ),
                                                child: Text(
                                                  "Đăng ký",
                                                  style: GoogleFonts.raleway()
                                                      .copyWith(
                                                    fontSize: 16.0,
                                                    color: CustomAppColor
                                                        .textColor2,
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
                            ),
                          ],
                        ),
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

  //Render Social Button
  MouseRegion SocialButton(String imgPath) {
    return MouseRegion(
      cursor:
          SystemMouseCursors.click, // Thay đổi con trỏ chuột thành hình bàn tay
      child: GestureDetector(
        onTap: () {},
        child: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: const Color.fromARGB(255, 255, 255, 255)),
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
          ),
          child: Image(
            image: AssetImage(imgPath),
            height: 25,
          ),
        ),
      ),
    );
  }

  //Handle Sign In
  void HandleLogin(String email, String password) async {
    var isSuccessLogin =
        AuthController.instance.login(email: email, password: password);
    if (await isSuccessLogin == 1) {
      Navigator.of(context).pushReplacementNamed(Routes.homepage);
    } else if (await isSuccessLogin == -1) {
      FocusScope.of(context).requestFocus(_passwordFocusNode);
      // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
      // ScaffoldMessenger.of(context).showSnackBar(SnackbarCustom()
      //     .showErorSnackBar(
      //         "Đăng nhập thất bại. Vui lòng kiểm tra lại thông tin."));
    } else if (await isSuccessLogin == -2) {
      FocusScope.of(context).requestFocus(_userFocusNode);
    } else if (await isSuccessLogin == -3) {
      Navigator.of(context).pushNamed(Routes.register_member);
    }
  }
}

// ? Copponent comment
// Container(
//   decoration: BoxDecoration(
//       gradient: LinearGradient(
//           begin: Alignment.topCenter,
//           colors: [
//         backgroundColor1,
//         backgroundColor2,
//         backgroundColor3
//       ])),
// ),
//   ScaffoldMessenger.of(context)
//       .showSnackBar(SnackBar(
//     content: Text("Login failed"),