import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpState();
}

class _SignUpState extends State<SignUpScreen> {
  File? _image;
  final ImagePicker picker = ImagePicker();

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
      body: Column(
        children: [
          SizedBox(
            height: 60,
          ),
          CircleAvatar(
            radius: 60,
            backgroundImage: _image != null
                ? FileImage(_image!)
                : const AssetImage('assets/hotel1.png')
                    as ImageProvider,
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: PopupMenuButton(
              icon: Icon(Icons.camera_alt),
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
          TextFormField(
            decoration: InputDecoration(
                border: OutlineInputBorder(), hintText: "Nombre completo"),
          ),
          TextFormField(
            obscureText: false,
            decoration: const InputDecoration(
                border: OutlineInputBorder(), hintText: "Correo"),
          ),
          TextFormField(
            obscureText: true,
            decoration: const InputDecoration(
                border: OutlineInputBorder(), hintText: "Contraseña"),
          ),
        ],
      ),
    );
  }
}
