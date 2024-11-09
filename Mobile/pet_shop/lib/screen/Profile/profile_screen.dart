import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:pet_shop/config/cofig.dart';
import 'package:pet_shop/config/constant.dart';
import 'package:pet_shop/config/secure_storage/security_storage.dart';
import 'package:pet_shop/config/snack_bar_inform/snackbar_custom.dart';
import 'package:pet_shop/controllers/Account/auth_controller.dart';
import 'package:pet_shop/models/Account/user_model.dart';
import 'package:pet_shop/route/route_generator.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthController authController = Get.find<AuthController>();
  bool _enNotification = true;
  String name = "";
  String email = "";
  @override
  void initState() {
    super.initState();

    getData();
  }

  void getData() async {
    var isSuccess = await authController.getProfile();

    var isLogin = await SecurityStorage().readSecureData("token");
    if (isLogin) {
      String fetchedName =
          await SecurityStorage().getSecureData("username") as String;
      setState(() {
        name = fetchedName;
      });
      String fetchedMail =
          await SecurityStorage().getSecureData("email") as String;
      setState(() {
        email = fetchedMail;
      });

      // ! Find Notification
      bool isSetNotification =
          await SecurityStorage().readSecureData("noti_id");
      //is set
      if (isSetNotification) {
        String isReadNotification =
            await SecurityStorage().getSecureData("noti_id");
        if (isReadNotification == "") {
          setState(() {
            _enNotification = false;
          });
        } else if (isReadNotification == "-1") {
          //just init
          setState(() {
            _enNotification = true;
          });
        } else {
          setState(() {
            _enNotification = true;
          });
        }
      }
      //not set => auto true
      else {
        await SecurityStorage().writeSecureData("noti_id", "-1");
        setState(() {
          _enNotification = true;
        });
      }
      config(_enNotification, authController);
    }
    ;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomAppColor.lightBackgroundColor_Home,
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 250,
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        height: 250,
                        // width: MediaQuery.of(context).size.width,
                        // color: Colors.blue,
                        // alignment: Alignment.center,
                        // child: FadeInImage(
                        //   height: double.infinity,
                        //   width: double.infinity,
                        //   fit: BoxFit.cover,
                        //   placeholder:
                        //       AssetImage('assets/images/_project/Logo/logo.png'),
                        //   image: NetworkImage("userInfo.image"),
                        //   imageErrorBuilder: (context, error, stackTrace) =>
                        //       Image.asset(
                        //     'assets/images/_project/Logo/logo.png',
                        //     fit: BoxFit.cover,
                        //   ),
                        // ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 70),
                      child: Align(
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            GestureDetector(
                              onTap: () async {},
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border:
                                      Border.all(color: Colors.white, width: 1),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(300),
                                  child: SizedBox(
                                    height: 100,
                                    width: 100,
                                    child: FadeInImage(
                                      fit: BoxFit.cover,
                                      placeholder: AssetImage(
                                          'assets/images/_project/Logo/logo.png'),
                                      image: NetworkImage("userInfo.image"),
                                      imageErrorBuilder:
                                          (context, error, stackTrace) =>
                                              Image.asset(
                                        'assets/images/_project/Logo/logo.png',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Obx(() {
                              return Text(
                                authController.user.value?.username ?? name,
                                style: const TextStyle(
                                    color: Color(0xff04236c),
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600),
                              );
                            }),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin:
                          const EdgeInsets.only(top: 20, left: 20, bottom: 5),
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        "Settings",
                        style: TextStyle(
                          fontSize: 13,
                          // fontWeight: FontWeight.bold,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                    Container(
                      decoration: const BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Colors.white),
                      child: Column(children: <Widget>[
                        ExpansionTile(
                          trailing: Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.black26,
                            size: 27,
                          ),
                          title: _buildSelectionSetting(
                              Icons.person, "User Profile", null, null),
                          children: [
                            Container(
                              margin: const EdgeInsets.only(top: 8),
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Colors.black,
                                ),
                              ),
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    padding: const EdgeInsets.all(8.0),
                                    decoration: const BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                color: Colors.black))),
                                    child: GestureDetector(
                                      onTap: () async {
                                        Navigator.of(context)
                                            .pushNamed(Routes.updateProfile);
                                      },
                                      child: ListTile(
                                        title: const Text(
                                          'Thông tin cá nhân',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xff1b2794)),
                                        ),
                                        subtitle: Text(
                                          "Chỉnh sửa",
                                          style: const TextStyle(
                                              color: Color(0xff2c38a4)),
                                        ),
                                        trailing:
                                            const Icon(Icons.navigate_next),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return const SimpleDialog(
                                            backgroundColor: Colors.white,
                                            insetPadding: EdgeInsets.all(15),
                                            title: Text(
                                              'Thay đổi mật khẩu',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            children: [UpdatePasswordForm()],
                                          );
                                        },
                                      );
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(8.0),
                                      child: const ListTile(
                                        title: Text(
                                          'Mật khẩu',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xff1b2794)),
                                        ),
                                        trailing: Icon(Icons.navigate_next),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 32,
                            ),
                          ],
                        ),

                        //todo [Notification]
                        const Divider(
                            height: 0,
                            endIndent: 25,
                            indent: 5,
                            thickness: 0.1,
                            color: Colors.black),
                        ListTile(
                          contentPadding: EdgeInsets.all(15),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.notifications,
                                      color: Colors.black38),
                                  const SizedBox(width: 10),
                                  Text(
                                    "Thông báo",
                                    style: const TextStyle(
                                      fontSize: 15,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              CupertinoSwitch(
                                value: _enNotification,
                                onChanged: (value) async {
                                  setState(() {
                                    _enNotification = value;
                                  });
                                  _handleNotification(
                                      _enNotification, authController);
                                },
                              ),
                            ],
                          ),
                        ),
                        const Divider(
                            height: 0,
                            endIndent: 25,
                            indent: 5,
                            thickness: 0.1,
                            color: Colors.black),
                        GestureDetector(
                          onTap: () async {
                            var isLogOut = authController.logout();
                            if (await isLogOut) {
                              Navigator.of(context)
                                  .pushReplacementNamed(Routes.homepage);
                            }
                          },
                          child: _buildSelectionSetting(Icons.logout,
                              "Sign out", null, Icons.arrow_forward_ios),
                        ),
                      ]),
                    ),
                    Container(
                      margin:
                          const EdgeInsets.only(top: 20, left: 20, bottom: 5),
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        "About Us",
                        style: TextStyle(
                          fontSize: 13,
                          // fontWeight: FontWeight.bold,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                    Container(
                        decoration: const BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            color: Colors.white),
                        child: Column(children: <Widget>[
                          _buildSelectionSetting(Icons.info_outline,
                              "Information", null, Icons.arrow_forward_ios),
                        ])),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSelectionSetting(
      IconData icon, String name, String? selection, IconData? postIcon) {
    if (postIcon != null) {
      return ListTile(
        contentPadding: EdgeInsets.all(15),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.black38),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  name,
                  style: const TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
            Row(
              children: [
                Text(selection ?? "",
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.black54,
                    )),
                const SizedBox(
                  width: 10,
                ),
                Icon(
                  postIcon,
                  color: Colors.black26,
                  size: 15,
                ),
              ],
            )
            // DropdownButton(items: language, onChanged: null)
          ],
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(right: 20, top: 20, bottom: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.black38),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  name,
                  style: const TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
            Row(
              children: [
                Text(selection ?? "",
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.black54,
                    )),
                const SizedBox(
                  width: 10,
                ),
              ],
            )
            // DropdownButton(items: language, onChanged: null)
          ],
        ),
      );
    }
  }
}

//!!!!!!!!!!!!!!!!!!!!!!!-------Notification-------!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
void config(bool value, AuthController authController) async {
  if (value) {
    //todo create
    // OneSignal.initialize(Config.oneSignalApp);

    //todo get id
    var onesignalId = await OneSignal.User.getOnesignalId();
    SecurityStorage().writeSecureData("noti_id", onesignalId.toString());

    await OneSignal.Notifications.requestPermission(true);
    await OneSignal.User.pushSubscription.optIn();

    //todo add device
    await authController.addDevice(id_device: onesignalId);

    // OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
    // Login to OneSignal (if needed)
    // await OneSignal.login(onesignalId);
  } else {
    //todo log out
    await OneSignal.User.pushSubscription.optOut();

    //todo add device
    await authController.addDevice(id_device: "");
    SecurityStorage().writeSecureData("noti_id", "");

    // (might not be necessary if opting out)
    // await OneSignal.Notifications.requestPermission(false);
    // Logout from OneSignal
    // await OneSignal.logout();
    // Clear all notifications
    // await OneSignal.Notifications.clearAll();
  }
}

//todo [Handle Notification]
void _handleNotification(
    bool enNotification, AuthController authController) async {
  config(enNotification, authController);
}

class UpdatePasswordForm extends StatefulWidget {
  const UpdatePasswordForm({Key? key}) : super(key: key);

  @override
  State<UpdatePasswordForm> createState() => _UpdatePasswordFormState();
}

class _UpdatePasswordFormState extends State<UpdatePasswordForm> {
  final AuthController authController = Get.find<AuthController>();

  final _formKey = GlobalKey<FormState>();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController renewPasswordController = TextEditingController();
  String? oldPassword;
  String error = '';

  @override
  void dispose() {
    newPasswordController.dispose();
    renewPasswordController.dispose();
    super.dispose();
  }

  static String? validatePassword(String? value) {
    value = value?.trim();
    if (value == null || value.isEmpty) {
      return 'Mật khẩu không được để trống';
    }

    if (value.length < 6) {
      return 'Phải có độ dài ít nhất là 6';
    }

    if (!value.contains(RegExp(r'[A-Z]'))) {
      return "Phải chứa ký tự in hoa";
    }

    if (!value.contains(RegExp(r'[0-9]'))) {
      return "Phải chứa ít nhất một chữ số";
    }

    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return "Phải chứa ký tự đặc biệt";
    }

    // Kiểm tra nếu có khoảng trắng
    if (value.contains(RegExp(r'\s'))) {
      return "không được chứa dấu cách";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Form(
        key: _formKey,
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.75,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                decoration: const InputDecoration(
                    labelText: 'Password',
                    labelStyle: TextStyle(color: Colors.grey)),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập';
                  }
                  return null;
                },
                onSaved: (newValue) {
                  oldPassword = newValue;
                },
              ),
              TextFormField(
                controller: newPasswordController,
                decoration: const InputDecoration(
                    labelText: 'Mật khẩu mới',
                    labelStyle: TextStyle(color: Colors.grey)),
                validator: validatePassword,
                onSaved: (newValue) {
                  // No need to save here as we use the controller
                },
              ),
              TextFormField(
                controller: renewPasswordController,
                decoration: const InputDecoration(
                    labelText: 'Xác nhận mật khẩu',
                    labelStyle: TextStyle(color: Colors.grey)),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập';
                  }
                  if (value.trim() != newPasswordController.text.trim()) {
                    return 'Xác thực không đúng';
                  }
                  return null;
                },
                onSaved: (newValue) {
                  // No need to save here as we use the controller
                },
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () async {
                          if (_formKey.currentState?.validate() == true) {
                            _formKey.currentState?.save();
                            HandleUpdatePassword(
                                newPasswordController.text, oldPassword!);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: CustomAppColor.primaryColorOrange,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              "Cập nhật",
                              style: GoogleFonts.raleway().copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Expanded(
                  //   child: ElevatedButton(
                  //     onPressed: () {
                  //       if (_formKey.currentState?.validate() == true) {
                  //         _formKey.currentState?.save();
                  //         HandleUpdatePassword(
                  //             newPasswordController.text, oldPassword!);
                  //       }
                  //     },
                  //     style: ElevatedButton.styleFrom(
                  //         backgroundColor: Colors.blue,
                  //         padding: const EdgeInsets.all(16)),
                  //     child: const Text(
                  //       'Cập nhật',
                  //       style: TextStyle(color: Colors.white),
                  //     ),
                  //   ),
                  // )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Center(
                child: Text(
                  error,
                  style: const TextStyle(color: Colors.red, fontSize: 14),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void HandleUpdatePassword(String newPassword, String oldPassword) {
    var isSuccess = authController.updatePassword(
        oldPassword: oldPassword, newPassword: newPassword);
    // Handle success or error
  }
}
