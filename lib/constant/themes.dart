import 'package:flutter/material.dart';

enum Themes {
  DEFAULT,
  DARK,
}

final ThemeDataMap = {
  Themes.DEFAULT: ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.lightBlue[800],
    primaryColorLight: Colors.lightBlue[100],
    accentColor: Colors.cyan[600],
    disabledColor: Colors.grey[800],
    backgroundColor: Colors.white,
    textTheme: TextTheme(
      title: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      button: TextStyle(color: Colors.white),
      body1: TextStyle(fontSize: 14.0),
      body2: TextStyle(fontSize: 16.0, color: Colors.black),
      display1: TextStyle(fontSize: 12, color: Colors.black38),
      display2: TextStyle(fontSize: 24, color: Colors.black38),
    ),
  ),
  Themes.DARK: ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.grey[800],
    primaryColorLight: Colors.grey[100],
    accentColor: Colors.grey,
    backgroundColor: Colors.black,
    textTheme: TextTheme(
      title: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      button: TextStyle(color: Colors.grey),
      body1: TextStyle(fontSize: 14.0),
      body2: TextStyle(fontSize: 16.0, color: Colors.white),
      display1: TextStyle(fontSize: 12, color: Colors.white30),
      display2: TextStyle(fontSize: 24, color: Colors.white30),
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
