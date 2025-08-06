import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:stockmx/formularios/model/proveedorModel.dart';
import 'package:stockmx/formularios/proveedorPage.dart';
import 'package:http/http.dart' as http;
import 'model/url.dart';

class ProveedoresForm extends StatefulWidget {
  final int idProveedor;
  const ProveedoresForm({super.key, required this.idProveedor});

  @override
  State<ProveedoresForm> createState() => _ProveedoresFormState();
}

class _ProveedoresFormState extends State<ProveedoresForm> {
  final TextEditingController txtNombre = TextEditingController();
  final TextEditingController txtApellidoP = TextEditingController();
  final TextEditingController txtApellidoM = TextEditingController();
  final TextEditingController txtTelefono = TextEditingController();
  final TextEditingController txtEmail = TextEditingController();

  Future<void> cargarProveedor() async {
    final response = await http.get(
      Uri.parse('${Url.urlServer}/api/proveedor/${widget.idProveedor}'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
    );
    Map<String, dynamic> responseJson = jsonDecode(response.body);
    final proveedor = ProveedorModel.fromJson(responseJson);

    txtNombre.text = proveedor.nombre;
    txtApellidoP.text = proveedor.apellidoPaterno;
    txtApellidoM.text = proveedor.apellidoMaterno;
    txtTelefono.text = proveedor.telefono;
    txtEmail.text = proveedor.email;
  }

  @override
  void initState() {
    super.initState();
    if (widget.idProveedor != 0) {
      cargarProveedor();
    }
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: const Color(0xFFFFF8E7), // Color claro
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8), // Cuadro más cuadrado
        borderSide: const BorderSide(color: Color(0xFF6D4C41), width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      prefixIcon: Icon(
        icon,
        color: const Color(0xFF6D4C41),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF6D4C41), // Color de appBar
        title: const Row(
          children: [
            Icon(Icons.person, color: Colors.white), // Ícono blanco
            SizedBox(width: 8),
            Text(
              'Formulario de Proveedor',
              style: TextStyle(
                color: Colors.white, // Texto blanco
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center( // Usamos el Center widget para centrar el formulario verticalmente
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Card(
            elevation: 6,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            color: const Color(0xFFFFF8E7), // Fondo del formulario
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Icon(
                    Icons.person,
                    size: 50,
                    color: Color(0xFF6D4C41), // Icono coherente con el tema
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: txtNombre,
                    decoration: _inputDecoration('Nombre', Icons.person),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: txtApellidoP,
                    decoration: _inputDecoration('Apellido Paterno', Icons.text_fields),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: txtApellidoM,
                    decoration: _inputDecoration('Apellido Materno', Icons.text_fields),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: txtTelefono,
                    decoration: _inputDecoration('Teléfono', Icons.phone),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: txtEmail,
                    decoration: _inputDecoration('Email', Icons.email),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () async {
                          final response = await http.post(
                            Uri.parse('${Url.urlServer}/api/proveedor/nuevo'),
                            body: jsonEncode({
                              'id': widget.idProveedor,
                              'nombre': txtNombre.text,
                              'apellido_paterno': txtApellidoP.text,
                              'apellido_materno': txtApellidoM.text,
                              'telefono': txtTelefono.text,
                              'email': txtEmail.text,
                            }),
                            headers: {'Content-Type': 'application/json; charset=UTF-8'},
                          );
                          if (response.body == "ok") {
                            Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const ProveedorPage()));
                          }
                        },
                        icon: const Icon(Icons.save),
                        label: const Text('Guardar'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF8D6E63), // Color coherente con el tema
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        ),
                      ),
                      if (widget.idProveedor != 0) ...[
                        const SizedBox(width: 16),
                        ElevatedButton.icon(
                          onPressed: () async {
                            final response = await http.post(
                              Uri.parse('${Url.urlServer}/api/proveedor/eliminar'),
                              body: jsonEncode({'id': widget.idProveedor}),
                              headers: {'Content-Type': 'application/json; charset=UTF-8'},
                            );
                            if (response.body == "ok") {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => const ProveedorPage()));
                            }
                          },
                          icon: const Icon(Icons.delete),
                          label: const Text('Eliminar'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF8D6E63), // Gris coherente con el tema
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
