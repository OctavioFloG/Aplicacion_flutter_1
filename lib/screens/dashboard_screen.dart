import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/login_screen.dart';
import 'package:flutter_application_1/screens/settings_screen.dart';
import 'package:flutter_application_1/utils/session_manager.dart';
import 'dart:io';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String? userEmail;
  String? userImage;
  String? userName;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final userDetails = await SessionManager.getUserDetails();
    setState(() {
      userEmail = userDetails['email'];
      userImage = userDetails['imagePath'];
      userName = userDetails['nombre'];
    });
  }

  @override
  Widget build(BuildContext context) {
    print(userName);
    return Scaffold(
      appBar: AppBar(
        title: Text("Bienvenidos"),
      ),
      body: Center(
          child: IconButton(
        icon: const Icon(Icons.logout),
        onPressed: () async {
          await SessionManager.logout();
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
            (route) => false,
          );
        },
      )),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
                padding: EdgeInsets.zero,
                child: UserAccountsDrawerHeader(
                  currentAccountPicture: CircleAvatar(
                    backgroundImage: userImage != null && userImage!.isNotEmpty
                        ? FileImage(File(userImage!))
                        : const AssetImage("assets/default-avatar.jpg")
                            as ImageProvider,
                  ),
                  accountName: Text(userName ?? "Usuario"),
                  accountEmail: Text(userEmail ?? ""),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                  ),
                )),
            ListTile(
              title: Text("Práctica Figma"),
              subtitle: Text("Frontend App"),
              leading: Icon(Icons.design_services),
              trailing: Icon(Icons.chevron_right),
              onTap: () => Navigator.pushNamed(context, "/viajes1"),
            ),
            ListTile(
              title: Text("Todo App"),
              subtitle: Text("Tasks Lists"),
              leading: Icon(Icons.task),
              trailing: Icon(Icons.chevron_right),
              onTap: () => Navigator.pushNamed(context, "/todo"),
            ),
            ListTile(
              title: const Text("Configuración"),
              subtitle: const Text("Preferencias de la aplicación"),
              leading: const Icon(Icons.settings),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              ),
            ),
          ],
        ),
      ),
      //endDrawer: Drawer(),
    );
  }
}
