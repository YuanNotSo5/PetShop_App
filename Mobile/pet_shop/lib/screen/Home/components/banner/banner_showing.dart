import 'package:flutter/material.dart';
import 'package:pet_shop/models/Home/Banners/ad_banner.dart';
import 'package:pet_shop/screen/Home/components/banner/banner_card_vertical.dart';

class BannerShowing extends StatelessWidget {
  final List<AdBanner> bannerList;
  const BannerShowing({Key? key, required this.bannerList}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: 340),
      child: Container(
        height: 20,
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          itemCount: bannerList.length,
          itemBuilder: (context, index) => BannerCardVertical(
            banner: bannerList[index],
          ),
        ),
      ),
    );
  }
}
