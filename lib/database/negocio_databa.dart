import 'package:sqflite/sqflite.dart';

class NegocioDataba {
  static const NAMEDB = 'Negocio';
  static const VERSIONDB = 1;
  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database!;
    return _database = await initDatabase();
  }
  
  Future<Database?> initDatabase() async {
    String path = await getDatabasesPath() + NAMEDB;
    return openDatabase(
      path,
      version: VERSIONDB,
      onCreate: (db, version) async{
        await db.execute('''CREATE TABLE producto (
          idProducto INTEGER PRIMARY KEY,
          nombre VARCHAR(100),
          precio REAL,
          stock INTEGER,
        )''');
        await db.execute('''CREATE TABLE venta (
          idVenta INTEGER PRIMARY KEY,
          idProducto INTEGER,
          cantidad INTEGER,
          fecha_venta DATE,
          fecha_entrega DATE,
          status char(1),
          FOREIGN KEY (idProducto) REFERENCES producto(idProducto)
        )''');
      },
    );
  }
}