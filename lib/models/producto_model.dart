class ProductoModel {
  int? idProducto;
  String? nombre;
  int? precio;
  int? stock;

  ProductoModel({this.idProducto, this.nombre, this.precio, this.stock});

  factory ProductoModel.fromMap(Map<String, dynamic> map) {
    return ProductoModel(
      idProducto: map['idProducto'],
      nombre: map['nombre'],
      precio: map['precio'],
      stock: map['stock'],
    );
  }
}