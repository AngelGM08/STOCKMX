import 'package:flutter/material.dart';

class InsumosForm extends StatelessWidget {
  const InsumosForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Insumos')),
      body: const Center(
        child: Text(
          'Aquí irá el formulario de Insumos',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
