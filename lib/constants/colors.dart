import 'package:flutter/material.dart';

class AppColor {
  //
  static const Color backgroundColor = Color(0xffF4F6F8);
  //
  static const darkBackgroundClr = Color.fromRGBO(0, 0, 0, 1.0);
  static const primaryClr = Colors.white;
  static const secondaryClr = Colors.grey;
  static const Color secondaryDark = Color(0xffDD4D54);
  static const darkGreyClr = Color.fromRGBO(97, 97, 97, 1);
  static const Color monoExtraLight = Color(0xffC4D3D3);
  static const Color monoAlt = Color(0xff49565F);
  static const Color monoGrey3 = Color(0xff969696);
  static const Color monoDark = Color(0xff061E1E);
  static const Color monoEmphasis = Color(0xff1E262C);
  static const Color monoWhite = Color(0xffFFFFFF);
  static const Color monoLight = Color(0xff586767);
  static const Color newGrey = Color(0xFF424242);

  /* static hexStringToColor(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }
    return Color(int.parse(hexColor, radix: 16));
  } */
}
