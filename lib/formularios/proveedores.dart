import 'dart:convert';
import 'package:flutter/material.dart';
import 'model/url.dart';
import 'model/proveedorModel.dart';
import 'package:stockmx/formularios/proveedorPage.dart';
import 'package:http/http.dart' as http;

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

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: const Color(0xFFE3F2FD), // Azul claro suave
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF448AFF), // Azul oscuro
        title: Row(
          children: const [
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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            color: const Color(0xFFE3F2FD), // Fondo azul claro
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TextFormField(controller: txtNombre, decoration: _inputDecoration('Nombre')),
                  const SizedBox(height: 16),
                  TextFormField(controller: txtApellidoP, decoration: _inputDecoration('Apellido Paterno')),
                  const SizedBox(height: 16),
                  TextFormField(controller: txtApellidoM, decoration: _inputDecoration('Apellido Materno')),
                  const SizedBox(height: 16),
                  TextFormField(controller: txtTelefono, decoration: _inputDecoration('Teléfono')),
                  const SizedBox(height: 16),
                  TextFormField(controller: txtEmail, decoration: _inputDecoration('Email')),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                            Navigator.push(context, MaterialPageRoute(builder: (_) => const ProveedorPage()));
                          }
                        },
                        icon: const Icon(Icons.save),
                        label: const Text('Guardar'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2196F3), // Azul medio
                        ),
                      ),
                      if (widget.idProveedor != 0)
                        ElevatedButton.icon(
                          onPressed: () async {
                            final response = await http.post(
                              Uri.parse('${Url.urlServer}/api/proveedor/eliminar'),
                              body: jsonEncode({'id': widget.idProveedor}),
                              headers: {'Content-Type': 'application/json; charset=UTF-8'},
                            );
                            if (response.body == "ok") {
                              Navigator.push(context, MaterialPageRoute(builder: (_) => const ProveedorPage()));
                            }
                          },
                          icon: const Icon(Icons.delete),
                          label: const Text('Eliminar'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF90A4AE), // Gris azulado
                          ),
                        ),
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



