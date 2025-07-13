import 'package:flutter/material.dart';

class ProductosForm extends StatelessWidget {
  const ProductosForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Productos')),
      body: const Center(
        child: Text(
          'Aquí irá el formulario de Productos',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
