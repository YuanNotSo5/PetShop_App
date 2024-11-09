import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pet_shop/config/constant.dart';

class ContainerButtonModel extends StatelessWidget {
  // const ContainerButtonModel({Key? key}) : super(key: key);
  final Color? bgColor;
  final double? containerWidth;
  final String itext;

  const ContainerButtonModel(
      {super.key, this.bgColor, this.containerWidth, required this.itext});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      height: 60,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          itext,
          style: GoogleFonts.raleway().copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
