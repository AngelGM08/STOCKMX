import 'package:flutter/material.dart';

class ProveedoresForm extends StatelessWidget {
  const ProveedoresForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Proveedores')),
      body: const Center(
        child: Text(
          'Aquí irá el formulario de Proveedores',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
