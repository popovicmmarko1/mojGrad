import 'package:flutter/material.dart';

ThemeData darkTheme = ThemeData.dark().copyWith(
  accentColor: Color(0xFF698d3d),
  primaryColor: Color(0xFFF4d4d4d),
  appBarTheme: AppBarTheme(
    color: Color(0xFF262626),
    elevation: 0.7,
    actionsIconTheme: IconThemeData(color: Colors.white),
    textTheme: TextTheme(
      title: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
    ),
    iconTheme: IconThemeData(color: Colors.white),
  )
);

ThemeData lightTheme = ThemeData.light().copyWith(
  primaryColor: Colors.grey[100],
  accentColor: Color(0xFF698d3d),
  scaffoldBackgroundColor: Colors.grey[200],
  appBarTheme: AppBarTheme(
    color: Colors.white70,
    actionsIconTheme: IconThemeData(color: Colors.black87),
    elevation: 0.7,
    textTheme: TextTheme(
      title: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 20)
    ),
    iconTheme: IconThemeData(color: Colors.black87),
  ),
);

enum ThemeType {Light,Dark}