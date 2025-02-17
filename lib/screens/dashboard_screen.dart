import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Bienvenidos"),),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(child: 
             UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage("https://i.pravatar.cc/150?img=35"),
              ),
              accountName: Text("Octavio Flores Galvan"),
              accountEmail: Text("octavio.flores@gmail.com"),
             )
            ),
            ListTile(
              title: Text("Práctica Figma"),
              subtitle: Text("Frontend App"),
              leading: Icon(Icons.design_services),
              trailing: Icon(Icons.chevron_right),
              onTap: () => Navigator.pushNamed(context, "/viajes1"),
            )
          ],
        ),
      ),
      //endDrawer: Drawer(),
    );
  }
}