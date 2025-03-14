import 'package:flutter/material.dart';

class TodoFirebaseScreenState extends StatefulWidget {
  const TodoFirebaseScreenState({super.key});

  @override
  State<TodoFirebaseScreenState> createState() => _TodoFirebaseScreenState();
 
}

class _TodoFirebaseScreenState extends State<TodoFirebaseScreenState> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Tareas'),
      ),
      body: StreamBuilder(
        // stream: stream,
        builder: (context,snapshot){

        }
      )
    );
  }
  
}