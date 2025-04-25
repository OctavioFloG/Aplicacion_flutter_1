enum EstadoVenta {
  porCumplir,
  cancelado,
  completado
}

class VentaModel {
  int? idVenta;
  int? idProducto;
  int? cantidad;
  String? fechaVenta;
  String? fechaEntrega;
  EstadoVenta status = EstadoVenta.porCumplir; // Inicializar con valor por defecto

  VentaModel({
    this.idVenta,
    this.idProducto,
    this.cantidad,
    this.fechaVenta,
    this.fechaEntrega,
    EstadoVenta? status,
  }) : this.status = status ?? EstadoVenta.porCumplir;

  // Método helper para convertir string a enum
  static EstadoVenta stringToEstado(String estado) {
    switch (estado) {
      case 'porCumplir':
        return EstadoVenta.porCumplir;
      case 'completado':
        return EstadoVenta.completado;
      case 'cancelado':
        return EstadoVenta.cancelado;
      default:
        return EstadoVenta.porCumplir;
    }
  }

  factory VentaModel.fromMap(Map<String, dynamic> map) {
    return VentaModel(
      idVenta: map['idVenta'],
      idProducto: map['idProducto'],
      cantidad: map['cantidad'],
      fechaVenta: map['fecha_venta'],
      fechaEntrega: map['fecha_entrega'],
      status: stringToEstado(map['status']),
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
