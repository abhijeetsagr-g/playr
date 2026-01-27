import 'package:flutter/material.dart';

abstract class MyTheme {
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Colors.black,
    primaryColor: Colors.deepPurpleAccent,
    // textTheme: TextTheme(labelMedium: TextStyle(color: Colors.white)),
  );
}
