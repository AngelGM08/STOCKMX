import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

import '../models/produccion.dart';
import '../widgets/produccion_card.dart';

class ProduccionScreen extends StatefulWidget {
  const ProduccionScreen({super.key});

  @override
  State<ProduccionScreen> createState() => _ProduccionScreenState();
}

class _ProduccionScreenState extends State<ProduccionScreen> {
  late Future<List<Produccion>> _producciones;
  

  List<Map<String, dynamic>> _tamales = [];

Future<void> fetchTamales() async {
  final response = await http.post(Uri.parse('http://10.0.2.2:8000/api/tamales'));
  if (response.statusCode == 200) {
    final List tamalesJson = json.decode(response.body);
    setState(() {
      _tamales = tamalesJson.map((e) => {
        'id': e['id_tamal'],
        'nombre': e['nombre_tamal'],
      }).toList();
    });
  }
}


   @override
  void initState() {
  super.initState();
  _producciones = fetchProducciones();
  fetchTamales(); 
}

  Future<List<Produccion>> fetchProducciones() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:8000/api/producciones'));
    if (response.statusCode == 200) {
      final List jsonList = json.decode(response.body);
      return jsonList.map((e) => Produccion.fromJson(e)).toList();
    } else {
      throw Exception('Error al cargar producciones');
    }
  }

  Future<void> _cargarTamales() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:8000/api/productos'));
    if (response.statusCode == 200) {
      final List tamalesJson = json.decode(response.body);
      setState(() {
        _tamales = tamalesJson.map((e) {
          return {
            'id': e['id'],
            'nombre': e['nombre'],
          };
        }).toList();
      });
    }
  }

  void _mostrarSnackbar(String titulo, String mensaje, ContentType tipo) {
    final snackBar = SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: titulo,
        message: mensaje,
        contentType: tipo,
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> _guardarProduccion(int id, String fecha, String cantidad, int? idTamal) async {
    final url = Uri.parse('http://10.0.2.2:8000/api/produccion/nuevo');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'id': id,
        'fecha': fecha,
        'cantidad_total': int.tryParse(cantidad),
        'id_tamal': idTamal,
      }),
    );

    final data = jsonDecode(response.body);
if (response.statusCode == 200 && data['status'] == 'ok') {
      setState(() {
        _producciones = fetchProducciones();
      });
      _mostrarSnackbar('Éxito', id == 0 ? 'Producción agregada' : 'Producción actualizada', ContentType.success);
    } else {
      _mostrarSnackbar('Error', 'No se pudo guardar', ContentType.failure);
    }
  }

  Future<void> _eliminarProduccion(int id) async {
    final confirmado = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar'),
        content: const Text('¿Deseas eliminar esta producción?'),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Cancelar')),
          ElevatedButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('Eliminar')),
        ],
      ),
    );

    if (confirmado == true) {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:8000/api/produccion/eliminar'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'id': id}),
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['status'] == 'ok') {
        setState(() {
          _producciones = fetchProducciones();
        });
        _mostrarSnackbar('Eliminado', 'Producción eliminada', ContentType.warning);
      } else {
        _mostrarSnackbar('Error', 'No se pudo eliminar', ContentType.failure);
      }
    }
  }

  void _mostrarFormularioAgregar({Produccion? produccion}) {
  final _formKey = GlobalKey<FormState>();
  String fecha = produccion?.fecha ?? '';
  String cantidad = produccion?.cantidadTotal?.toString() ?? '';
  int? idTamalSeleccionado = produccion?.idTamal;

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text(produccion == null ? '➕ Agregar Producción' : '✏️ Editar Producción'),
            content: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<int>(
                    value: idTamalSeleccionado,
                    decoration: const InputDecoration(
                      labelText: 'Tamal',
                      prefixIcon: Icon(Icons.fastfood),
                    ),
                    items: _tamales.map((tamal) {
                      return DropdownMenuItem<int>(
                        value: tamal['id'],
                        child: Text(tamal['nombre']),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        idTamalSeleccionado = value;
                      });
                    },
                    validator: (value) => value == null ? 'Seleccione un tamal' : null,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
  readOnly: true,
  controller: TextEditingController(text: fecha),
  decoration: const InputDecoration(
    labelText: 'Fecha',
    prefixIcon: Icon(Icons.calendar_today),
  ),
  onTap: () async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: fecha.isNotEmpty ? DateTime.parse(fecha) : DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      locale: const Locale("es", "MX"),
    );
    if (pickedDate != null) {
      setState(() {
        fecha = pickedDate.toIso8601String().split('T').first;
      });
    }
  },
  validator: (value) => fecha.isEmpty ? 'Seleccione la fecha' : null,
),

                  const SizedBox(height: 10),
                  TextFormField(
                    initialValue: cantidad,
                    decoration: const InputDecoration(
                      labelText: 'Cantidad Total',
                      prefixIcon: Icon(Icons.production_quantity_limits),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) => cantidad = value,
                    validator: (value) => value!.isEmpty ? 'Ingrese la cantidad' : null,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancelar'),
              ),
              ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: Text(produccion == null ? 'Guardar' : 'Actualizar'),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await _guardarProduccion(
                      produccion?.id ?? 0,
                      fecha,
                      cantidad,
                      idTamalSeleccionado,
                    );
                    Navigator.of(context).pop();
                  }
                },
              )
            ],
          );
        },
      );
    },
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF6EC),
      appBar: AppBar(
        backgroundColor: const Color(0xFF6D4C41),
        title: const Text('🏭 Producción'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _mostrarFormularioAgregar(),
        icon: const Icon(Icons.add),
        label: const Text('Agregar'),
        backgroundColor: const Color(0xFF8D6E63),
      ),
      body: FutureBuilder<List<Produccion>>(
        future: _producciones,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          if (snapshot.hasError) return Center(child: Text('Error: ${snapshot.error}'));

          final items = snapshot.data!;
          if (items.isEmpty) return const Center(child: Text('No hay producciones registradas.'));

          return Padding(
            padding: const EdgeInsets.all(10),
            child: GridView.builder(
              itemCount: items.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 3 / 4,
              ),
              itemBuilder: (context, index) {
                final produccion = items[index];
                return ProduccionCard(
                  produccion: produccion,
                  onDelete: () => _eliminarProduccion(produccion.id),
                  onEdit: () => _mostrarFormularioAgregar(produccion: produccion),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
