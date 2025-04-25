class ProductoModel {
  int? idProducto;
  String? nombre;
  int? precio;
  int? stock;
  int? idCategoria;

  ProductoModel({this.idProducto, this.nombre, this.precio, this.stock, this.idCategoria});

  factory ProductoModel.fromMap(Map<String, dynamic> map) {
    return ProductoModel(
      idProducto: map['idProducto'],
      nombre: map['nombre'],
      precio: map['precio'],
      stock: map['stock'],
      idCategoria: map['idCategoria'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'idProducto': idProducto,
      'nombre': nombre,
      'precio': precio,
      'stock': stock,
      'idCategoria': idCategoria,
    };
  }
}