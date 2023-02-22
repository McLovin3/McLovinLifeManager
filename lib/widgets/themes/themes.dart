import 'package:flutter/material.dart';

const Color _darkThemeColor = Colors.deepPurple;
const Color _lightThemeColor = Colors.pink;

ThemeData lightTheme = ThemeData(
  appBarTheme: const AppBarTheme(
    color: _lightThemeColor,
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: _lightThemeColor,
  ),
  brightness: Brightness.light,
);

ThemeData darkTheme = ThemeData(
  appBarTheme: const AppBarTheme(
    color: _darkThemeColor,
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: _darkThemeColor,
  ),
  brightness: Brightness.dark,
);
