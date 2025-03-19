import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/todo_firebase.dart';
import 'package:intl/intl.dart';

class TodoFirebaseScreen extends StatefulWidget {
  const TodoFirebaseScreen({super.key});

  @override
  State<TodoFirebaseScreen> createState() => _TodoFirebaseScreenState();
}

class _TodoFirebaseScreenState extends State<TodoFirebaseScreen> {
  TodoFirebase? todoFirebase;
  TextEditingController conTitle = TextEditingController();
  TextEditingController conDesc = TextEditingController();
  TextEditingController conDate = TextEditingController();
  TextEditingController conStts = TextEditingController();

  @override
  void initState() {
    super.initState();
    todoFirebase = TodoFirebase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Lista de Tareas'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _dialogBuilder(context),
          child: Icon(Icons.add_task),
        ),
        body: StreamBuilder(
            stream: todoFirebase!.selectTask(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var object = snapshot.data!.docs[index];
                    return Container(
                        decoration: BoxDecoration(color: Colors.grey),
                        height: 150,
                        child: Column(
                          children: [
                            ListTile(
                              title: Text(object.get('titleTodo')),
                              subtitle: Text(object.get('dscTodo')),
                              trailing: Builder(builder: (context) {
                                if (object.get('sttTodo') == "true") {
                                  return Icon(Icons.check);
                                } else {
                                  return Icon(Icons.close);
                                }
                              }),
                            ),
                            Text(object.get('dscTodo')),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                    onPressed: () {
                                      conTitle.text = object.get('titleTodo');
                                      conDesc.text = object.get('dscTodo')!;
                                      conDate.text = object.get('dateTodo');
                                      conStts.text = object.get('sttTodo');

                                      _dialogBuilder(context, object.id);
                                    },
                                    icon: Icon(Icons.edit)),
                                IconButton(
                                    onPressed: () {
                                      todoFirebase!.deleteTask(object.id);
                                    },
                                    icon: Icon(Icons.delete)),
                              ],
                            )
                          ],
                        ));
                  },
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text("Error"),
                );
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            }));
  }

  Future<void> _dialogBuilder(BuildContext context, [String idTodo = "0"]) {
    return showDialog(
      context: context,
      builder: (context) {
        var btnText;
        if (idTodo == "0") {
          btnText = "Añadir";
        } else {
          btnText = "Guardar";
        }
        return AlertDialog(
          title: idTodo == 0 ? Text('Add Task') : Text('Edit Task'),
          content: Container(
            height: 340,
            width: 310,
            child: ListView(
              shrinkWrap: true,
              children: [
                TextFormField(
                  controller: conTitle,
                  decoration: InputDecoration(hintText: 'Título de la tarea'),
                ),
                TextFormField(
                  controller: conDesc,
                  maxLines: 3,
                  decoration:
                      InputDecoration(hintText: 'Descripción de la tarea'),
                ),
                TextFormField(
                  readOnly: true,
                  controller: conDate,
                  decoration: InputDecoration(hintText: 'Fecha de la tarea'),
                  onTap: () async {
                    DateTime? dateTodo = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
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
                  decoration: InputDecoration(hintText: 'Estatus de la tarea'),
                ),
                Divider(),
                ElevatedButton(
                  onPressed: () {
                    if (idTodo == "0") {
                      todoFirebase!.addTask({
                        'titleTodo': conTitle.text,
                        'dscTodo': conDesc.text,
                        'dateTodo': conDate.text,
                        'sttTodo': conStts.text
                      }).then((value) {
                        ArtSweetAlert.show(
                            context: context,
                            artDialogArgs: ArtDialogArgs(
                                type: ArtSweetAlertType.success,
                                title: 'Mensaje de la App',
                                text: 'Datos insertados correctamente'));
                      });
                    } else {
                      todoFirebase!.updateTask({
                        'titleTodo': conTitle.text,
                        'dscTodo': conDesc.text,
                        'dateTodo': conDate.text,
                        'sttTodo': conStts.text
                      }, idTodo).then((value) {
                        ArtSweetAlert.show(
                            context: context,
                            artDialogArgs: ArtDialogArgs(
                                type: ArtSweetAlertType.success,
                                title: 'Mensaje de la App',
                                text: 'Datos actualizados correctamente'));
                      });
                    }
                    conTitle.text = '';
                    conDesc.text = '';
                    conDate.text = '';
                    conStts.text = '';
                    Navigator.pop(context);
                  },
                  child: Text(btnText),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
