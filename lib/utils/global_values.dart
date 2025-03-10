import 'package:flutter/material.dart';
import 'package:flutter_application_1/utils/theme_settings.dart';

class GlobalValues {
  static ValueNotifier<bool> isValidating = ValueNotifier(false);
  static ValueNotifier<ThemeData> themeApp = ValueNotifier(ThemeSettings.lightTheme());
  static ValueNotifier<bool> upList = ValueNotifier(false);

  static Future<void> initializeTheme() async {
    final theme = await ThemeSettings.getTheme();
    themeApp.value = theme;
  }
}