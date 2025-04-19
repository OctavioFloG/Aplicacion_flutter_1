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

enum EstadoVenta { porCumplir, completado, cancelado }

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
        final date = DateTime.parse(venta.fechaEntrega);
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

  Widget _buildListView() {
    final pendientes = _ventas.where((v) => v.status.toString() == 'porCumplir').toList();
    if (pendientes.isEmpty) {
      return Center(child: Text('No hay ventas pendientes.'));
    }
    return ListView.builder(
      itemCount: pendientes.length,
      itemBuilder: (context, index) {
        final venta = pendientes[index];
        return ListTile(
          title: Text('Venta #${venta.idVenta}'),
          subtitle: Text(
            'Cantidad: ${venta.cantidad} | Entrega: ${venta.fechaEntrega} | Producto ID: ${venta.idProducto}',
          ),
          leading: CircleAvatar(
            backgroundColor: venta.status.toString() == 'EstadoVenta.porCumplir'
                ? Colors.grey 
                : venta.status.toString() == 'EstadoVenta.completado'
                    ? Colors.green 
                    : Colors.red,
            radius: 10,
          ),
        );
      },
    );
  }

  Widget _buildCalendarView() {
    return Column(
      children: [
        TableCalendar(
          firstDay: DateTime.utc(2020, 1, 1),
          lastDay: DateTime.utc(2030, 12, 31),
          focusedDay: _focusedDay,
          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
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
                        color = Colors.green;
                        break;
                      case 'EstadoVenta.cancelado':
                        color = Colors.red;
                        break;
                      default:
                        color = Colors.grey;
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
        ),
        Expanded(
          child: _buildEventosDiaSeleccionado(),
        ),
      ],
    );
  }

  Widget _buildEventosDiaSeleccionado() {
    final eventos = _getEventosParaDia(_selectedDay!);
    if (eventos.isEmpty) {
      return Center(child: Text('No hay ventas para este día.'));
    }
    return ListView.builder(
      itemCount: eventos.length,
      itemBuilder: (context, index) {
        final venta = eventos[index];
        return ListTile(
          title: Text('Entrega #${venta.idVenta}'),
          subtitle: Text(
            'Cantidad: ${venta.cantidad} | Venta: ${venta.fechaVenta} | Producto ID: ${venta.idProducto}',
          ),
          leading: CircleAvatar(
            backgroundColor: venta.status.toString() == 'EstadoVenta.porCumplir'
                ? Colors.grey 
                : venta.status.toString() == 'EstadoVenta.completado'
                    ? Colors.green 
                    : Colors.red,
            radius: 10,
          ),
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
                            if (_selectedFechaEntrega.isBefore(_selectedFechaVenta)) {
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
                        'fecha_venta': DateFormat('yyyy-MM-dd').format(_selectedFechaVenta),
                        'fecha_entrega': DateFormat('yyyy-MM-dd').format(_selectedFechaEntrega),
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
