import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {

    final txtUser = TextFormField(
        decoration: InputDecoration(
        border: OutlineInputBorder(),
        hintText: "Introduce el usuario"
      ),
    );

    final txtPassword = TextFormField(
      obscureText: false,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        hintText: "Introduce el password"
      ),
    );

    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
            image: DecorationImage(
              opacity: 0.6,
          fit: BoxFit.cover,
          image: AssetImage("assets/wallpaper.jpg"),
        )),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
                top: 250,
                height: 250,
                child: Lottie.asset("assets/tecnm.json")),
            Positioned(
                bottom: 50,
                child: Container(
                  padding: EdgeInsets.all(10),
                  height: 250,
                  width: MediaQuery.of(context).size.width*.9,
                  decoration: BoxDecoration(
                    color: Colors.white70,
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: Column(
                    children: [
                      txtUser,
                      SizedBox(height: 10,),
                      txtPassword,
                      Image.asset("login-button.png",height: 150)
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
