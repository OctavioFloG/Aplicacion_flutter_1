import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/database/task_databa.dart';
import 'package:flutter_application_1/utils/global_values.dart';
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
        child: const Icon(Icons.add_task),
        onPressed: () => _dialogBuilder(context),
      ),
      body: ValueListenableBuilder(
        valueListenable: GlobalValues.upList,
        builder: (context, value, widget) {
          return FutureBuilder(
              future: database.SELECTALL(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                }
                if (snapshot.hasData) {
                  return ListView.separated(
                    separatorBuilder: (context, index) => const Divider(),
                    padding: EdgeInsets.all(20),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      var object = snapshot.data![index];
                      return Container(
                          decoration: BoxDecoration(color: Colors.grey),
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
                              Text(object.dscTodo!),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        conTitle.text = object.titleTodo!;
                                        conDesc.text = object.dscTodo!;
                                        conDate.text = object.dateTodo!;
                                        conStts.text =
                                            object.sttTodo.toString();

                                        _dialogBuilder(context, object.idTodo!);
                                      },
                                      icon: Icon(Icons.edit)),
                                  IconButton(
                                      onPressed: () {
                                        database
                                            .DELETE('todo', object.idTodo!)
                                            .then((value) {
                                          GlobalValues.upList.value =
                                              !GlobalValues.upList.value;
                                        });
                                      },
                                      icon: Icon(Icons.delete)),
                                ],
                              )
                            ],
                          ));
                    },
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              });
        },
      ),
    );
  }

  Future<void> _dialogBuilder(BuildContext context, [int idTodo = 0]) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: idTodo == 0 ? Text('Add Task') : Text('Edit Task'),
          content: Container(
            height: 300,
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
                      if (idTodo == 0) {
                        database.INSERTAR('todo', {
                          'titleTodo': conTitle.text,
                          'descTodo': conDesc.text,
                          'dateTodo': conDate.text,
                          'sttTodo': false
                        }).then(
                          (value) {
                            if (value > 0) {
                              GlobalValues.upList.value =
                                  !GlobalValues.upList.value;
                              ArtSweetAlert.show(
                                  context: context,
                                  artDialogArgs: ArtDialogArgs(
                                      type: ArtSweetAlertType.success,
                                      title: 'Mensaje de la App',
                                      text: 'Datos insertados correctamente'));
                            }
                          },
                        );
                      } else {
                        database.UPDATE('todo', {
                          'idTodo' : idTodo,
                          'titleTodo': conTitle.text,
                          'descTodo': conDesc.text,
                          'dateTodo': conDate.text,
                          'sttTodo': false
                        }).then(
                          (value) {
                            if (value > 0) {
                              GlobalValues.upList.value =
                                  !GlobalValues.upList.value;
                              ArtSweetAlert.show(
                                  context: context,
                                  artDialogArgs: ArtDialogArgs(
                                      type: ArtSweetAlertType.success,
                                      title: 'Mensaje de la App',
                                      text:
                                          'Datos actualizados correctamente'));
                            }
                          },
                        );
                      }

                      conTitle.text = '';
                      conDesc.text = '';
                      conDate.text = '';
                      conStts.text = '';
                      Navigator.pop(context);
                    },
                    child: Text('Guardar'))
              ],
            ),
          ),
        );
      },
    );
  }
}
