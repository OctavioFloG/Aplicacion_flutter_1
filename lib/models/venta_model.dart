class VentaModel {
  int idVenta;
  int idProducto;
  int cantidad;
  String fechaVenta;
  String fechaEntrega;
  String status;
  
  VentaModel({
    required this.idVenta,
    required this.idProducto,
    required this.cantidad,
    required this.fechaVenta,
    required this.fechaEntrega,
    required this.status,
  });

  factory VentaModel.fromMap(Map<String, dynamic> map) {
    return VentaModel(
      idVenta: map['idVenta'],
      idProducto: map['idProducto'],
      cantidad: map['cantidad'],
      fechaVenta: map['fecha_venta'],
      fechaEntrega: map['fecha_entrega'],
      status: map['status'],
    );
  }
}
