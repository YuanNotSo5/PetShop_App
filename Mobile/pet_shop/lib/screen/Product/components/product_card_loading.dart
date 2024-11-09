import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ProductCardLoading extends StatelessWidget {
  const ProductCardLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 5, 10),
      child: Material(
        elevation: 8,
        shadowColor: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Shimmer.fromColors(
            highlightColor: Colors.white,
            baseColor: Colors.grey.shade300,
            // child: Container(
            //   margin: EdgeInsets.all(10),
            //   width: 120,
            //   child: Column(
            //     children: [
            //       AspectRatio(
            //         aspectRatio: 0.9,
            //         child: Container(
            //           color: Colors.grey,
            //           padding: EdgeInsets.all(15),
            //           margin: EdgeInsets.symmetric(horizontal: 25),
            //         ),
            //       ),
            //       SizedBox(
            //         height: 10,
            //       ),
            //       Padding(
            //         padding: EdgeInsets.only(left: 10, bottom: 10),
            //         child: Container(
            //           height: 15,
            //           color: Colors.grey,
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            child: Column(
              children: [
                Flexible(
                  flex: 5,
                  child: Center(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      color: Colors.grey.shade300,
                    ),
                  ),
                ),
                Flexible(
                    flex: 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10),
                        Container(
                          height: 20,
                          color: Colors.grey.shade300,
                        ),
                        SizedBox(height: 5),
                        Container(
                          height: 15,
                          width: 75,
                          color: Colors.grey.shade300,
                        ),
                      ],
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
