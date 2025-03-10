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
  
  // Esperar a que se cargue el tema antes de iniciar la app
  final initialTheme = await ThemeSettings.getTheme();
  GlobalValues.themeApp.value = initialTheme;

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
          // Siempre iniciamos con el splash
          initialRoute: '/',
          routes: {
            '/': (context) => const SplashScreen(),
            '/login': (context) => const LoginScreen(),
            '/dash': (context) => const DashboardScreen(),
            '/list': (context) => const ListStudentsScreen(),
            '/todo': (context) => const TodoScreen(),
            '/signup': (context) => const SignUpScreen(),
            '/viajes1': (context) => const ViajesScreen1(),
            '/viajes2': (context) => const ViajesScreen2(),
            '/viajes3': (context) => const ViajesScreen3(),
          },
          // Redirigir a la ruta inicial después del login
          onGenerateRoute: (settings) {
            if (settings.name == '/login' && initialRoute == '/dash') {
              return MaterialPageRoute(
                builder: (context) => const DashboardScreen(),
              );
            }
            return null;
          },
        );
      },
    );
  }
}
