import 'package:flutter/material.dart';

class ItemStudentView extends StatelessWidget {
  const ItemStudentView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: Color(0xFF006BD8)),
      ),
      height: 200,
      child: Column(
        children: [
          const ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage("https://i.pravatar.cc/150?img=35"),
            ),
            title: Text("Octavio Flores Galvan"),
            subtitle: Text("No. Control: 21031091"),
          ),
          Expanded(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.12,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(8),
                    bottomRight: Radius.circular(8)),
                color: Color(0xFFEDF3FF),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Table(
                      children: [
                        TableRow(
                          children: [
                            Center(child: Text("Semestre")),
                            Center(child: Text("Materia")),
                            Center(child: Text("Grupo Mat."))
                          ],
                        ),
                        TableRow(
                          children: [
                            Center(child: Text("6")),
                            Center(child: Text("DM13")),
                            Center(child: Text("Grupo"))
                          ]
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text("INGENIERIA EN SISTEMAS COMPUTACIONALES",
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
