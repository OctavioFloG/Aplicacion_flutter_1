import 'package:flutter/material.dart';
import 'package:flutter_application_1/database/task_databa.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  TaskDatabase? database;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    database = TaskDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("TodoList"),
      ),
      body: FutureBuilder(
          future: database!.SELECTALL(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text("Algo ha ocurrido"),
              );
            }
            if (snapshot.hasData) {
              return ListView.builder(
                itemBuilder: (context, index) {},
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}
