import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/sign_up_screen.dart';
import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:flutter_application_1/services/auth_firebase.dart';
import 'package:flutter_application_1/database/user_databa.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  AuthFirebase? auth;
  final UserDatabase _localDb = UserDatabase();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final bool _isLogin = true;

  @override
  void initState() {
    super.initState();
    auth = AuthFirebase();
  }

  Future<bool> _checkInternetConnection() async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult != ConnectivityResult.none;
  }

  Future<bool> _authenticateUser(String email, String password) async {
    bool hasInternet = await _checkInternetConnection();

    if (hasInternet) {
      try {
        // Intenta primero con Firebase
        bool firebaseResult = await auth?.loginUser(email, password) ?? false;
        if (firebaseResult) {
          return true;
        }
      } catch (e) {
        print('Error en autenticación Firebase: $e');
      }
    }

    // Si Firebase falla o no hay internet, intenta con la base local
    final localUser = await _localDb.login(email, password);
    return localUser != null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isLogin ? 'Login' : 'Registro'),
      ),
      body: Container(
        height: double.infinity, // Altura completa
        width: double.infinity, // Ancho completo
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/wallpaper.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.5),
          ),
          child: Center(
            child: Container(
              width: double.infinity,
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.5,
                maxWidth: 400, // Ancho máximo del formulario
              ),
              margin: const EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor.withOpacity(0.9),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _passwordController,
                        decoration: const InputDecoration(
                          labelText: 'Contraseña',
                          border: OutlineInputBorder(),
                        ),
                        obscureText: true,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () async {
                          final email = _emailController.text;
                          final password = _passwordController.text;

                          if (email.isEmpty || password.isEmpty) {
                            ArtSweetAlert.show(
                              context: context,
                              artDialogArgs: ArtDialogArgs(
                                type: ArtSweetAlertType.warning,
                                title: "Error",
                                text: "Por favor complete todos los campos",
                              ),
                            );
                            return;
                          }

                          bool isAuthenticated =
                              await _authenticateUser(email, password);

                          if (isAuthenticated) {
                            Navigator.pushReplacementNamed(context, '/dash');
                          } else {
                            ArtSweetAlert.show(
                              context: context,
                              artDialogArgs: ArtDialogArgs(
                                type: ArtSweetAlertType.danger,
                                title: "Error",
                                text: "Credenciales incorrectas",
                              ),
                            );
                          }
                        },
                        child:
                            Text(_isLogin ? 'Iniciar Sesión' : 'Registrarse'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignUpScreen()),
                          );
                        },
                        child: const Text(
                          "¿No tienes cuenta? Regístrate",
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
