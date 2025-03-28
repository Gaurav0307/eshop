import 'package:flutter/material.dart';

class ColorConstants {
  static Color white = Colors.white;
  static Color black = Colors.black87;
  static Color black54 = Colors.black54;
  static Color indigo = Colors.indigo;
  static Color grey = Colors.grey;
  static Color grey300 = Colors.grey.shade300;
  static Color lightBlue = Colors.lightBlue;
  static Color red = Colors.red;

  static Color whiteBG = hexToColor("#FCF8FF");
  static Color pastelBlueBG = hexToColor('#B3E5FC');
  static Color mintGreenBG = hexToColor('#C8E6C9');
}

Color hexToColor(String hex) {
  assert(RegExp(r'^#([0-9a-fA-F]{6})|([0-9a-fA-F]{8})$').hasMatch(hex),
      'Hex color must be #rrggbb or #rrggbbaa');

  return Color(
    int.parse(hex.substring(1), radix: 16) +
        (hex.length == 7 ? 0xff000000 : 0x00000000),
  );
}
