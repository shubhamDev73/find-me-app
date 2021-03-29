import 'package:flutter/material.dart';

const String title = "Find.me";

class ThemeColors {
  static const Color primaryColor = Color(0xFF00ACC1);
  static const Color accentColor = Color(0xFF4FCBDA);
  static const Color boxColor = Color(0xFFE0F7FA);
  static const Color topBoxColor = Color(0xFFDFF7F9);
  static const Color messageBoxColor = Color(0xFFB2EBF2);
  static const Color lightColor = Color(0xFFF0FBFD);
  static const Color positiveTraitColor = Colors.white;
  static const Color negativeTraitColor = Colors.black;
  static const Map<int, Color> interestColors = {
    0: Color(0xFFFFFFFF),
    1: Color(0xFFB2EBF2),
    2: Color(0xFF4FCBDA),
    3: Color(0xFF02A8BC),
  };
  static const Map<bool, Color> chatMessageColors = {
    true: Color(0xFFF0FBFD),
    false: Color(0xFF82D6E1),
  };
  static Map<bool, Color> chatListColors = {
    true: Colors.grey.shade300,
    false: Colors.white,
  };
}
