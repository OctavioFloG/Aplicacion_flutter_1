import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class UserDatabase {
  static const String _verde = '\x1B[32m';
  static const String _rojo = '\x1B[31m';
  static const String _reset = '\x1B[0m';
  static const NAMEDB = 'USERDB';
  static const VERSIONDB = 1;

  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database!;
    return _database = await initDatabase();
  }

  Future<Database?> initDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, NAMEDB);
    return openDatabase(path, version: VERSIONDB,
        onCreate: (Database db, int version) async {
      await db.execute('''
          CREATE TABLE users (
            idUser integer primary key,
            nombre varchar(100),
            email varchar(100) UNIQUE,
            password varchar(35),
            imagePath text
          )
        ''');
      // Agregar usuario de prueba al crear la base de datos
      await _insertarUsuarioPrueba(db);
    });
  }

  // Método para insertar usuario de prueba
  Future<void> _insertarUsuarioPrueba(Database db) async {
    final usuarioPrueba = {
      'nombre': 'Usuario Test',
      'email': 'test@gmail.com',
      'password': '123456',
      'imagePath': null
    };

    try {
      await db.insert('users', usuarioPrueba);
      print('$_verde✓ Usuario de prueba creado exitosamente $_reset');
    } catch (e) {
      print('$_rojo✗ Error al crear usuario de prueba: $e$_reset');
    }
  }

  Future<int> registerUser(String email, String password,
      {String? nombre, File? imageFile}) async {
    final Database? db = await database;
    String? imagePath;

    if (imageFile != null) {
      // Guardar la imagen en el almacenamiento local
      final Directory directory = await getApplicationDocumentsDirectory();
      final String fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      final String filePath = join(directory.path, fileName);

      // Copiar la imagen al almacenamiento local
      await imageFile.copy(filePath);
      imagePath = filePath;
    }

    // Verificar si el correo ya existe
    final existingUser = await db!.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );

    if (existingUser.isNotEmpty) {
      throw Exception('El correo ya está registrado');
    }

    return await db.insert('users', {
      'email': email,
      'password': password,
      'nombre': nombre,
      'imagePath': imagePath,
    });
  }

  Future<Map<String, dynamic>?> login(String email, String password) async {
    final Database? db = await database;
    final results = await db!.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
    return results.isNotEmpty ? results.first : null;
  }
}
