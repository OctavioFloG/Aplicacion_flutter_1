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

  // CRUD de venta

  Future<List<Map<String, dynamic>>> getAllVentas() async {
    Database? db = await database;
    return await db!.query('venta');
  }

  Future<int> insertVenta(Map<String, dynamic> row) async {
    Database? db = await database;
    return await db!.insert('venta', row);
  }

  Future<int> updateVenta(Map<String, dynamic> row) async {
    Database? db = await database;
    return await db!.update('venta', row, where: 'idVenta = ?', whereArgs: [row['idVenta']]);
  }

  Future<int> deleteVenta(int id) async {
    Database? db = await database;
    return await db!.delete('venta', where: 'idVenta = ?', whereArgs: [id]);
  }

  // CRUD de producto
  
  // Future<List<Map<String, dynamic>>> getAllProductos() async {
  //   Database? db = await database;
  //   return await db!.query('producto');
  // }

  // Future<int> insertProducto(Map<String, dynamic> row) async {
  //   Database? db = await database;
  //   return await db!.insert('producto', row);
  // }

  // Future<int> updateProducto(Map<String, dynamic> row) async {
  //   Database? db = await database;
  //   return await db!.update('producto', row, where: 'idProducto = ?', whereArgs: [row['idProducto']]);
  // }

  // Future<int> deleteProducto(int id) async {
  //   Database? db = await database;
  //   return await db!.delete('producto', where: 'idProducto = ?', whereArgs: [id]);
  // }

  
}