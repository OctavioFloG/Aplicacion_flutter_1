import 'package:another_flutter_splash_screen/another_flutter_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/list_students_screen.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterSplashScreen(
        duration: const Duration(milliseconds: 4500),
        nextScreen: const ListStudentsScreen(),
        backgroundColor: Colors.white,
        splashScreenBody: Center(
          child: Lottie.asset("assets/tecnm.json"),
        ),
      )
    );
  }
}