import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_application_1/database/user_databa.dart';
import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:flutter_application_1/screens/login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpState();
}

class _SignUpState extends State<SignUpScreen> {
  File? _image;
  final ImagePicker picker = ImagePicker();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final UserDatabase _database = UserDatabase();

  Future getImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Stack(
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundImage: _image != null
                      ? FileImage(_image!)
                      : const AssetImage('assets/default-avatar.jpg')
                          as ImageProvider,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: PopupMenuButton(
                    icon: const Icon(Icons.camera_alt),
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        child: ListTile(
                          leading: Icon(Icons.photo_camera),
                          title: Text('Tomar foto'),
                          onTap: () {
                            Navigator.pop(context);
                            getImage(ImageSource.camera);
                          },
                        ),
                      ),
                      PopupMenuItem(
                        child: ListTile(
                          leading: Icon(Icons.photo_library),
                          title: Text('Elegir de galería'),
                          onTap: () {
                            Navigator.pop(context);
                            getImage(ImageSource.gallery);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Nombre completo",
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Correo",
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Contraseña",
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: () async {
                if (_nameController.text.isEmpty ||
                    _emailController.text.isEmpty ||
                    _passwordController.text.isEmpty) {
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

                try {
                  await _database.registerUser(
                    _emailController.text,
                    _passwordController.text,
                    nombre: _nameController.text,
                    imageFile: _image, // Pasar la imagen seleccionada
                  );

                  await ArtSweetAlert.show(
                    context: context,
                    artDialogArgs: ArtDialogArgs(
                      type: ArtSweetAlertType.success,
                      title: "Éxito",
                      text: "Usuario registrado correctamente",
                    ),
                  );

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()),
                  );
                } catch (e) {
                  ArtSweetAlert.show(
                    context: context,
                    artDialogArgs: ArtDialogArgs(
                      type: ArtSweetAlertType.danger,
                      title: "Error",
                      text: "Error al registrar usuario",
                    ),
                  );
                }
              },
              child: const Text('Registrarse'),
            )
          ],
        ),
      ),
    );
  }
}
