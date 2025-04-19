enum EstadoVenta {
  porCumplir,
  cancelado,
  completado
}

class VentaModel {
  int idVenta;
  int idProducto;
  int cantidad;
  String fechaVenta;
  String fechaEntrega;
  EstadoVenta status;
  
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
      status: EstadoVenta.values.firstWhere(
        (e) => e.toString().split('.').last == map['status'],
        orElse: () => EstadoVenta.porCumplir
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'idVenta': idVenta,
      'idProducto': idProducto,
      'cantidad': cantidad,
      'fecha_venta': fechaVenta,
      'fecha_entrega': fechaEntrega,
      'status': status.toString().split('.').last,
    };
  }
}
