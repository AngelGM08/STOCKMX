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
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    Map<String, dynamic> responseJson = jsonDecode(response.body);
    final proveedor = ProveedorModel.fromJson(responseJson);

    txtNombre.text = proveedor.nombre.toString();
    txtApellidoP.text = proveedor.apellidoPaterno.toString();
    txtApellidoM.text = proveedor.apellidoMaterno.toString();
    txtTelefono.text = proveedor.telefono.toString();
    txtEmail.text = proveedor.email.toString();
  }

  @override
  void initState() {
    super.initState();
    if (widget.idProveedor != 0) {
      cargarProveedor();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Proveedores')),
      body: ListView(
        children: [
          const Text('Nombre: '),
          TextFormField(controller: txtNombre),
          const Text('Apellido Paterno: '),
          TextFormField(controller: txtApellidoP),
          const Text('Apellido Materno: '),
          TextFormField(controller: txtApellidoM),
          const Text('Telefono: '),
          TextFormField(controller: txtTelefono),
          const Text('Email: '),
          TextFormField(controller: txtEmail),
          TextButton(
            onPressed: () async {
              final response = await http.post(
                Uri.parse('${Url.urlServer}/api/proveedor/nuevo'),
                body: jsonEncode(<String, dynamic>{
                  'id': widget.idProveedor,
                  'nombre': txtNombre.text,
                  'apellido_paterno': txtApellidoP.text,
                  'apellido_materno': txtApellidoM.text,
                  'telefono': txtTelefono.text,
                  'email': txtEmail.text,
                }),
                headers: <String, String>{
                  'Content-Type': 'application/json; charset=UTF-8',
                },
              );

              if (response.body == "ok") {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProveedorPage(),
                  ),
                );
              }
            },
            child: const Text('Guardar'),
          ),
          TextButton(
            onPressed: () async {
              final response = await http.post(
                Uri.parse('${Url.urlServer}/api/proveedor/eliminar'),
                body: jsonEncode(<String, dynamic>{'id': widget.idProveedor}),
                headers: <String, String>{
                  'Content-Type': 'application/json; charset=UTF-8',
                },
              );

              if (response.body == "ok") {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProveedorPage(),
                  ),
                );
              }
            },
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }
}
