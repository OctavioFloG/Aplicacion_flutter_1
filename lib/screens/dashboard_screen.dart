import 'package:dark_light_button/dark_light_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/utils/global_values.dart';
import 'package:flutter_application_1/utils/theme_settings.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bienvenidos"),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: DarlightButton(
            type: Darlights.DarlightFour,
            onChange: (value) {
              // Alternar entre temas claro y oscuro
              if(value==ThemeMode.light){
                GlobalValues.themeApp.value = ThemeSettings.lightTheme();
              }else{
                GlobalValues.themeApp.value = ThemeSettings.darkTheme();
              }
            },
            options: DarlightFourOption()),
          ),
        ],
      ),
      

      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              padding: EdgeInsets.all(0),
                child: UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundImage:
                    NetworkImage("https://i.pravatar.cc/150?img=35"),
              ),
              accountName: Text("Octavio Flores Galvan"),
              accountEmail: Text("octavio.flores@gmail.com"),
            )),
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
