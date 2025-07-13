import 'package:flutter/material.dart';

class ComprasForm extends StatelessWidget {
  const ComprasForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Compras')),
      body: const Center(
        child: Text(
          'Aquí irá el formulario de Compras',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
