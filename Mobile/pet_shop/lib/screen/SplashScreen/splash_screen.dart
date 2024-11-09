import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pet_shop/route/route_generator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation animation;

  @override
  void initState() {
    animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    animation =
        CurvedAnimation(parent: animationController, curve: Curves.easeInOut);

    animation.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });

    animationController.forward();
    super.initState();
    _navigateToNextScreen();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _navigateToNextScreen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // await prefs.remove('onBoard');

    bool? isViewed = prefs.getBool('onBoard');
    await Future.delayed(Duration(seconds: 3)); // Splash screen delay
    if (isViewed != null && isViewed) {
      Navigator.of(context).pushReplacementNamed(Routes.homepage);
    } else {
      Navigator.of(context).pushReplacementNamed(Routes.onBoarding);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        height: size.height,
        width: size.width,
        child: Center(
          child: Image(
            image: AssetImage(
                "assets/images/_project/Plash_Screen/splashscreen-2.png"),
            height: animation.value * 400,
          ),
        ),
      ),
    );
  }
}
