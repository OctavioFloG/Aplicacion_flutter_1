import 'package:flutter/material.dart';
import 'package:flutter_application_1/view/item_student_view.dart';

class ListStudentsScreen extends StatelessWidget {
  const ListStudentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('ALUMNOS'),
        ),
        body: ListView(
          shrinkWrap: true,
          children: [
            ListTile(
              title: Text(
                "Alumnos Grupo Base",
                style: TextStyle(fontSize: 15),
              ),
              subtitle: Text("Enero - Junio"),
              trailing: Column(
                children: [
                  Text(
                    "2024",
                    style: TextStyle(fontSize: 20),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: const [
                  ItemStudentView(),
                  SizedBox(
                    height: 20,
                  ),
                  ItemStudentView(),
                  SizedBox(
                    height: 20,
                  ),
                  ItemStudentView(),
                  SizedBox(
                    height: 20,
                  ),
                  ItemStudentView()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
