import 'dart:core';
import 'package:flutter/material.dart';

final class OrmeeColor extends Color {
  OrmeeColor(super.value);

  static const Color systemError = Color(0xFFFF5555);
  static const Color systemAlert = Color(0xFFE96D6D);
  static const Color systemPositive = Color(0xFF14DB6E);

  static const Map<int, Color> gray = <int, Color>{
    10: Color.fromARGB(255, 246, 246, 250),
    20: Color.fromARGB(255, 242, 242, 244),
    30: Color.fromARGB(255, 231, 231, 234),
    40: Color.fromARGB(255, 201, 201, 212),
    50: Color.fromARGB(255, 180, 180, 194),
    60: Color.fromARGB(255, 126, 127, 142),
    70: Color.fromARGB(255, 105, 106, 125),
    75: Color.fromARGB(255, 71, 71, 86),
    80: Color.fromARGB(255, 40, 41, 49),
    90: Color.fromARGB(255, 25, 25, 29),
  };

  static const Map<int, Color> purple = <int, Color>{
    10: Color.fromARGB(255, 246, 244, 255),
    15: Color.fromARGB(255, 241, 238, 255),
    20: Color.fromARGB(255, 222, 214, 255),
    30: Color.fromARGB(255, 195, 182, 255),
    35: Color.fromARGB(255, 167, 148, 255),
    40: Color.fromARGB(255, 141, 116, 255),
    50: Color.fromARGB(255, 116, 85, 255),
    60: Color.fromARGB(255, 99, 72, 217),
    70: Color.fromARGB(255, 82, 60, 181),
    80: Color.fromARGB(255, 66, 48, 145),
    90: Color.fromARGB(255, 52, 38, 115),
  };

  static const Map<int, Color> accentRedOrange = {
    5: Color(0xFFFFF0E6),
    10: Color(0xFFFFBF91),
    20: Color(0xFFFF6A00),
  };

  static const Map<int, Color> accentYellowGreen = {
    5: Color(0xFFEFF8E6),
    10: Color(0xFFB8DF91),
    20: Color(0xFF5AB500),
  };

  static const Map<int, Color> accentBlue = {
    5: Color(0xFFE6F7FF),
    10: Color(0xFF91DEFF),
    20: Color(0xFF00B3FF),
  };

  static const Map<int, double> opacity = {
    90: 0.9,
    80: 0.8,
    70: 0.7,
    60: 0.6,
    50: 0.5,
    40: 0.4,
    30: 0.3,
    20: 0.2,
    10: 0.1,
  };
}
