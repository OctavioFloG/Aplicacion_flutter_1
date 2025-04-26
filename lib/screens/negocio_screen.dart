// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
    final datos = await _db.getAllVentas();
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
      appBar: AppBar(
        title: Text('Ventas y Servicios'),
        actions: [
          IconButton(
            icon: Icon(_showCalendar ? Icons.list : Icons.calendar_today),
            onPressed: () {
              setState(() {
                _showCalendar = !_showCalendar;
                // Si cambiamos a la vista de lista, reiniciamos la selección
                if (!_showCalendar) {
                  _selectedDay = null;
                }
              });
            },
          ),
        ],
      ),
      body: _showCalendar ? _buildCalendarView() : _buildListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _mostrarFormulario(context),
        child: Icon(Icons.add),
      ),
    );
  }

  // Lista de ventas sin calendario
  Widget _buildListView() {
    return _buildEventos();
  }

  // Lista de ventas con calendario
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

  Widget _buildEventos() {
    List<VentaModel> eventos;
    if (_showCalendar && _selectedDay != null) {
      eventos = _getEventosParaDia(_selectedDay!);
      if (eventos.isEmpty) {
        return Center(child: Text('No hay entregas para este día.'));
      }
    } else if (!_showCalendar) {
      eventos = _ventas.where((v) => v.status == EstadoVenta.porCumplir).toList();
      if (eventos.isEmpty) {
        return Center(child: Text('No hay entregas pendientes.'));
      }
    } else {
      return Center(child: Text('Selecciona un día para ver las entregas.'));
    }

    return ListView.builder(
      itemCount: eventos.length,
      itemBuilder: (context, index) {
        final venta = eventos[index];
        print(venta.status.toString());
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
                  text: 'Cantidad: ${venta.cantidad} | Venta: ${venta.fechaVenta} | Estado: ',
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
    );
  }

  void _mostrarEventosDelDia(BuildContext context, DateTime dia) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Entregas del ${DateFormat('dd/MM/yyyy').format(dia)}'),
        content: Container(
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

  // Método para mostrar el detalle de la venta
  void _mostrarDetalleVenta(BuildContext context, VentaModel venta) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Detalle de Entrega #${venta.idVenta}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Producto ID: ${venta.idProducto}'),
            Text('Cantidad: ${venta.cantidad}'),
            Text('Fecha de Venta: ${venta.fechaVenta}'),
            Text('Fecha de Entrega: ${venta.fechaEntrega}'),
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
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  // Método para confirmar eliminación
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

  // Método para mostrar formulario de edición
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
                    // ... Copiar los campos del formulario de creación ...
                    // Agregar selector de estado
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

  void _mostrarFormulario(BuildContext context) {
    final _cantidadController = TextEditingController();
    final _idProductoController = TextEditingController();
    DateTime _selectedFechaVenta = DateTime.now();
    DateTime _selectedFechaEntrega = DateTime.now().add(Duration(days: 1));

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
                    TextField(
                      controller: _idProductoController,
                      decoration: InputDecoration(labelText: 'ID Producto'),
                      keyboardType: TextInputType.number,
                    ),
                    TextField(
                      controller: _cantidadController,
                      decoration: InputDecoration(labelText: 'Cantidad'),
                      keyboardType: TextInputType.number,
                    ),
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
                            if (_selectedFechaEntrega
                                .isBefore(_selectedFechaVenta)) {
                              _selectedFechaEntrega =
                                  _selectedFechaVenta.add(Duration(days: 1));
                            }
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
                        _idProductoController.text.isNotEmpty) {
                      final nuevaVenta = {
                        'idProducto': int.parse(_idProductoController.text),
                        'cantidad': int.parse(_cantidadController.text),
                        'fecha_venta': DateFormat('yyyy-MM-dd')
                            .format(_selectedFechaVenta),
                        'fecha_entrega': DateFormat('yyyy-MM-dd')
                            .format(_selectedFechaEntrega),
                        'status': 'porCumplir',
                      };

                      await _db.insertVenta(nuevaVenta);
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
}
