import 'package:flutter/material.dart';
import 'package:flutter_application_1/utils/global_values.dart';
import 'package:lottie/lottie.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isValidating = false;

  @override
  Widget build(BuildContext context) {
    final txtUser = TextFormField(
      decoration: InputDecoration(
          border: OutlineInputBorder(), hintText: "Introduce el usuario"),
    );

    final txtPassword = TextFormField(
      obscureText: false,
      decoration: const InputDecoration(
          border: OutlineInputBorder(), hintText: "Introduce el password"),
    );

    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
            image: DecorationImage(
          opacity: 0.4,
          fit: BoxFit.cover,
          image: AssetImage("assets/wallpaper.jpg"),
        )),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              top: 470,
              child: ValueListenableBuilder(
                valueListenable: GlobalValues.isValidating,
                builder: (context, value, child) {
                  return value ? CircularProgressIndicator() : Container();
                },
              ),
              // child: isValidating
              //     ? const CircularProgressIndicator()
              //     : Container(),
            ),
            Positioned(
                top: 150,
                height: 250,
                child: Lottie.asset("assets/tecnm.json")),
            Positioned(
                bottom: 50,
                child: Container(
                  padding: EdgeInsets.all(10),
                  height: 300,
                  width: MediaQuery.of(context).size.width * .9,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    children: [
                      txtUser,
                      SizedBox(
                        height: 10,
                      ),
                      txtPassword,
                      GestureDetector(
                          onTap: () {
                            //isValidating = true;
                            GlobalValues.isValidating.value = true;
                            Future.delayed(Duration(milliseconds: 1000)).then(
                              (value) {
                                GlobalValues.isValidating.value = false;
                                Navigator.pushNamed(context, "/dash");
                              },
                            );
                          },
                          child: Image.asset("assets/login-button.png",
                              height: 105)),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, "/signup");
                          },
                          child: Text("Registrarse"))
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
