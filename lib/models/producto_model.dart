class ProductoModel {
  int? idProducto;
  String? nombre;
  int? precio;
  String? dateTodo;
  int? stock;

  ProductoModel({this.idProducto, this.nombre, this.precio, this.dateTodo, this.stock});

  factory ProductoModel.fromMap(Map<String, dynamic> map) {
    return ProductoModel(
      idProducto: map['idProducto'],
      nombre: map['nombre'],
      precio: map['precio'],
      dateTodo: map['dateTodo'],
      stock: map['stock'],
    );
  }
}