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
        await db.execute('''CREATE TABLE categoria (
          idCategoria INTEGER PRIMARY KEY,
          nombre VARCHAR(50) NOT NULL
        )''');

        await db.execute('''CREATE TABLE producto (
          idProducto INTEGER PRIMARY KEY,
          nombre VARCHAR(100),
          precio REAL,
          stock INTEGER,
          idCategoria INTEGER,
          FOREIGN KEY (idCategoria) REFERENCES categoria(idCategoria)
        )''');

        await db.execute('''CREATE TABLE venta (
          idVenta INTEGER PRIMARY KEY,
          idProducto INTEGER,
          cantidad INTEGER,
          fecha_venta DATE,
          fecha_entrega DATE,
          status VARCHAR(20),
          FOREIGN KEY (idProducto) REFERENCES producto(idProducto)
        )''');
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

    // Insertar categorías
    await db.rawInsert('''
      INSERT INTO categoria (nombre) VALUES 
      ('Categoria1'),
      ('Categoria2'),
      ('Categoria3')
    ''');

    // Modificar la inserción de productos para incluir categoría
    await db.rawInsert('''
      INSERT INTO producto (nombre, precio, stock, idCategoria) VALUES 
      ('Producto1', 50.0, 10, 1),
      ('Producto2', 75.0, 5, 2),
      ('Producto3', 100.0, 3, 3)
    ''');

    await db.rawInsert('''
      INSERT INTO venta (idProducto, cantidad, fecha_venta, fecha_entrega, status) VALUES 
      (1, 2, '${formatDate(DateTime.now())}', '${formatDate(DateTime.now().add(Duration(days: 2)))}', 'porCumplir'),
      (2, 1, '${formatDate(DateTime.now())}', '${formatDate(DateTime.now().add(Duration(days: 1)))}', 'cancelado'),
      (3, 3, '${formatDate(DateTime.now().subtract(Duration(days: 1)))}', '${formatDate(DateTime.now().add(Duration(days: 3)))}', 'completado')
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

  Future<List<Map<String, dynamic>>> getVentasByStatus(String status) async {
    Database? db = await database;
    return await db!.query(
      'venta',
      where: 'status = ?',
      whereArgs: [status],
      orderBy: 'fecha_entrega ASC',
    );
  }

  // CRUD de producto

  Future<List<Map<String, dynamic>>> getAllProductos() async {
    Database? db = await database;
    return await db!.query('producto');
  }

  Future<int> insertProducto(Map<String, dynamic> row) async {
    Database? db = await database;
    return await db!.insert('producto', row);
  }

  Future<int> updateProducto(Map<String, dynamic> row) async {
    Database? db = await database;
    return await db!.update('producto', row, where: 'idProducto = ?', whereArgs: [row['idProducto']]);
  }

  Future<int> deleteProducto(int id) async {
    Database? db = await database;
    return await db!.delete('producto', where: 'idProducto = ?', whereArgs: [id]);
  } 

  // CRUD de categoría

  Future<List<Map<String, dynamic>>> getAllCategorias() async {
    Database? db = await database;
    return await db!.query('categoria');
  }

  Future<int> insertCategoria(Map<String, dynamic> row) async {
    Database? db = await database;
    return await db!.insert('categoria', row);
  }

  Future<int> updateCategoria(Map<String, dynamic> row) async {
    Database? db = await database;
    return await db!.update('categoria', row, 
      where: 'idCategoria = ?', 
      whereArgs: [row['idCategoria']]
    );
  }

  Future<int> deleteCategoria(int id) async {
    Database? db = await database;
    return await db!.delete('categoria', 
      where: 'idCategoria = ?', 
      whereArgs: [id]
    );
  }

  Future<List<Map<String, dynamic>>> getProductosByCategoria(int categoriaId) async {
    Database? db = await database;
    return await db!.query(
      'producto',
      where: 'idCategoria = ?',
      whereArgs: [categoriaId],
    );
  }
}