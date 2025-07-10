import 'package:flutter/material.dart';
import 'productos_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Tamalería - Inventario")),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.kitchen),
            title: Text('Gestión de Productos'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => ProductosScreen()));
            },
          ),
        ],
      ),
    );
  }
}