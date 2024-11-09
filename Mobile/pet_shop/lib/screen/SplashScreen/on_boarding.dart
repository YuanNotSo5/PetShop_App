import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:pet_shop/config/constant.dart';
import 'package:pet_shop/route/route_generator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnBoarding extends StatefulWidget {
  const OnBoarding({Key? key}) : super(key: key);

  @override
  _OnBoardingState createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  final _introKey = GlobalKey<IntroductionScreenState>();
  int _currentPage = 0;

  final pageDecoration = PageDecoration(
    titleTextStyle: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w700,
    ),
    bodyTextStyle: TextStyle(
      fontSize: 16,
    ),
    bodyPadding: EdgeInsets.fromLTRB(16, 0, 16, 16),
    pageColor: Colors.white,
    imagePadding: EdgeInsets.zero,
  );

  @override
  void initState() {
    super.initState();
    _storeOnBoardInfo();
  }

  _storeOnBoardInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onBoard', true);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 25),
      child: IntroductionScreen(
        key: _introKey,
        globalBackgroundColor: Colors.white,
        globalHeader: Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: const EdgeInsets.only(top: 16, right: 16),
            child: _currentPage < 1
                ? TextButton(
                    onPressed: () {
                      _introKey.currentState?.skipToEnd();
                    },
                    child: const Text("Bỏ qua",
                        style: TextStyle(color: Colors.black)),
                  )
                : SizedBox.shrink(), // Hide the button on the last page
          ),
        ),
        pages: [
          PageViewModel(
            title: "Xin Chào!",
            body:
                "Chúng tôi là PetShop. Nơi cung cấp cho bạn các dịch vụ chất lượng nhất dành cho thú cưng!",
            image: Image.asset(
              "assets/images/_project/On_Boarding/on_boarding_1.jpg",
              width: 450,
            ),
            decoration: pageDecoration,
          ),
          PageViewModel(
            title: "Hãy trải nghiệm!",
            body: "Chúng tôi hy vọng có thể mang đến sự hài lòng cho bạn!",
            image: Image.asset(
              "assets/images/_project/On_Boarding/on_boarding_2.jpg",
              width: 450,
            ),
            decoration: pageDecoration,
          ),
        ],
        showSkipButton: false,
        showDoneButton: true,
        showBackButton: false,
        done: Text(
          "Hoàn tất",
          style: TextStyle(color: CustomAppColor.primaryRedColor),
        ),
        next: Text(
          "Tiếp tục",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: CustomAppColor.primaryRedColor,
          ),
        ),
        onDone: () async {
          Navigator.of(context).pushReplacementNamed(Routes.homepage);
        },
        onSkip: () {},
        dotsDecorator: DotsDecorator(
            size: Size.square(10),
            activeSize: Size(20, 10),
            activeColor: CustomAppColor.primaryColorOrange,
            color: Colors.black26,
            spacing: EdgeInsets.symmetric(horizontal: 3),
            activeShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25))),
        onChange: (index) {
          setState(() {
            _currentPage = index;
          });
        },
      ),
    );
  }
}
