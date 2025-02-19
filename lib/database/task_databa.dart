// ignore_for_file: constant_identifier_names


import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart';

class TaskDatabase {
  static const NAMEDB = "TODODB";
  static const VERSION = 1; //Etiquetar version

  static Database? _database; //Variable privada

  Future<Database?> get database async{
    if (_database != null) return _database!;//Debe existir si o si la variable (!)
    return _database = await initDatabase();
  }
  
  Future<Database?> initDatabase() async{
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path,NAMEDB);
    return openDatabase(
      path,
      version: VERSION,
      onCreate: (db, version) {
        String query = 'CREATE TABLE ...';
        db.execute(query);
      },
      );
  }
}