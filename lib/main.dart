import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/dashboard_screen.dart';
import 'package:flutter_application_1/screens/list_students_screen.dart';
import 'package:flutter_application_1/screens/splash_screen.dart';
import 'package:flutter_application_1/screens/viajes_screen2.dart';
import 'package:flutter_application_1/screens/viajes_screen1.dart';
import 'package:flutter_application_1/screens/viajes_screen3.dart';
import 'package:flutter_application_1/utils/global_values.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: GlobalValues.themeApp,
        builder: (context, value, child) {
          return MaterialApp(
            theme: value,
            routes: {
              "/list": (context) => const ListStudentsScreen(),
              "/dash": (context) => const DashboardScreen(),
              // === Práctica 1 ===
              "/viajes1": (context) => const ViajesScreen1(),
              "/viajes2": (context) => const ViajesScreen2(),
              "/viajes3": (context) => const ViajesScreen3(),
            },
            title: 'Material App',
            home: const SplashScreen(),
          );
        });
  }
}
