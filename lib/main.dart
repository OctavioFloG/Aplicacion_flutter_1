import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/firebase_options.dart';
import 'package:flutter_application_1/screens/dashboard_screen.dart';
import 'package:flutter_application_1/screens/detail_popular_screen.dart';
import 'package:flutter_application_1/screens/google_map_screen.dart';
import 'package:flutter_application_1/screens/list_students_screen.dart';
import 'package:flutter_application_1/screens/login_screen.dart';
import 'package:flutter_application_1/screens/negocio_screen.dart';
import 'package:flutter_application_1/screens/popular_screen.dart';
import 'package:flutter_application_1/screens/sign_up_screen.dart';
import 'package:flutter_application_1/screens/splash_screen.dart';
import 'package:flutter_application_1/screens/todo_firebase_screen.dart';
import 'package:flutter_application_1/screens/todo_screen.dart';
import 'package:flutter_application_1/screens/viajes_screen2.dart';
import 'package:flutter_application_1/screens/viajes_screen1.dart';
import 'package:flutter_application_1/screens/viajes_screen3.dart';
import 'package:flutter_application_1/utils/global_values.dart';
import 'package:flutter_application_1/utils/notification_service.dart';
import 'package:flutter_application_1/utils/session_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService().initialize();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );

  await GlobalValues.initializeTheme();
  
  // Verificar si hay una sesión activa y si se debe mantener
  final isLoggedIn = await SessionManager.isLoggedIn();
  final keepSession = await SessionManager.getKeepSession();
  final initialRoute = (isLoggedIn && keepSession) ? '/dash' : '/login';
  //======================================================
  
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
            '/todof': (context) => const TodoFirebaseScreen(),
            '/signup': (context) => const SignUpScreen(),
            '/popular': (context) => const PopularScreen(),
            '/detail': (context) => DetailPopularScreen(),
            '/viajes1': (context) => const ViajesScreen1(),
            '/viajes2': (context) => const ViajesScreen2(),
            '/viajes3': (context) => const ViajesScreen3(),
            '/negocio': (context) => NegocioScreen(),
            '/map': (context) => GoogleMapScreen(),
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
