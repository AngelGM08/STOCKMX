import 'package:flutter/material.dart';
import '../models/producto.dart';
import '../widgets/producto_card.dart';

class ProductosScreen extends StatelessWidget {
  final List<Producto> productos = [
    Producto(nombre: 'Masa', descripcion: 'Insumo para tamales', unidad: 'kg', precio: 15.0),
    Producto(nombre: 'Rajas', descripcion: 'Chiles en tiras', unidad: 'kg', precio: 18.0),
    Producto(nombre: 'Azúcar', descripcion: 'Para tamales dulces', unidad: 'kg', precio: 12.0),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Productos del Inventario")),
      body: ListView.builder(
        itemCount: productos.length,
        itemBuilder: (context, index) {
          return ProductoCard(producto: productos[index]);
        },
      ),
    );
  }
}