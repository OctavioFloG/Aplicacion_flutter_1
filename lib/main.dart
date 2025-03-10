import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/dashboard_screen.dart';
import 'package:flutter_application_1/screens/list_students_screen.dart';
import 'package:flutter_application_1/screens/sign_up_screen.dart';
import 'package:flutter_application_1/screens/splash_screen.dart';
import 'package:flutter_application_1/screens/todo_screen.dart';
import 'package:flutter_application_1/screens/viajes_screen2.dart';
import 'package:flutter_application_1/screens/viajes_screen1.dart';
import 'package:flutter_application_1/screens/viajes_screen3.dart';
import 'package:flutter_application_1/utils/global_values.dart';
import 'package:flutter_application_1/utils/session_manager.dart';
import 'package:flutter_application_1/utils/theme_settings.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // sharedPreferences
  final themePrefs = await SessionManager.getThemePreferences();
  final isLoggedIn = await SessionManager.isLoggedIn();

  // Configurar el tema inicial
  switch (themePrefs['themeMode']) {
    case 'dark':
      GlobalValues.themeApp.value = ThemeSettings.darkTheme();
      break;
    case 'custom':
      if (themePrefs['primaryColor'] != null) {
        GlobalValues.themeApp.value = ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Color(themePrefs['primaryColor']),
            secondary: Color(themePrefs['accentColor'] ?? 0xFF1976D2),
          ),
        );
      }
      break;
    default:
      GlobalValues.themeApp.value = ThemeSettings.lightTheme();
  }

  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  
  const MyApp({
    super.key,
    required this.isLoggedIn,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: GlobalValues.themeApp,
      builder: (context, value, child) {
        return MaterialApp(
          theme: value,
          home: isLoggedIn ? const DashboardScreen() : const SplashScreen(),
          routes: {
            "/list": (context) => const ListStudentsScreen(),
            "/dash": (context) => const DashboardScreen(),
            "/todo": (context) => const TodoScreen(),
            "/signup": (context) => const SignUpScreen(),

            // === Práctica 1 ===
            "/viajes1": (context) => const ViajesScreen1(),
            "/viajes2": (context) => const ViajesScreen2(),
            "/viajes3": (context) => const ViajesScreen3(),
          },
          title: 'Material App',
        );
      },
    );
  }
}
