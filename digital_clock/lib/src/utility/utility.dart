import 'package:flutter/material.dart';

/// This class used to provide [ThemeData]
/// and calculating size for different screen size
///
class Utility {
  static final ThemeData lightTheme = ThemeData.light().copyWith(
    primaryColor: Colors.pink,
    primaryColorDark: Colors.pink.withOpacity(0.8),
    indicatorColor: Colors.black,
    accentColor: Colors.deepOrange,
    primaryColorLight: Colors.black,
  );

  static final ThemeData darkTheme = ThemeData.dark().copyWith(
    primaryColor: Colors.greenAccent,
    primaryColorDark: Colors.greenAccent.withOpacity(0.8),
    indicatorColor: Colors.grey,
    accentColor: Colors.orange,
    primaryColorLight: Colors.white,
  );

  static double textSize48 = 48; //84;
  static double textSize24 = 24; //42;
  static double textSize18 = 18; //31.5;
  static double textSize16 = 16; //28;
  static double textSize11 = 11; //19.25;

  static double weatherIcon = 30; //52.5;

  static double scaleFactor = 3.5;
  static double portrait = 4;

  static void init(Size size, Orientation orientation) {
    scaleFactor = size.shortestSide / 320;
    portrait = orientation == Orientation.portrait ? 4 : 0;

    textSize48 = _calculateTextSize(48);
    textSize24 = _calculateTextSize(24);
    textSize18 = _calculateTextSize(18);
    textSize16 = _calculateTextSize(16);
    textSize11 = _calculateTextSize(11);
    weatherIcon = _calculateTextSize(30);
  }

  static double _calculateTextSize(double baseSize) =>
      (baseSize * scaleFactor) - portrait;
}
