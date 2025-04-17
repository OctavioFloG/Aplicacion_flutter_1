import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

// Modelo para Venta/Servicio
enum Estatus { porCumplir, cancelado, completado }

class VentaServicio {
  final int? id;
  final String nombre;
  final double precio;
  final int stock;
  final DateTime fecha;
  final Estatus estatus;

  VentaServicio({
    this.id,
    required this.nombre,
    required this.precio,
    required this.stock,
    required this.fecha,
    required this.estatus,
  });

  // Copia para actualizar
  VentaServicio copyWith({
    int? id,
    String? nombre,
    double? precio,
    int? stock,
    DateTime? fecha,
    Estatus? estatus,
  }) {
    return VentaServicio(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      precio: precio ?? this.precio,
      stock: stock ?? this.stock,
      fecha: fecha ?? this.fecha,
      estatus: estatus ?? this.estatus,
    );
  }
}

class NegocioScreen extends StatefulWidget {
  @override
  _NegocioScreenState createState() => _NegocioScreenState();
}

class _NegocioScreenState extends State<NegocioScreen> {
  bool _showCalendar = false; // Controla si se muestra lista o calendario
  List<VentaServicio> _ventasServicios = []; // Lista de datos en memoria
  Map<DateTime, List<VentaServicio>> _eventos = {};
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  int _nextId = 1; // Para generar IDs únicos

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    // Datos de ejemplo
    _ventasServicios = [
      VentaServicio(
        id: _nextId++,
        nombre: 'Servicio de Limpieza',
        precio: 50.0,
        stock: 10,
        fecha: DateTime.now(),
        estatus: Estatus.porCumplir,
      ),
      VentaServicio(
        id: _nextId++,
        nombre: 'Venta de Producto A',
        precio: 25.99,
        stock: 5,
        fecha: DateTime.now().add(Duration(days: 1)),
        estatus: Estatus.porCumplir,
      ),
      VentaServicio(
        id: _nextId++,
        nombre: 'Servicio Cancelado',
        precio: 100.0,
        stock: 0,
        fecha: DateTime.now(),
        estatus: Estatus.cancelado,
      ),
      VentaServicio(
        id: _nextId++,
        nombre: 'Servicio Completado',
        precio: 75.0,
        stock: 3,
        fecha: DateTime.now().subtract(Duration(days: 1)),
        estatus: Estatus.completado,
      ),
    ];
    _cargarEventos();
  }

  // Cargar eventos para el calendario
  void _cargarEventos() {
    setState(() {
      _eventos = {};
      for (var venta in _ventasServicios) {
        final date = DateTime(venta.fecha.year, venta.fecha.month, venta.fecha.day);
        _eventos[date] = _eventos[date] ?? [];
        _eventos[date]!.add(venta);
      }
    });
  }

  // Obtener eventos para un día específico
  List<VentaServicio> _getEventosParaDia(DateTime day) {
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

  // Vista de lista
  Widget _buildListView() {
    final pendientes = _ventasServicios.where((v) => v.estatus == Estatus.porCumplir).toList();
    if (pendientes.isEmpty) {
      return Center(child: Text('No hay ventas/servicios pendientes.'));
    }
    return ListView.builder(
      itemCount: pendientes.length,
      itemBuilder: (context, index) {
        final venta = pendientes[index];
        return ListTile(
          title: Text(venta.nombre),
          subtitle: Text(
            'Precio: \$${venta.precio.toStringAsFixed(2)} | Stock: ${venta.stock} | Fecha: ${DateFormat('dd/MM/yyyy').format(venta.fecha)}',
          ),
          trailing: IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              setState(() {
                _ventasServicios.removeWhere((v) => v.id == venta.id);
                _cargarEventos();
              });
            },
          ),
        );
      },
    );
  }

  // Vista de calendario
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
                    final venta = event as VentaServicio;
                    Color color;
                    switch (venta.estatus) {
                      case Estatus.porCumplir:
                        color = Colors.green;
                        break;
                      case Estatus.cancelado:
                        color = Colors.red;
                        break;
                      case Estatus.completado:
                        color = Colors.white;
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

  // Mostrar eventos del día seleccionado
  Widget _buildEventosDiaSeleccionado() {
    final eventos = _getEventosParaDia(_selectedDay!);
    if (eventos.isEmpty) {
      return Center(child: Text('No hay ventas/servicios para este día.'));
    }
    return ListView.builder(
      itemCount: eventos.length,
      itemBuilder: (context, index) {
        final venta = eventos[index];
        return ListTile(
          title: Text(venta.nombre),
          subtitle: Text(
            'Precio: \$${venta.precio.toStringAsFixed(2)} | Stock: ${venta.stock} | Estatus: ${venta.estatus.toString().split('.').last}',
          ),
          leading: CircleAvatar(
            backgroundColor: venta.estatus == Estatus.porCumplir
                ? Colors.green
                : venta.estatus == Estatus.cancelado
                    ? Colors.red
                    : Colors.white,
            radius: 10,
          ),
        );
      },
    );
  }

  // Formulario para agregar una nueva venta/servicio
  void _mostrarFormulario(BuildContext context) {
    final _nombreController = TextEditingController();
    final _precioController = TextEditingController();
    final _stockController = TextEditingController();
    DateTime _selectedDate = DateTime.now();
    Estatus _selectedEstatus = Estatus.porCumplir;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text('Agregar Venta/Servicio'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _nombreController,
                      decoration: InputDecoration(labelText: 'Nombre'),
                    ),
                    TextField(
                      controller: _precioController,
                      decoration: InputDecoration(labelText: 'Precio'),
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                    ),
                    TextField(
                      controller: _stockController,
                      decoration: InputDecoration(labelText: 'Stock'),
                      keyboardType: TextInputType.number,
                    ),
                    ListTile(
                      title: Text('Fecha: ${DateFormat('dd/MM/yyyy').format(_selectedDate)}'),
                      trailing: Icon(Icons.calendar_today),
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: _selectedDate,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2030),
                        );
                        if (picked != null) {
                          setDialogState(() {
                            _selectedDate = picked;
                          });
                        }
                      },
                    ),
                    DropdownButton<Estatus>(
                      value: _selectedEstatus,
                      items: Estatus.values.map((estatus) {
                        return DropdownMenuItem(
                          value: estatus,
                          child: Text(estatus.toString().split('.').last),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setDialogState(() {
                          _selectedEstatus = value!;
                        });
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
                  onPressed: () {
                    if (_nombreController.text.isNotEmpty &&
                        _precioController.text.isNotEmpty &&
                        _stockController.text.isNotEmpty) {
                      setState(() {
                        _ventasServicios.add(VentaServicio(
                          id: _nextId++,
                          nombre: _nombreController.text,
                          precio: double.parse(_precioController.text),
                          stock: int.parse(_stockController.text),
                          fecha: _selectedDate,
                          estatus: _selectedEstatus,
                        ));
                        _cargarEventos();
                      });
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