// ignore_for_file: non_constant_identifier_names, constant_identifier_names, unnecessary_import, depend_on_referenced_packages

import 'dart:io';
import 'package:flutter_application_1/models/todo_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class TaskDatabase {
  static const NAMEDB = "TODODB";
  static const VERSION = 1; //Etiquetar version

  static Database? _database; //Variable privada

  Future<Database?> get database async {
    if (_database != null) {
      return _database!; //Debe existir si o si la variable (!)
    }
    return _database = await initDatabase();
  }

  Future<Database?> initDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, NAMEDB);
    return openDatabase(
      path,
      version: VERSION,
      onCreate: (db, version) {
        String query = '''
        CREATE TABLE todo (
        idTodo integer primary key,
        titletodo varchar(35),
        dsctodo varchar(100),
        dateTodo varchar(10),
        sttTodo boolean)
        ''';
        db.execute(query);
      },
    );
  }

  dynamic INSERTAR(String table, Map<String, dynamic> map) async {
    final Database? con = await database;
    con!.insert('table', map);
  }

  Future<int> UPDATE(String table, Map<String, dynamic> map) async {
    final Database? con = await database;
    return con!.update(table, map,
        where: 'idTodo = ?', whereArgs: <Object?>[map['idTodo']]);
  }

  Future<int> DELETE(String table, int idTodo) async {
    final Database? con = await database;
    return con!
        .delete(table, where: 'idTodo = ?', whereArgs: <Object?>[idTodo]);
  }

  Future<List<TodoModel>> SELECTALL() async {
    final con = await database;
    var result = await con!.query('todo');
    return result.map((task) => TodoModel.fromMap(task)).toList();
  }
}
