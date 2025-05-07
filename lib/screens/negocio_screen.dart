// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/categoria_model.dart';
import 'package:flutter_application_1/models/producto_model.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter_application_1/utils/notification_service.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:flutter_application_1/database/negocio_databa.dart';
import 'package:flutter_application_1/models/venta_model.dart';

class NegocioScreen extends StatefulWidget {
  const NegocioScreen({super.key});
  @override
  _NegocioScreenState createState() => _NegocioScreenState();
}

class _NegocioScreenState extends State<NegocioScreen> {
  final NegocioDataba _db = NegocioDataba();
  bool _showCalendar = false;
  List<VentaModel> _ventas = [];
  Map<DateTime, List<VentaModel>> _eventos = {};
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  EstadoVenta? _selectedStatus;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
    final datos = _selectedStatus == null
        ? await _db.getAllVentas() // Si es null, obtener todas las ventas
        : await _db
            .getVentasByStatus(_selectedStatus.toString().split('.').last);

    setState(() {
      _ventas = datos.map((dato) => VentaModel.fromMap(dato)).toList();
      _cargarEventos();
    });
  }

  void _cargarEventos() {
    setState(() {
      _eventos = {};
      for (var venta in _ventas) {
        final date = DateTime.parse(venta.fechaEntrega!);
        final fechaKey = DateTime(date.year, date.month, date.day);
        _eventos[fechaKey] = _eventos[fechaKey] ?? [];
        _eventos[fechaKey]!.add(venta);
      }
    });
  }

  List<VentaModel> _getEventosParaDia(DateTime day) {
    final date = DateTime(day.year, day.month, day.day);
    return _eventos[date] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _showCalendar ? _buildCalendarView() : _buildEventos(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _mostrarFormularioAdd(context),
        child: Icon(Icons.add),
      ),
    );
  }

  // Opcion de calendario
  Widget _buildCalendarView() {
    return TableCalendar(
      firstDay: DateTime.utc(2020, 1, 1),
      lastDay: DateTime.utc(2030, 12, 31),
      focusedDay: _focusedDay,
      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _selectedDay = selectedDay;
          _focusedDay = focusedDay;
        });
        _mostrarEventosDelDia(context, selectedDay);
      },
      calendarFormat: CalendarFormat.month,
      eventLoader: _getEventosParaDia,
      calendarBuilders: CalendarBuilders(
        markerBuilder: (context, day, events) {
          if (events.isNotEmpty) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: events.map((event) {
                final venta = event as VentaModel;
                Color color;
                switch (venta.status.toString()) {
                  case 'EstadoVenta.completado':
                    color = Colors.grey;
                    break;
                  case 'EstadoVenta.cancelado':
                    color = Colors.red;
                    break;
                  default:
                    color = Colors.green;
                    break;
                }
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 1.0),
                  width: 6.0,
                  height: 6.0,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                );
              }).toList(),
            );
          }
          return null;
        },
      ),
    );
  }

  // Lista de ventas
  Widget _buildEventos() {
    List<VentaModel> eventos;
    if (_showCalendar && _selectedDay != null) {
      eventos = _getEventosParaDia(_selectedDay!);
      if (eventos.isEmpty) {
        return Center(child: Text('No hay entregas para este día.'));
      }
    } else if (!_showCalendar) {
      eventos =
          _ventas.where((v) => v.status == EstadoVenta.porCumplir).toList();
      if (eventos.isEmpty) {
        return Center(child: Text('No hay entregas pendientes.'));
      }
    } else {
      return Center(child: Text('Selecciona un día para ver las entregas.'));
    }

    return CustomScrollView(slivers: [
      SliverList.builder(
        itemCount: eventos.length,
        itemBuilder: (context, index) {
          final venta = eventos[index];
          String statusText = '';
          Color? textColor;
          switch (venta.status) {
            case EstadoVenta.porCumplir:
              statusText = 'Por Cumplir';
              textColor = Colors.green;
              break;
            case EstadoVenta.completado:
              statusText = 'Completado';
              textColor = Colors.grey;
              break;
            case EstadoVenta.cancelado:
              statusText = 'Cancelado';
              textColor = Colors.red;
              break;
          }
          return ListTile(
            title: Text('Entrega #${venta.idVenta}'),
            subtitle: RichText(
              text: TextSpan(
                style: DefaultTextStyle.of(context).style,
                children: [
                  TextSpan(
                    text:
                        'Cantidad: ${venta.cantidad} | Venta: ${venta.fechaVenta} | Estado: ',
                  ),
                  TextSpan(
                    text: statusText,
                    style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            leading: CircleAvatar(
              backgroundColor: venta.status == EstadoVenta.porCumplir
                  ? Colors.green
                  : venta.status == EstadoVenta.completado
                      ? Colors.grey
                      : Colors.red,
              radius: 10,
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.blue),
                  onPressed: () => _mostrarFormularioEdicion(context, venta),
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _confirmarEliminacion(context, venta),
                ),
              ],
            ),
            onTap: () => _mostrarDetalleVenta(context, venta),
          );
        },
      ),
    ]);
  }

  void _mostrarEventosDelDia(BuildContext context, DateTime dia) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Entregas del ${DateFormat('dd/MM/yyyy').format(dia)}'),
        content: SizedBox(
          width: double.maxFinite,
          height: 300, // Altura fija para el modal
          child: _buildEventos(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  // Modal de la venta
  void _mostrarDetalleVenta(BuildContext context, VentaModel venta) async {
    try {
      // Obtener los detalles del producto
      final productoData = await _db.getProducto(venta.idProducto!);
      final producto = ProductoModel.fromMap(productoData);
      
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Detalle de Entrega #${venta.idVenta}'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Producto:', style: TextStyle(fontWeight: FontWeight.bold)),
                Card(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Nombre: ${producto.nombre ?? "Sin nombre"}'),
                        Text('Precio: \$${producto.precio?.toStringAsFixed(2) ?? "0.00"}'),
                        Text('Stock disponible: ${producto.stock ?? 0}'),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Text('Detalles de la venta:', style: TextStyle(fontWeight: FontWeight.bold)),
                Card(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Cantidad: ${venta.cantidad ?? 0}'),
                        Text('Total: \$${((venta.cantidad ?? 0) * (producto.precio ?? 0)).toStringAsFixed(2)}'),
                        Text('Fecha de Venta: ${venta.fechaVenta ?? "No disponible"}'),
                        Text('Fecha de Entrega: ${venta.fechaEntrega ?? "No disponible"}'),
                        RichText(
                          text: TextSpan(
                            style: DefaultTextStyle.of(context).style,
                            children: [
                              TextSpan(text: 'Estado: '),
                              TextSpan(
                                text: venta.status.toString().split('.').last,
                                style: TextStyle(
                                  color: venta.status.toString() == 'EstadoVenta.porCumplir'
                                      ? Colors.green
                                      : venta.status.toString() == 'EstadoVenta.completado'
                                          ? Colors.grey
                                          : Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cerrar'),
            ),
          ],
        ),
      );
    } catch (e) {
      // Mostrar un diálogo de error si algo falla
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('No se pudo cargar los detalles del producto'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cerrar'),
            ),
          ],
        ),
      );
    }
  }

  // Modal de confirmación de eliminación de una venta
  void _confirmarEliminacion(BuildContext context, VentaModel venta) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirmar Eliminación'),
        content: Text('¿Estás seguro de eliminar esta entrega?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              await _db.deleteVenta(venta.idVenta!);
              await _cargarDatos();
              Navigator.pop(context);
            },
            child: Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // Modal para editar una venta
  void _mostrarFormularioEdicion(BuildContext context, VentaModel venta) {
    final _cantidadController =
        TextEditingController(text: venta.cantidad.toString());
    final _idProductoController =
        TextEditingController(text: venta.idProducto.toString());
    DateTime _selectedFechaVenta = DateTime.parse(venta.fechaVenta!);
    DateTime _selectedFechaEntrega = DateTime.parse(venta.fechaEntrega!);

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text('Editar Entrega #${venta.idVenta}'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField<EstadoVenta>(
                      value: venta.status,
                      items: EstadoVenta.values.map((estado) {
                        return DropdownMenuItem<EstadoVenta>(
                          value: estado,
                          child: Text(estado.toString().split('.').last),
                        );
                      }).toList(),
                      onChanged: (EstadoVenta? newValue) {
                        if (newValue != null) {
                          setDialogState(() {
                            venta.status = newValue;
                          });
                        }
                      },
                      decoration: InputDecoration(labelText: 'Estado'),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (_cantidadController.text.isNotEmpty &&
                        _idProductoController.text.isNotEmpty) {
                      final ventaActualizada = {
                        'idVenta': venta.idVenta,
                        'idProducto': int.parse(_idProductoController.text),
                        'cantidad': int.parse(_cantidadController.text),
                        'fecha_venta': DateFormat('yyyy-MM-dd')
                            .format(_selectedFechaVenta),
                        'fecha_entrega': DateFormat('yyyy-MM-dd')
                            .format(_selectedFechaEntrega),
                        'status': venta.status.toString().split('.').last,
                      };

                      await _db.updateVenta(ventaActualizada);
                      await _cargarDatos();
                      Navigator.pop(context);
                    }
                  },
                  child: Text('Guardar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Modal para crear una nueva venta
  void _mostrarFormularioAdd(BuildContext context) {
    final _cantidadController = TextEditingController();
    _cantidadController.text = "1";
    DateTime _selectedFechaVenta = DateTime.now();
    DateTime _selectedFechaEntrega = DateTime.now().add(Duration(days: 1));
    int? _selectedCategoriaId;
    int? _selectedProductoId;
    List<CategoriaModel> _categorias = [];
    List<ProductoModel> _productos = [];

    Future<void> _cargarCategorias() async {
      final datos = await _db.getAllCategorias();
      _categorias = datos.map((dato) => CategoriaModel.fromMap(dato)).toList();
    }

    Future<void> _cargarProductos(int categoriaId) async {
      final datos = await _db.getProductosByCategoria(categoriaId);
      _productos = datos.map((dato) => ProductoModel.fromMap(dato)).toList();
    }

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text('Nueva Venta'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Selector de Categoría
                    FutureBuilder(
                      future: _cargarCategorias(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        }
                        return DropdownButtonFormField<int>(
                          value: _selectedCategoriaId,
                          hint: Text('Seleccione una categoría'),
                          items: _categorias.map((categoria) {
                            return DropdownMenuItem(
                              value: categoria.idCategoria,
                              child: Text(categoria.nombre),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setDialogState(() {
                              _selectedCategoriaId = value;
                              _selectedProductoId = null;
                              if (value != null) {
                                _cargarProductos(value);
                              }
                            });
                          },
                        );
                      },
                    ),
                    SizedBox(height: 16),

                    // Selector de Producto
                    if (_selectedCategoriaId != null)
                      FutureBuilder(
                        future: _cargarProductos(_selectedCategoriaId!),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          }
                          return DropdownButtonFormField<int>(
                            value: _selectedProductoId,
                            hint: Text('Seleccione un producto'),
                            items: _productos.map((producto) {
                              return DropdownMenuItem(
                                value: producto.idProducto,
                                child: Text(
                                    '${producto.nombre} - \$${producto.precio}'),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setDialogState(() {
                                _selectedProductoId = value;
                              });
                            },
                          );
                        },
                      ),

                    if (_selectedProductoId != null) ...[
                      SizedBox(height: 16),
                      Builder(
                        builder: (context) {
                          ProductoModel producto = _productos.firstWhere(
                            (p) => p.idProducto == _selectedProductoId
                          );
                          
                          int cantidad = int.tryParse(_cantidadController.text) ?? 1;
                          double total = (producto.precio ?? 0) * cantidad;
                          
                          return Card(
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Text(
                                    'Stock disponible: ${producto.stock}',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('Cantidad: '),
                                      IconButton(
                                        icon: Icon(Icons.remove_circle),
                                        color: Colors.red,
                                        onPressed: () {
                                          setDialogState(() {
                                            int cantidad = int.tryParse(_cantidadController.text) ?? 0;
                                            if (cantidad > 1) {
                                              _cantidadController.text = (cantidad - 1).toString();
                                            }
                                          });
                                        },
                                      ),
                                      badges.Badge(
                                        badgeContent: Text(
                                          _cantidadController.text.isEmpty ? '1' : _cantidadController.text,
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        badgeStyle: badges.BadgeStyle(
                                          shape: badges.BadgeShape.circle,
                                          padding: EdgeInsets.all(12),
                                          badgeColor: Theme.of(context).primaryColor,
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.add_circle),
                                        color: Colors.green,
                                        onPressed: () {
                                          setDialogState(() {
                                            int cantidad = int.tryParse(_cantidadController.text) ?? 0;
                                            if (cantidad < (producto.stock ?? 0)) {
                                              _cantidadController.text = (cantidad + 1).toString();
                                            }
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Total: \$${total.toStringAsFixed(2)}',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],

                    // Selectores de fecha
                    ListTile(
                      title: Text(
                          'Fecha de Venta: ${DateFormat('dd/MM/yyyy').format(_selectedFechaVenta)}'),
                      trailing: Icon(Icons.calendar_today),
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: _selectedFechaVenta,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2030),
                        );
                        if (picked != null) {
                          setDialogState(() {
                            _selectedFechaVenta = picked;
                          });
                        }
                      },
                    ),
                    ListTile(
                      title: Text(
                          'Fecha de Entrega: ${DateFormat('dd/MM/yyyy').format(_selectedFechaEntrega)}'),
                      trailing: Icon(Icons.event),
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: _selectedFechaEntrega,
                          firstDate: _selectedFechaVenta,
                          lastDate: DateTime(2030),
                        );
                        if (picked != null) {
                          setDialogState(() {
                            _selectedFechaEntrega = picked;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (_cantidadController.text.isNotEmpty &&
                        _selectedProductoId != null) {
                      final nuevaVenta = {
                        'idProducto': _selectedProductoId,
                        'cantidad': int.parse(_cantidadController.text),
                        'fecha_venta': DateFormat('yyyy-MM-dd')
                            .format(_selectedFechaVenta),
                        'fecha_entrega': DateFormat('yyyy-MM-dd')
                            .format(_selectedFechaEntrega),
                        'status': 'porCumplir',
                      };

                      // Registrar la venta y obtener su ID
                      final idVenta = await _db.insertVenta(nuevaVenta);
                      
                      // Programar notificación para la nueva venta
                      final notificationService = NotificationService();
                      await notificationService.initialize();
                      final fechaEntrega = DateTime.parse(nuevaVenta['fecha_entrega'] as String);
                      
                      await notificationService.scheduleVentaNotification(
                        idVenta,
                        'Recordatorio de Entrega',
                        'La entrega #$idVenta está programada para ${DateFormat('dd/MM/yyyy').format(fechaEntrega)}',
                        fechaEntrega,
                      );
                      
                      await _cargarDatos();
                      Navigator.pop(context);

                      // Mostrar confirmación de notificación
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Venta registrada y notificación programada'),
                          duration: Duration(seconds: 2),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  },
                  child: Text('Guardar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Modificar AppBar para incluir filtro por status
  AppBar _buildAppBar() {
    return AppBar(
      title: Text('Ventas y Servicios'),
      actions: [
        DropdownButton<EstadoVenta?>(
          // Cambiamos a nullable
          value: _selectedStatus,
          dropdownColor: Theme.of(context).primaryColor,
          style: TextStyle(color: Colors.white),
          underline: Container(), //Para eliminar la linea del dropdown
          hint: Row(
            // Mostramos cuando no hay selección
            children: [
              Icon(Icons.filter_list, color: Colors.white),
              SizedBox(width: 8),
              Text('Todos', style: TextStyle(color: Colors.white)),
            ],
          ),
          items: [
            DropdownMenuItem<EstadoVenta?>(
              value: null, // null representa "Todos"
              child: Row(
                children: [
                  Icon(Icons.filter_list, color: Colors.white),
                  SizedBox(width: 8),
                  Text('Todos', style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
            ...EstadoVenta.values.map((estado) {
              return DropdownMenuItem(
                value: estado,
                child: Text(
                  estado.toString().split('.').last,
                  style: TextStyle(color: Colors.white),
                ),
              );
            }).toList(),
          ],
          onChanged: (EstadoVenta? newValue) {
            setState(() {
              _selectedStatus = newValue;
              _cargarDatos();
            });
          },
        ),
        // Botón para probar notificación con venta
        IconButton(
          icon: Icon(Icons.notification_add),
          onPressed: () async {
            // Obtener la primera venta pendiente
            final ventas = await _db.getVentasByStatus('porCumplir');
            if (ventas.isNotEmpty) {
              final venta = VentaModel.fromMap(ventas.last);
              final fechaEntrega = DateTime.parse(venta.fechaEntrega!);
              
              // Solo programar si la fecha de entrega es futura
              if (fechaEntrega.isAfter(DateTime.now())) {
                final notificationService = NotificationService();
                await notificationService.initialize();
                
                await notificationService.scheduleVentaNotification(
                  venta.idVenta!,
                  'Recordatorio de Entrega',
                  'La entrega #${venta.idVenta} está programada para ${DateFormat('dd/MM/yyyy').format(fechaEntrega)}',
                  fechaEntrega,
                );

                // Mostrar confirmación
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Notificación programada para 2 días antes de la entrega #${venta.idVenta}'),
                    duration: Duration(seconds: 2),
                    backgroundColor: Colors.green,
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('La fecha de entrega ya pasó'),
                    duration: Duration(seconds: 2),
                    backgroundColor: Colors.orange,
                  ),
                );
              }
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('No hay ventas pendientes para notificar'),
                  duration: Duration(seconds: 2),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
        ),
        IconButton(
          icon: Icon(_showCalendar ? Icons.list : Icons.calendar_today),
          onPressed: () {
            setState(() {
              _showCalendar = !_showCalendar;
              if (!_showCalendar) {
                _selectedDay = null;
              }
            });
          },
        ),
      ],
    );
  }
}
