import 'package:flutter/material.dart';

enum Themes {
  DEFAULT,
  DARK,
}

final ThemeDataMap = {
  Themes.DEFAULT: ThemeData(
    // Define the default Brightness and Colors
    brightness: Brightness.light,
    primaryColor: Colors.lightBlue[800],
    accentColor: Colors.cyan[600],
    disabledColor: Colors.grey[800],

    // Define the default Font Family
    fontFamily: 'Montserrat',

    // Define the default TextTheme. Use this to specify the default
    // text styling for headlines, titles, bodies of text, and more.
    textTheme: TextTheme(
      headline: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
      button: TextStyle(color: Colors.white),
      title: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
      body1: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
    ),
  ),
  Themes.DARK: ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.black,
    accentColor: Colors.grey,

    // Define the default Font Family
    fontFamily: 'Montserrat',

    // Define the default TextTheme. Use this to specify the default
    // text styling for headlines, titles, bodies of text, and more.
    textTheme: TextTheme(
      headline: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
      button: TextStyle(color: Colors.grey),
      title: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
      body1: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
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
