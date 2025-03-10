// ignore_for_file: constant_identifier_names

import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static const String KEY_LOGIN = "isLoggedIn";
  static const String KEY_EMAIL = "userEmail";
  static const String KEY_IMAGE = "userImage";
  static const String KEY_NAME = "userName";
  static const String KEY_KEEP_SESSION = "keepSession";
  //TEMAS
  static const String KEY_THEME_MODE = "themeMode";
  static const String KEY_PRIMARY_COLOR = "primaryColor";
  static const String KEY_ACCENT_COLOR = "accentColor";
  static const String KEY_SURFACE_COLOR = "surfaceColor";
  static const String KEY_ERROR_COLOR = "errorColor";
  static const String KEY_BACKGROUND_COLOR = "backgroundColor";
  static const String KEY_CONTAINER_COLOR = "containerColor";
  static const String KEY_FONT_FAMILY = "fontFamily";
  static const String KEY_FONT_COLOR = "fontColor";

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
    bool keepSession = await getKeepSession();
    if (!keepSession) {
      await prefs.clear();
    } else {
      // ELiminar datos de sesion
      await prefs.remove(KEY_LOGIN);
      await prefs.remove(KEY_EMAIL);
      await prefs.remove(KEY_NAME);
      await prefs.remove(KEY_IMAGE);
    }
  }

  static Future<void> setLoggedIn(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(KEY_LOGIN, value);
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final keepSession = await getKeepSession();
    final isLogged = prefs.getBool(KEY_LOGIN) ?? false;
    
    // Solo consideramos que está logueado si ambos son true
    return isLogged && keepSession;
  }

  static Future<void> setKeepSession(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(KEY_KEEP_SESSION, value);
  }

  static Future<bool> getKeepSession() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(KEY_KEEP_SESSION) ?? false;
  }

  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    final keepSession = await getKeepSession(); // Guardamos el valor actual
    
    // Limpiamos solo los datos de sesión
    await prefs.remove(KEY_LOGIN);
    await prefs.remove(KEY_EMAIL);
    await prefs.remove(KEY_NAME);
    await prefs.remove(KEY_IMAGE);
    
    // Restauramos la preferencia de mantener sesión
    await setKeepSession(keepSession);
  }

  // === TEMAS ===
  static Future<void> saveThemePreferences(
    String themeMode, {
    String? fontFamily,
    int? primaryColor,
    int? surfaceColor,
    int? containerColor,
    int? fontColor,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(KEY_THEME_MODE, themeMode);
    if (fontFamily != null) {
      await prefs.setString(KEY_FONT_FAMILY, fontFamily);
    }
    if (primaryColor != null) await prefs.setInt(KEY_PRIMARY_COLOR, primaryColor);
    if (surfaceColor != null) await prefs.setInt(KEY_SURFACE_COLOR, surfaceColor);
    if (containerColor != null) {
      await prefs.setInt(KEY_CONTAINER_COLOR, containerColor);
    }
    if (fontColor != null) await prefs.setInt(KEY_FONT_COLOR, fontColor);

  }

  static Future<Map<String, dynamic>> getThemePreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return {
      'themeMode': prefs.getString(KEY_THEME_MODE) ?? 'light',
      'primaryColor': prefs.getInt(KEY_PRIMARY_COLOR),
      'containerColor': prefs.getInt(KEY_CONTAINER_COLOR),
      'fontFamily': prefs.getString(KEY_FONT_FAMILY) ?? 'Roboto',
      'fontColor': prefs.getInt(KEY_FONT_COLOR),
    };
  }
}
