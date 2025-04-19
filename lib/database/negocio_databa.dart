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
          stock INTEGER
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
        // Insertar datos de prueba al crear la base de datos
      await _insertarDatosPrueba(db);
      },
    );
  }

  // Datos de prueba
  
  Future<void> _insertarDatosPrueba(Database db) async {
    // Función auxiliar para formatear fecha
    String formatDate(DateTime date) {
      return "${date.year}-${date.month.toString().padLeft(2,'0')}-${date.day.toString().padLeft(2,'0')}";
    }

    // Primero insertamos productos
    await db.rawInsert('''
      INSERT INTO producto (nombre, precio, stock) VALUES 
      ('Servicio de Limpieza', 50.0, 10),
      ('Servicio de Jardinería', 75.0, 5),
      ('Servicio de Reparación', 100.0, 3)
    ''');

    // Luego insertamos ventas con solo fecha
    await db.rawInsert('''
      INSERT INTO venta (idProducto, cantidad, fecha_venta, fecha_entrega, status) VALUES 
      (1, 2, '${formatDate(DateTime.now())}', '${formatDate(DateTime.now().add(Duration(days: 2)))}', 'porCumplir'),
      (2, 1, '${formatDate(DateTime.now())}', '${formatDate(DateTime.now().add(Duration(days: 1)))}', 'cancelado'),
      (3, 3, '${formatDate(DateTime.now().subtract(Duration(days: 1)))}', '${formatDate(DateTime.now().add(Duration(days: 3)))}', 'completado'),
      (1, 1, '${formatDate(DateTime.now().add(Duration(days: 1)))}', '${formatDate(DateTime.now().add(Duration(days: 5)))}', 'porCumplir')
    ''');
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