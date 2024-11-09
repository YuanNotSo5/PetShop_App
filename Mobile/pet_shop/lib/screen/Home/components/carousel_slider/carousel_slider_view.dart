import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:pet_shop/models/Home/Banners/ad_banner.dart';
import 'package:pet_shop/screen/Home/components/carousel_slider/banner_cart.dart';

class CarouselSliderView extends StatefulWidget {
  final List<AdBanner> bannerList;
  const CarouselSliderView({Key? key, required this.bannerList})
      : super(key: key);

  @override
  _CarouselSliderViewState createState() => _CarouselSliderViewState();
}

class _CarouselSliderViewState extends State<CarouselSliderView> {
  int _currentIndex = 0;
  late List<Widget> _bannerList;

  @override
  void initState() {
    super.initState();
    _bannerList = widget.bannerList
        .map((e) => BannerCart(id: e.id, imageUrl: e.image, banner: e))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    // Get the size of the screen
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        CarouselSlider(
          items: _bannerList,
          options: CarouselOptions(
            height: screenHeight * 0.25, // 25% of the screen height
            autoPlay: true,
            enlargeCenterPage: true,
            aspectRatio: 16 / 9,
            viewportFraction: 1,
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
        ),
        Positioned(
          bottom: 10,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: widget.bannerList.map((e) {
              int index = widget.bannerList.indexOf(e);
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: _currentIndex == index ? 16 : 8,
                height: 8,
                margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 2),
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(5),
                  color: _currentIndex == index
                      ? const Color.fromARGB(255, 0, 0, 0)
                      : const Color.fromARGB(102, 0, 0, 0),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
