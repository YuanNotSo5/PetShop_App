import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:oktoast/oktoast.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pet_shop/config/cofig.dart';
import 'package:pet_shop/config/secure_storage/security_storage.dart';

import 'src/app.dart';
import 'src/settings/settings_controller.dart';
import 'src/settings/settings_service.dart';

List<CameraDescription> cameras = [];
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // cameras = await availableCameras();
  await Hive.initFlutter();
  OneSignal.initialize(Config.oneSignalApp);

  // Set up the SettingsController,  which will glue user settings to multiple
  // Flutter Widgets.
  // Lock the app orientation to portrait only
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  // !!!!! Setting notification
  final settingsController = SettingsController(SettingsService());
  // Load the user's preferred the  me while the splash screen is displayed.
  // This prevents a sudden theme change when the app is first displayed.
  await settingsController.loadSettings();
  // config();
  //Transparent battery bar
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.transparent));

  // Run the app and pass in the SettingsController. The app listens to the
  // SettingsController for changes, then passes it further down to the
  // SettingsView.
  // !loading
  confidLoading();
  runApp(MyApp(settingsController: settingsController));
}

//todo Handle Notification Permission
void checkNotiPermission() async {
  var notiStatus = await Permission.notification.status;
  if (!notiStatus.isGranted) await Permission.notification.request();
  if (await Permission.notification.isGranted) {
  } else {
    showToast(
      "Bạn chưa cấp quyền để thực hiện việc gọi",
      position: ToastPosition.bottom,
    );
  }
}
