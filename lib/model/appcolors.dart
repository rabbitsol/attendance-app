import 'package:flutter/material.dart';

class AppColors {
  static const Color black = Color(0xff1C2D40);
  static const Color aqua = Color(0xff80A7D6);
  static const Color aquabg = Color.fromARGB(255, 108, 157, 218);

  static const Color white = Color(0xffffffff);
  static const Color blue = Color(0xff97BCE8);
  static const Color bgcolor = Color.fromARGB(255, 205, 221, 241);
  static const LinearGradient linearGradientforbg = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        black,
        // .withOpacity(0.1),
        white
        // .withOpacity(0.05),
      ],
      stops: [
        0.1,
        1,
      ]);
  static const LinearGradient linearGradientforbtn = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.topRight,
    colors: [
      aqua,
      // .withOpacity(0.1),
      black
      // .withOpacity(0.05),
    ],
    // stops: [
    //   0.1,
    //   1,
    // ]
  );
}
