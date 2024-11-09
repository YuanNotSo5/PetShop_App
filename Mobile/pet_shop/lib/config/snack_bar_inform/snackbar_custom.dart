// https://www.youtube.com/watch?v=WFzZ2fk9JZY
import 'package:flutter/material.dart';

class SnackbarCustom {
  SnackBar showErorSnackBar(String text) {
    return SnackBar(
      content: Text(text),
      backgroundColor: Colors.red,
    );
  }
}
