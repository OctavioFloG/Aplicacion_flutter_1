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
      floatingActionButton:
          FloatingActionButton(onPressed: () => _dialogBuilder(context), child: Icon(Icons.add_task)),
      body: FutureBuilder(
          future: database!.SELECTALL(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  var object = snapshot.data![index];
                  return Container(
                      height: 150,
                      child: Column(
                        children: [
                          ListTile(
                            title: Text(object.titleTodo!),
                            subtitle: Text(object.dateTodo!),
                            trailing: Builder(builder: (context) {
                              if (object.sttTodo == true) {
                                return Icon(Icons.check);
                              } else {
                                return Icon(Icons.close);
                              }
                            }),
                          ),
                          Text(object.dscTodo!)
                        ],
                      ));
                },
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }),
    );
  }

  Future<void> _dialogBuilder(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          title: Text('Add Task'),
          content: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  hintText: "Nombre"
                ),
              ),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'descripcion'
                ),
              )
            ],
          ),
        );
      }
    );
  }
}
