import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static const String KEY_LOGIN = "isLoggedIn";
  static const String KEY_EMAIL = "userEmail";
  static const String KEY_IMAGE = "userImage";
  static const String KEY_NAME = "userName";

  static Future<void> setLoginDetails(String email,
      {String? imagePath, String? nombre}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(KEY_LOGIN, true);
    await prefs.setString(KEY_EMAIL, email);
    if (imagePath != null) {
      await prefs.setString(KEY_IMAGE, imagePath);
    }
    if (nombre != null) {
      await prefs.setString(KEY_NAME, nombre);
    }
  }

  static Future<Map<String, String?>> getUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return {
      'email': prefs.getString(KEY_EMAIL),
      'imagePath': prefs.getString(KEY_IMAGE),
      'nombre': prefs.getString(KEY_NAME),
    };
  }

  static Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  static Future<bool> isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(KEY_LOGIN) ?? false;
  }
}
