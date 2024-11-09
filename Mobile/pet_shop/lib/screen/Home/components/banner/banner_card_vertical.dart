import 'package:flutter/material.dart';
import 'package:pet_shop/models/Home/Banners/ad_banner.dart';
import 'package:pet_shop/route/route_generator.dart';

class BannerCardVertical extends StatelessWidget {
  final AdBanner banner;
  const BannerCardVertical({Key? key, required this.banner}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .pushNamed(Routes.bannerDetails, arguments: banner);
      },
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 200,
          ),
          child: Container(
            margin: EdgeInsets.only(right: 10, top: 10, bottom: 10),
            width: 200,
            decoration: BoxDecoration(
              boxShadow: [BoxShadow(blurRadius: 5, color: Colors.black26)],
              borderRadius: BorderRadius.circular(16.0),
              color: Colors.white,
            ),
            child: Column(
              children: [
                Flexible(
                  flex: 7,
                  child: Container(
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: ClipRRect(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(16.0),
                                topRight: Radius.circular(16.0)),
                            child: banner.image.isNotEmpty
                                ? Image.network(
                                    banner.image,
                                    fit: BoxFit.cover,
                                  )
                                : Image.asset(
                                    "assets/images/_project/Account/black_dog.png",
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Flexible(
                  flex: 3,
                  child: Container(
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          banner.name,
                          style: TextStyle(
                            fontSize: 12,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          softWrap: true,
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
