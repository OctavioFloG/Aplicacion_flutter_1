

import 'package:sqflite/sqflite.dart';

class NegocioDatabase {
  static const String NAMEDB = 'ventas.db';
  static const int VERSIONDB = 1;

  static Database? _database;

  Future<Database?> get database async {
    if( _database != null ) return _database!;
    return _database = await initDatabase();
  }
  
  initDatabase() {
    return openDatabase(NAMEDB, version: VERSIONDB, onCreate: (Database db, int version) async {
      await db.execute('''
        CREATE TABLE producto(
          idProducto integer primary key,
          nombre varchar(100),
          precio numeric,
        );
        CREATE TABLE venta(
          idVenta integer primary key,
          idProducto integer,
          cantidad integer,
          fecha_venta datetime,
          fecha_entrega datetime,
          FOREIGN KEY (idProducto) REFERENCES producto(idProducto)
        );
      ''');
    });
  }

}