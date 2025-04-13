import 'package:flutter/material.dart';
import 'package:flutter_application_1/utils/global_values.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeSettings {
  static const String _themeKey = 'theme_mode';
  static const String _primaryColorKey = 'primary_color';
  static const String _surfaceColorKey = 'surface_color';
  static const String _textColorKey = 'text_color';
  static const String _containerColorKey = 'container_color';
  static const String _fontFamilyKey = 'font_family';

  static final Map<String, Color> lightColors = {
    'primary': Colors.blue,         
    'secondary': Colors.blueAccent, 
    'surface': const Color(0xFFF5F5F5),    // Gris muy claro para el fondo
    'error': Colors.red,           
    'background': Colors.white,     
    'container': Colors.white,      
    'text': Colors.black87,         // Negro con ligera transparencia
  };

  static final Map<String, Color> darkColors = {
    'primary': Colors.blue,         
    'secondary': Colors.blueAccent, 
    'surface': const Color(0xFF121212),    // Gris muy oscuro para el fondo
    'error': Colors.redAccent,     
    'background': const Color(0xFF1E1E1E), // Gris oscuro para el fondo
    'container': const Color(0xFF2D2D2D),  // Gris medio para contenedores
    'text': Colors.white,          
  };

  static Map<String, Color> currentColors = Map.from(lightColors);

  static Future<ThemeData> getTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final themeMode = prefs.getString(_themeKey) ?? 'light';
      
      switch (themeMode) {
        case 'dark':
          currentColors = Map.from(darkColors);
          return darkTheme();
        case 'custom':
          await _loadCustomColors();
          return await loadCustomTheme();
        default:
          currentColors = Map.from(lightColors);
          return lightTheme();
      }
    } catch (e) {
      // Si hay algún error, devolver el tema claro por defecto
      currentColors = Map.from(lightColors);
      return lightTheme();
    }
  }

  static Future<void> _loadCustomColors() async {
    final prefs = await SharedPreferences.getInstance();
    
    currentColors = {
      'primary': Color(prefs.getInt(_primaryColorKey) ?? lightColors['primary']!.value),
      'secondary': lightColors['secondary']!,
      'surface': Color(prefs.getInt(_surfaceColorKey) ?? lightColors['surface']!.value),
      'error': lightColors['error']!,
      'background': lightColors['background']!,
      'container': Color(prefs.getInt(_containerColorKey) ?? lightColors['container']!.value),
      'text': Color(prefs.getInt(_textColorKey) ?? lightColors['text']!.value),
    };
  }

  static ThemeData lightTheme() {
  return ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: currentColors['surface'],
    textTheme: ThemeData.light().textTheme.apply(
      bodyColor: currentColors['text'],
      displayColor: currentColors['text'],
    ),
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: currentColors['primary']!,
      onPrimary: Colors.white,
      secondary: currentColors['secondary']!,
      onSecondary: Colors.white,
      error: currentColors['error']!,
      onError: Colors.white,
      surface: currentColors['surface']!,
      onSurface: currentColors['text']!,
    ),
    cardTheme: CardTheme(
      color: currentColors['container'],
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.grey[300]!),
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: currentColors['primary'],
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
    ),
  );
}

  static ThemeData darkTheme() {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: currentColors['surface'],
      textTheme: ThemeData.dark().textTheme.apply(
        bodyColor: currentColors['text'],
        displayColor: currentColors['text'],
      ),
      colorScheme: ColorScheme(
        brightness: Brightness.dark,
        primary: currentColors['primary']!,
        onPrimary: Colors.white,
        secondary: currentColors['secondary']!,
        onSecondary: Colors.white,
        error: currentColors['error']!,
        onError: Colors.white,
        surface: currentColors['surface']!,
        onSurface: currentColors['text']!,
      ),
      cardTheme: CardTheme(
        color: currentColors['container'],
        elevation: 2, // Sombra más pronunciada para contraste
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: Colors.black),
        ),
      ),
      dialogTheme: DialogTheme(
        backgroundColor: currentColors['container'],
        contentTextStyle: TextStyle(color: currentColors['text']),
        titleTextStyle: TextStyle(color: currentColors['text']),
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: currentColors['container'],
        textStyle: TextStyle(color: currentColors['text']),
      ),
    );
  }

  static Future<ThemeData> buildThemeWithFont(ThemeData baseTheme, String fontFamily) async {
    // Obtener la fuente de Google Fonts y aplicarla al TextTheme
    final updatedTextTheme = GoogleFonts.getTextTheme(
      fontFamily,
      baseTheme.textTheme,
    );

    return baseTheme.copyWith(
      textTheme: updatedTextTheme,
      primaryTextTheme: updatedTextTheme,
    );
  }

  static Future<ThemeData> loadCustomTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final currentFont = prefs.getString(_fontFamilyKey) ?? 'Roboto';
    
    // Crear tema base con los colores personalizados
    final customTheme = ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: currentColors['surface'],
      colorScheme: ColorScheme(
        brightness: Brightness.light,
        primary: currentColors['primary']!,
        onPrimary: Colors.white,
        secondary: currentColors['secondary']!,
        onSecondary: Colors.white,
        error: currentColors['error']!,
        onError: Colors.white,
        surface: currentColors['surface']!,
        onSurface: currentColors['text']!,
      ),
      // ... resto de las propiedades del tema
    );

    // Aplicar la fuente al tema
    return buildThemeWithFont(customTheme, currentFont);
  }

  static Future<void> saveThemePreferences({
    required String themeMode,
    Color? primaryColor,
    Color? surfaceColor,
    Color? textColor,
    Color? containerColor,
    String? fontFamily,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, themeMode);
    
    if (themeMode == 'custom') {
      if (primaryColor != null) await prefs.setInt(_primaryColorKey, primaryColor.value);
      if (surfaceColor != null) await prefs.setInt(_surfaceColorKey, surfaceColor.value);
      if (textColor != null) await prefs.setInt(_textColorKey, textColor.value);
      if (containerColor != null) await prefs.setInt(_containerColorKey, containerColor.value);
      if (fontFamily != null) await prefs.setString(_fontFamilyKey, fontFamily);
    }
  }

  static Future<String> getCurrentThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_themeKey) ?? 'light';
  }

  static Future<String> getCurrentFont() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_fontFamilyKey) ?? 'Roboto';
  }

  static Future<void> updateThemeMode(String themeMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, themeMode);
    
    switch (themeMode) {
      case 'dark':
        currentColors = Map.from(darkColors);
        GlobalValues.themeApp.value = darkTheme();
        break;
      case 'light':
        currentColors = Map.from(lightColors);
        GlobalValues.themeApp.value = lightTheme();
        break;
    }
  }

  static Future<void> updateFont(String fontFamily) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_fontFamilyKey, fontFamily);
    
    // Obtener el tema actual y reconstruirlo con la nueva fuente
    final currentThemeMode = await getCurrentThemeMode();
    ThemeData baseTheme;
    
    switch (currentThemeMode) {
      case 'dark':
        baseTheme = darkTheme();
        break;
      case 'custom':
        baseTheme = await loadCustomTheme();
        break;
      default:
        baseTheme = lightTheme();
    }

    final updatedTheme = await buildThemeWithFont(baseTheme, fontFamily);
    GlobalValues.themeApp.value = updatedTheme;
  }

  static Future<Map<String, Color>> getCustomThemeColors() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'primary': Color(prefs.getInt(_primaryColorKey) ?? Colors.blue.value),
      'surface': Color(prefs.getInt(_surfaceColorKey) ?? Colors.white.value),
      'text': Color(prefs.getInt(_textColorKey) ?? Colors.black.value),
      'container': Color(prefs.getInt(_containerColorKey) ?? Colors.white.value),
    };
  }
}
