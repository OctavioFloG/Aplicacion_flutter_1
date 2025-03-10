import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/dashboard_screen.dart';
import 'package:flutter_application_1/screens/list_students_screen.dart';
import 'package:flutter_application_1/screens/login_screen.dart';
import 'package:flutter_application_1/screens/sign_up_screen.dart';
import 'package:flutter_application_1/screens/splash_screen.dart';
import 'package:flutter_application_1/screens/todo_screen.dart';
import 'package:flutter_application_1/screens/viajes_screen2.dart';
import 'package:flutter_application_1/screens/viajes_screen1.dart';
import 'package:flutter_application_1/screens/viajes_screen3.dart';
import 'package:flutter_application_1/utils/global_values.dart';
import 'package:flutter_application_1/utils/session_manager.dart';
import 'package:flutter_application_1/utils/theme_settings.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializar el tema
  await GlobalValues.initializeTheme();
  
  // Verificar si hay una sesión activa y si se debe mantener
  final isLoggedIn = await SessionManager.isLoggedIn();
  final keepSession = await SessionManager.getKeepSession();
  
  final initialRoute = (isLoggedIn && keepSession) ? '/dash' : '/login';
  
  runApp(MyApp(initialRoute: initialRoute));
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  const MyApp({super.key, this.initialRoute = '/login'});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: GlobalValues.themeApp,
      builder: (context, ThemeData theme, child) {
        return MaterialApp(
          title: 'Mi App',
          theme: theme,
          home: FutureBuilder(
            future: _checkSession(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SplashScreen();
              }
              // Si hay sesión activa, ir a dashboard, sino al login
              return snapshot.data == true 
                  ? const DashboardScreen() 
                  : const LoginScreen();
            },
          ),
          routes: {
            '/login': (context) => const LoginScreen(),
            '/dash': (context) => const DashboardScreen(),
            '/list': (context) => const ListStudentsScreen(),
            '/todo': (context) => const TodoScreen(),
            '/signup': (context) => const SignUpScreen(),
            '/viajes1': (context) => const ViajesScreen1(),
            '/viajes2': (context) => const ViajesScreen2(),
            '/viajes3': (context) => const ViajesScreen3(),
          },
        );
      },
    );
  }

  Future<bool> _checkSession() async {
    final isLoggedIn = await SessionManager.isLoggedIn();
    final keepSession = await SessionManager.getKeepSession();
    return isLoggedIn && keepSession;
  }
}
