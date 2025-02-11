import 'package:flutter/material.dart';

final ThemeData appTheme = ThemeData(
  // default theme
  brightness: Brightness.light,
  primaryColor: Color(0xFF87027B),
  scaffoldBackgroundColor: Colors.white,

  // default ButtonTheme
  buttonTheme: ButtonThemeData(
    buttonColor: Colors.purpleAccent,
    textTheme: ButtonTextTheme.primary,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.0),
    ),
  ),

  textTheme: TextTheme(
    headlineLarge: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.bold,
        fontFamily: 'Poppins',
        color: Color(0xFF87027B)),

    // for subtitle text
    headlineMedium: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        fontFamily: 'Poppins',
        color: Colors.black),

    // for bold body text (e.g. 'or continue with')
    headlineSmall: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        fontFamily: 'Poppins',
        color: Colors.black),

    // body text styles
    bodyLarge: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        fontFamily: 'Poppins',
        color: Colors.black),
    bodyMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        fontFamily: 'Poppins',
        color: Colors.black),
    bodySmall: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        fontFamily: 'Poppins',
        color: Colors.black),

    // for elevated button text (e.g. 'confirm' button)
    labelLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        fontFamily: 'Roboto',
        color: Colors.white),

    // for black underlined text (e.g. 'create new account' button)
    labelMedium: TextStyle(
        decoration: TextDecoration.underline,
        fontSize: 16,
        fontWeight: FontWeight.normal,
        fontFamily: 'Roboto',
        color: Colors.black),

    // for purple underlined text (e.g. 'forgot password' button)
    labelSmall: TextStyle(
        decoration: TextDecoration.underline,
        decorationColor: Color(0xFF87027B),
        fontSize: 12,
        fontWeight: FontWeight.normal,
        fontFamily: 'Roboto',
        color: Color(0xFF87027B)),
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Color(0xFF87027B),
      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
    ),
  ),

  appBarTheme: AppBarTheme(
    backgroundColor: Colors.white,
    elevation: 0.0,
  ),

  // default InputDecorationTheme
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.blueGrey.shade200.withAlpha((0.2 * 255).toInt()),
    hintStyle: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        fontFamily: 'Poppins',
        color: Colors.blueGrey),
    border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: Colors.blueGrey.shade200)),
    enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: Colors.blueGrey.shade200)),
    focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.purple)),
  ),
);
