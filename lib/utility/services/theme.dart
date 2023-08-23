import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/color_constants.dart';

class Themes {
  static final light = ThemeData(
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: Colors.blueAccent,
      onPrimary: Colors.white,
      secondary: Colors.black38,
      onSecondary: Colors.grey,
      error: Colors.red,
      onError: Colors.redAccent,
      background: Colors.white,
      onBackground: Colors.white70,
      surface: Colors.black38,
      onSurface: Colors.black45,
    ),
    textTheme: GoogleFonts.interTextTheme(
      Get.textTheme.apply(
        bodyColor: ColorConstants.dark,
        displayColor: ColorConstants.dark,
      ),
    ),
  );
  static final dark = ThemeData(
    colorScheme: const ColorScheme(
      brightness: Brightness.dark,
      primary: Colors.blueAccent,
      onPrimary: Colors.white,
      secondary: Colors.blueAccent,
      onSecondary: Colors.lightBlueAccent,
      error: Colors.red,
      onError: Colors.redAccent,
      background: Colors.blue,
      onBackground: Colors.blue,
      surface: Colors.black,
      onSurface: Colors.white,
    ),
    textTheme: GoogleFonts.interTextTheme(
      Get.textTheme.apply(
        bodyColor: Colors.white,
        displayColor: Colors.white,
      ),
    ),
  );
}
