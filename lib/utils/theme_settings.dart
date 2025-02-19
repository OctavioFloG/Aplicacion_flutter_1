import 'package:flutter/material.dart';

class ThemeSettings {
  static lightTheme() {
    final theme = ThemeData.light().copyWith(
        colorScheme: const ColorScheme(
            brightness: Brightness.light,
            primary: Colors.black54,
            onPrimary: Colors.amber,
            secondary: Colors.amber,
            onSecondary: Colors.amber,
            error: Colors.blue,
            onError: Colors.deepPurpleAccent,
            surface: Colors.teal,
            onSurface: Colors.lightGreenAccent));
    return theme;
  }

  static darkTheme() {
    final theme = ThemeData.dark().copyWith(
        colorScheme: const ColorScheme(
            brightness: Brightness.dark,
            primary: Colors.black54, //Color primario de Widgets
            onPrimary: Colors.amber,
            secondary: Colors.amber,
            onSecondary: Colors.amber,
            error: Colors.amber,
            onError: Colors.amber,
            surface: Colors.deepPurple, //Color de fondo de algunos contenedores
            onSurface: Colors.white));
    return theme;
  }
}
