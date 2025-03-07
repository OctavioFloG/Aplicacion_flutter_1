import 'package:flutter/material.dart';
import 'package:flutter_application_1/utils/theme_settings.dart';

class GlobalValues {
  static ValueNotifier isValidating = ValueNotifier(false);
  static ValueNotifier themeApp = ValueNotifier(ThemeSettings.lightTheme());
  static ValueNotifier upList = ValueNotifier(false);
}