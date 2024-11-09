import 'dart:ui';

import 'package:flutter/material.dart';

class TShadowStyle {
  static final verticalProductShadow = BoxShadow(
      // color: TColors.darkGrey.withOcapicity(0.1),
      color: Colors.black.withOpacity(0.1),
      blurRadius: 50,
      spreadRadius: 7,
      offset: const Offset(0, 2));
}
