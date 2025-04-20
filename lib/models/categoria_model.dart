class CategoriaModel {
  int idCategoria;
  String nombre;
  
  CategoriaModel({
    required this.idCategoria,
    required this.nombre
  });

  factory CategoriaModel.fromMap(Map<String, dynamic> map) {
    return CategoriaModel(
      idCategoria: map['idCategoria'],
      nombre: map['nombre']
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'idCategoria': idCategoria,
      'nombre': nombre
    };
  }
}