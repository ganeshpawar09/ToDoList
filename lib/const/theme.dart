import 'package:flutter/material.dart';

const Color bluishclr = Color(0xFF4e5ae8);
const Color yellowclr = Color(0xFFFFB746);
const Color pinkClr = Color(0xFFff4667);
const Color white = Colors.white;
const Color scbag = Color.fromARGB(255, 144, 153, 243);
const primaryClr = bluishclr;
const Color darkGreyClr = Color(0xFF121212);
Color? darkHeaderCtr = Colors.grey[800];

class Themes {
  static final light = ThemeData(
      brightness: Brightness.light,
      appBarTheme: const AppBarTheme(backgroundColor: Colors.white70));
  static final dark = ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: Colors.black,
      appBarTheme: AppBarTheme(backgroundColor: Colors.black));
}

  TextStyle get subHeadlineStyle {
    return TextStyle(
      fontFamily: 'lato',
      fontSize: 25,
      fontWeight: FontWeight.bold,
    );
  }

  TextStyle get headlineStyle {
    return TextStyle(
      fontSize: 30,
      fontFamily: 'lato',
      fontWeight: FontWeight.bold,
    );
  }

  TextStyle get titleStyle {
    return TextStyle(
      fontSize: 18,
      fontFamily: 'lato',
      fontWeight: FontWeight.bold,
    );
  }

  TextStyle get subtitleStyle {
    return TextStyle(
      fontSize: 16,
      fontFamily: 'lato',
      fontWeight: FontWeight.bold,
    );
  }
