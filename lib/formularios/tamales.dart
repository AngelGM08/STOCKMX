import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:stockmx/formularios/model/tamalModel.dart';
import 'package:stockmx/formularios/tamalPage.dart';
import 'model/url.dart';
import 'package:http/http.dart' as http;

class TamalesForm extends StatefulWidget {
  final int idTamal;
  const TamalesForm({super.key, required this.idTamal});

  @override
  State<TamalesForm> createState() => _TamalesFormState();
}

class _TamalesFormState extends State<TamalesForm> {
  final TextEditingController txtNomTam = TextEditingController();
  final TextEditingController txtDescripcion = TextEditingController();
  bool isLoading = false;

  // Función para cargar el tamal
  Future<void> cargarTamal() async {
    setState(() => isLoading = true);
    try {
      final response = await http.get(
        Uri.parse('${Url.urlServer}/api/tamal/${widget.idTamal}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseJson = jsonDecode(response.body);
        final tamal = TamalModel.fromJson(responseJson);

        setState(() {
          txtNomTam.text = tamal.nomT.toString();
          txtDescripcion.text = tamal.descripcion.toString();
        });
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Error cargando tamales')));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    } finally {
      setState(() => isLoading = false);
    }
  }

  // Función para enviar el tamal
  Future<void> enviarTamal() async {
    if (txtNomTam.text.isEmpty || txtDescripcion.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, llena todos los campos')),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final response = await http.post(
        Uri.parse('${Url.urlServer}/api/tamal/nuevo'),
        body: jsonEncode(<String, dynamic>{
          'id': widget.idTamal,
          'nombre_tamal': txtNomTam.text,
          'descripcion': txtDescripcion.text,
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.body == "ok") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const TamalPage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al guardar el tamal')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    } finally {
      setState(() => isLoading = false);
    }
  }

  // Función para eliminar el tamal
  Future<void> eliminarTamal() async {
    setState(() => isLoading = true);
    try {
      final response = await http.post(
        Uri.parse('${Url.urlServer}/api/tamal/eliminar'),
        body: jsonEncode(<String, dynamic>{'id': widget.idTamal}),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.body == "ok") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const TamalPage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al eliminar el tamal')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.idTamal != 0) {
      cargarTamal();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🫔 Tamales'),
        backgroundColor: const Color(0xFF6D4C41), // Color café para el AppBar
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Center(
                child: Card(
                  margin: const EdgeInsets.all(16),
                  color: const Color(0xFFFFF8E7), // Color de fondo para el card
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.fastfood,
                          size: 50,
                          color: Color(0xFF6D4C41), // Ícono con color café
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller:
                              txtNomTam, // Controlador para nombre del tamal
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Ingrese el nombre del tamal',
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller:
                              txtDescripcion, // Controlador para la descripción
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Descripción del tamal',
                          ),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(
                              0xFF6D4C41,
                            ), // Color café para el botón
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                          ),
                          onPressed: enviarTamal, // Acción de enviar tamal
                          icon: const Icon(Icons.save),
                          label: const Text('Guardar'),
                        ),
                        if (widget.idTamal != 0) ...[
                          const SizedBox(height: 12),
                          ElevatedButton(
                            onPressed:
                                eliminarTamal, // Acción de eliminar tamal
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors
                                  .redAccent, // Botón de eliminación en rojo
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                            ),
                            child: const Text('Eliminar'),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
