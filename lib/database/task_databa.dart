// ignore_for_file: non_constant_identifier_names, constant_identifier_names

import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:flutter_application_1/models/todo_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class TaskDatabase {
  
  static const NAMEDB = 'TODODB';
  static const VERSIONDB = 1;

  static Database? _database;

  Future<Database?> get database async {
    if( _database != null ) return _database!;
    return _database = await initDatabase();
  }
  
  Future<Database?> initDatabase()async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path,NAMEDB);
    return openDatabase(
      path,
      version: VERSIONDB,
      onCreate: (db, version) {
        String query = '''CREATE TABLE todo ( 
          idTodo integer primary key,
          titleTodo varchar(35),
          dscTodo varchar(100),
          dateTodo varchar(10),
          sttTodo boolean
        )''';
        db.execute(query);
      },
    );
  }

  Future<int> INSERTAR(String table, Map<String,dynamic> map) async {
    final con = await database;
    return con!.insert(table, map);
  }
  Future<int> UPDATE(String table, Map<String,dynamic> map) async{
    final con = await database;
    return con!.update(table, map, where: 'idTodo = ?', whereArgs: [map['idTodo']]);
  }

  Future<int> DELETE(String table, int idTodo) async {
    final con = await database;
    return con!.delete(table, where: 'idTodo = ?', whereArgs: [idTodo]);
  }

  Future<List<TodoModel>> SELECT() async {
    final con = await database;
    var result = await con!.query('todo');
    return result.map((task) => TodoModel.fromMap(task)).toList();
  }

}