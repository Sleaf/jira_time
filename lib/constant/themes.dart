import 'package:flutter/material.dart';

enum Themes {
  DEFAULT,
  DARK,
}

final ThemeDataMap = {
  Themes.DEFAULT: ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.lightBlue[800],
    accentColor: Colors.cyan[600],
    disabledColor: Colors.grey[800],
    backgroundColor: Colors.white,
    textTheme: TextTheme(
      button: TextStyle(color: Colors.white),
      body1: TextStyle(fontSize: 14.0),
      body2: TextStyle(fontSize: 16.0, color: Colors.black),
    ),
  ),
  Themes.DARK: ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.grey[800],
    accentColor: Colors.grey,
    backgroundColor: Colors.black,
    textTheme: TextTheme(
      button: TextStyle(color: Colors.grey),
      body1: TextStyle(fontSize: 14.0),
      body2: TextStyle(fontSize: 16.0, color: Colors.white),
    ),
  )
};

Themes getThemesFromString(String statusAsString) {
  for (Themes element in Themes.values) {
    if (element.toString() == statusAsString) {
      return element;
    }
  }
  return null;
}
