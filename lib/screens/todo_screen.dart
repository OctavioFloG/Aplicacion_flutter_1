import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/database/task_databa.dart';
import 'package:intl/intl.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  late TaskDatabase database;
  TextEditingController conTitle = TextEditingController();
  TextEditingController conDesc = TextEditingController();
  TextEditingController conDate = TextEditingController();
  TextEditingController conStts = TextEditingController();

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
      floatingActionButton: FloatingActionButton(
          onPressed: () => _dialogBuilder(context),
          child: Icon(Icons.add_task)),
      body: FutureBuilder(
          future: database.SELECTALL(),
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
        builder: (context) {
          return AlertDialog(
            title: Text('Add Task'),
            content: SizedBox(
              height: MediaQuery.of(context).size.height * .4,
              width: MediaQuery.of(context).size.width * .9,
              child: ListView(
                children: [
                  TextFormField(
                    controller: conTitle,
                    decoration: InputDecoration(hintText: "Titulo de la tarea"),
                  ),
                  TextFormField(
                    controller: conDesc,
                    decoration:
                        InputDecoration(hintText: 'Descripcion de la tarea'),
                    maxLines: 3,
                  ),
                  TextFormField(
                    readOnly: true,
                    controller: conDate,
                    decoration: InputDecoration(hintText: 'Fecha de la tarea'),
                    onTap: () async {
                      DateTime? dateTodo = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(200),
                          lastDate: DateTime(2100));
                      if (dateTodo != null) {
                        String formattedDate =
                            DateFormat('yyyy-MM-dd').format(dateTodo);
                        setState(() {
                          conDate.text = formattedDate;
                        });
                      }
                    },
                  ),
                  TextFormField(
                    controller: conStts,
                    decoration: InputDecoration(hintText: "Status de la tarea"),
                  ),
                  Divider(),
                  ElevatedButton(
                      onPressed: () {
                        database.INSERTAR('todo', {
                          'titleTodo': conTitle.text,
                          'dscTodo': conDesc.text,
                          'dateTodo': conDate.text,
                          'sttTodo': conStts.text == 1 ? true : false
                        }).then((value) {
                          if (value > 0) {
                            ArtSweetAlert.show(
                                context: context,
                                artDialogArgs: ArtDialogArgs(
                                    type: ArtSweetAlertType.success,
                                    title: "Exito",
                                    text: "Datos insertados correctamente"));
                          }
                        });
                      },
                      child: Text("Guardar"))
                ],
              ),
            ),
          );
        });
  }
}
