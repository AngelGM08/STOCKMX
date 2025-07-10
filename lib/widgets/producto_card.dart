import 'package:flutter/material.dart';
import '../models/producto.dart';

class ProductoCard extends StatelessWidget {
  final Producto producto;

  ProductoCard({required this.producto});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: ListTile(
        leading: Icon(Icons.fastfood),
        title: Text(producto.nombre),
        subtitle: Text('${producto.descripcion} (${producto.unidad})'),
        trailing: Text('\$${producto.precio.toStringAsFixed(2)}'),
      ),
    );
  }
}