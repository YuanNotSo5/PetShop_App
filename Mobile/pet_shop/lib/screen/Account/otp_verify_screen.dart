import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pet_shop/controllers/Account/auth_controller.dart';
import 'package:pet_shop/screen/Account/recovery_screen.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:sms_otp_auto_verify/sms_otp_auto_verify.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:pet_shop/config/cofig.dart';
import 'package:pet_shop/route/route_generator.dart';
import 'package:pet_shop/screen/Account/login_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pet_shop/config/cofig.dart';
import 'package:pet_shop/config/constant.dart';
import 'package:pet_shop/config/responsive/responsive_widget.dart';
import 'package:pet_shop/config/validators/validation.dart';

import 'package:http/http.dart' as http;

class OtpVerifyScreen extends StatefulWidget {
  final String email;
  const OtpVerifyScreen({Key? key, required this.email}) : super(key: key);

  @override
  _OtpVerifyScreenState createState() => _OtpVerifyScreenState();
}

class _OtpVerifyScreenState extends State<OtpVerifyScreen> {
  AuthController authController = Get.find<AuthController>();
  BoxDecoration get _pinPutDecoration {
    return BoxDecoration(
      border: Border.all(color: Theme.of(context).primaryColor),
      borderRadius: BorderRadius.circular(10.0),
    );
  }

  TextEditingController textEditingController =
      new TextEditingController(text: "");
  GlobalKey<FormState> globalKey = GlobalKey<FormState>();

  //? Verification

  // * custom otp ui
  String _otpCode = "";
  final int _otpCodeLength = 4;

  Timer? _timer;
  int _fixTime = 300;
  int _countDown = 300;

  bool canResend = false;
  late FocusNode myFocusNode;
  Key _pinFieldKey = UniqueKey();
  // String phoneNumber = "ngxuannhu1@gmail.com";

  // * Check times - each turn 3 min
  DateTime? _lastResendTime;
  final Duration _resendCooldown = Duration(minutes: 3); // 3 phút cooldown

  //todo [Count Time]
  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_countDown > 0) {
          _countDown--;
        } else {
          canResend = true;
          _timer?.cancel();
        }
      });
    });
  }

  void _resendOTP() {
    final now = DateTime.now();

    if (_lastResendTime == null ||
        now.difference(_lastResendTime!) > _resendCooldown) {
      setState(() {
        _countDown = _fixTime;
        canResend = false;

        _otpCode = '';
        _pinFieldKey = UniqueKey();
      });

      _lastResendTime = now;
      startTimer();
    } else {
      // Thông báo cho người dùng rằng họ đã gửi yêu cầu quá nhiều lần
      final remainingTime = _resendCooldown - now.difference(_lastResendTime!);
      final minutes = remainingTime.inMinutes;
      final seconds = remainingTime.inSeconds % 60;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Bạn đang thao tác quá nhanh. Vui lòng chờ ${minutes}m ${seconds}s thực hiện lại.'),
        ),
      );
    }
  }

  @override
  void initState() {
    startTimer();
    myFocusNode = FocusNode();
    myFocusNode.requestFocus();

    // SmsAutoFill().listenForCode.call();
    super.initState();
  }

  @override
  void dispose() {
    textEditingController.dispose();

    _timer!.cancel();
    // SmsAutoFill().unregisterListener();
    myFocusNode.dispose();
    super.dispose();
  }

  void _showInvalidOtpDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Mã OTP không hợp lệ'),
          content: const Text('Mã bạn nhập không chính xác.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _resendOTP();
              },
              child: const Text('Resend OTP'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    bool isButtonEnabled = _otpCode.length == _otpCodeLength && _countDown > 0;

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
                    // Align(
                    //   alignment: Alignment.bottomLeft,
                    //   child: Image(
                    //     image: AssetImage(
                    //         "assets/images/_project/Account/corgi_dog.png"),
                    //     width: 250,
                    //   ),
                    // ),

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
                                          text: "Mã xác thực",
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
                                    'Mã xác thực đã được gửi tới ',
                                    style: GoogleFonts.raleway().copyWith(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: height * 0.009,
                                ),
                                // Row(
                                //   children: [],
                                // ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    widget.email,
                                    style: TextStyle(
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
                                      Container(
                                        height: 80,
                                        child: PinFieldAutoFill(
                                          key: _pinFieldKey,
                                          currentCode: _otpCode,
                                          codeLength: _otpCodeLength,
                                          onCodeChanged: (code) {
                                            setState(() {
                                              _otpCode = code ?? '';
                                            });
                                            if (code?.length ==
                                                _otpCodeLength) {
                                              FocusScope.of(context)
                                                  .requestFocus(FocusNode());
                                            }
                                          },
                                          decoration: BoxLooseDecoration(
                                            textStyle: TextStyle(
                                              fontSize: 20,
                                              color: Colors.black,
                                            ),
                                            strokeColorBuilder:
                                                FixedColorBuilder(
                                              const Color.fromARGB(
                                                      31, 179, 19, 19)
                                                  .withOpacity(0.3),
                                            ),
                                            gapSpace: 13,
                                          ),
                                        ),
                                      ),

                                      //TODO[Input Form/Content/Form/Resend and Timer]
                                      SizedBox(
                                        height: height * 0.017,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            '${(_countDown ~/ 60).toString().padLeft(2, '0')}:${(_countDown % 60).toString().padLeft(2, '0')}',
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                "Chưa nhận email? ",
                                                style: TextStyle(
                                                    color: Colors.grey),
                                              ),
                                              canResend
                                                  ? InkWell(
                                                      onTap: () {
                                                        _resendOTP();
                                                        HandleResend(
                                                            widget.email);
                                                      },
                                                      child: Text("Gửi lại"),
                                                    )
                                                  : Text(
                                                      "Gửi lại",
                                                      style: TextStyle(
                                                          color: Colors.grey),
                                                    )
                                            ],
                                          )
                                        ],
                                      ),

                                      // TODO [Input Form/Content/Form/Button]
                                      SizedBox(
                                        height: height * 0.01,
                                      ),

                                      MouseRegion(
                                        cursor: isButtonEnabled
                                            ? SystemMouseCursors.click
                                            : SystemMouseCursors.forbidden,
                                        child: GestureDetector(
                                          onTap: isButtonEnabled
                                              ? () {
                                                  if (globalKey.currentState!
                                                      .validate()) {
                                                    HandleSubmitOTP(
                                                        widget.email, _otpCode);
                                                  }
                                                }
                                              : null,
                                          child: Container(
                                            padding: const EdgeInsets.all(16),
                                            decoration: BoxDecoration(
                                              color: isButtonEnabled
                                                  ? CustomAppColor
                                                      .primaryColorOrange
                                                  : Colors.grey,
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

  //Handle Resend Email
  void HandleResend(String email) async {
    var statusOtp = authController.getOTP(email: email);
    switch (await statusOtp) {
      case 1:
        // Navigator.of(context).pushNamed(Routes.otp_verified, arguments: email);
        break;
      case 0:
        break;
      case -1:
        break;
      case -2:
        Navigator.of(context).pushNamed(Routes.register_member);
        break;
      case -3:
        break;
      default:
    }
  }

  //Handle Submit OTP
  void HandleSubmitOTP(String email, String code) async {
    var authStatus = authController.verifyOTP(email: email, otp: code);
    switch (await authStatus) {
      case 1:
        Navigator.of(context)
            .pushReplacementNamed(Routes.recovery_password, arguments: email);
        break;
      case 0:
        break;
      case -1:
        break;
      case -2:
        break;
      default:
        break;
    }
  }
}
