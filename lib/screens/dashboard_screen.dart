import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/login_screen.dart';
import 'package:flutter_application_1/screens/settings_screen.dart';
import 'package:flutter_application_1/utils/global_values.dart';
import 'package:flutter_application_1/utils/session_manager.dart';
import 'dart:io';

import 'package:flutter_application_1/utils/theme_settings.dart';

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
    _loadTheme();
  }

  Future<void> _loadUserData() async {
    final userDetails = await SessionManager.getUserDetails();
    setState(() {
      userEmail = userDetails['email'];
      userImage = userDetails['imagePath'];
      userName = userDetails['nombre'];
    });
  }

  Future<void> _loadTheme() async {
    final theme = await ThemeSettings.getTheme();
    GlobalValues.themeApp.value = theme;
  }

  Future<void> _logout() async {
    // Guardar preferencia de mantener sesión antes de limpiar
    final keepSession = await SessionManager.getKeepSession();
    // Limpiar sesión
    await SessionManager.clearSession();
    // Restaurar preferencia de mantener sesión
    await SessionManager.setKeepSession(keepSession);

    if (mounted) {
      // Usar pushAndRemoveUntil para limpiar la pila de navegación
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    print(userName);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
      ),
      body: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Center(
          child: IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout, // Usar el método unificado
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
              ),
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
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            ListTile(
              title: Text("Negocio Productos Calendar"),
              subtitle: Text("Gestor de ventas de productos"),
              leading: Icon(Icons.business_center_rounded),
              trailing: Icon(Icons.chevron_right),
              onTap: () => Navigator.pushNamed(context, "/negocio"),
            ),
            ListTile(
              title: Text("Google Map"),
              subtitle: Text("Pantalla para trabajar con el mapa de google"),
              leading: Icon(Icons.map),
              trailing: Icon(Icons.chevron_right),
              onTap: () => Navigator.pushNamed(context, "/map"),
            ),
            ListTile(
              title: Text("Popular TheMovieDB"),
              subtitle: Text("Práctica consumo de API"),
              leading: Icon(Icons.movie),
              trailing: Icon(Icons.chevron_right),
              onTap: () => Navigator.pushNamed(context, "/popular"),
            ),
            ListTile(
              title: Text("Todo Firebase"),
              subtitle: Text("Firebase practica"),
              leading: Icon(Icons.book),
              trailing: Icon(Icons.chevron_right),
              onTap: () => Navigator.pushNamed(context, "/todof"),
            ),
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
            ListTile(
              title: const Text("Cerrar Sesión"),
              subtitle: const Text("Salir de la aplicación"),
              leading: const Icon(Icons.logout),
              trailing: const Icon(Icons.chevron_right),
              onTap: _logout,
            ),
          ],
        ),
      ),
    );
  }
}
