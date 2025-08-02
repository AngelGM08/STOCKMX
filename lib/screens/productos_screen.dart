import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

import '../models/producto.dart';
import '../widgets/producto_card.dart';

class ProductosScreen extends StatefulWidget {
  const ProductosScreen({super.key});

  @override
  State<ProductosScreen> createState() => _ProductosScreenState();
}

class _ProductosScreenState extends State<ProductosScreen> {
  late Future<List<Producto>> _productos;

  @override
  void initState() {
    super.initState();
    _productos = fetchProductos();
  }

  Future<List<Producto>> fetchProductos() async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:8000/api/productos'),
    );

    if (response.statusCode == 200) {
      final List jsonList = json.decode(response.body);
      return jsonList.map((e) => Producto.fromJson(e)).toList();
    } else {
      throw Exception('Error al cargar productos');
    }
  }

  void _mostrarSnackbar(String titulo, String mensaje, ContentType tipo) {
    final snackBar = SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: titulo,
        message: mensaje,
        contentType: tipo,
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> _guardarProducto(int id, String nombre, String descripcion, String precio) async {
    final url = Uri.parse('http://10.0.2.2:8000/api/producto/nuevo');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'id': id,
        'nombre_prod': nombre,
        'descripcion': descripcion,
        'precio_unitario': double.tryParse(precio),
      }),
    );

    if (response.statusCode == 200 && response.body == 'ok') {
      setState(() {
        _productos = fetchProductos();
      });

      if (id == 0) {
        _mostrarSnackbar('¡Éxito!', 'Producto agregado correctamente 🆕', ContentType.success);
      } else {
        _mostrarSnackbar('Actualizado', 'Producto actualizado correctamente ✏️', ContentType.success);
      }
    } else {
      _mostrarSnackbar('Error', 'No se pudo guardar el producto', ContentType.failure);
    }
  }

  Future<void> _confirmarEliminarProducto(BuildContext context, int id) async {
    final confirmado = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: const Text('¿Estás seguro que deseas eliminar este producto?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirmado == true) {
      final url = Uri.parse('http://10.0.2.2:8000/api/producto/eliminar');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'id': id}),
      );

      if (response.statusCode == 200 && response.body == 'ok') {
        setState(() {
          _productos = fetchProductos();
        });

        _mostrarSnackbar('Eliminado', 'Producto eliminado exitosamente 🗑️', ContentType.warning);
      } else {
        _mostrarSnackbar('Error', 'No se pudo eliminar el producto', ContentType.failure);
      }
    }
  }

  void _mostrarFormularioAgregar(BuildContext context, {Producto? producto}) {
    final _formKey = GlobalKey<FormState>();
    String nombre = producto?.nombre ?? '';
    String descripcion = producto?.descripcion ?? '';
    String precio = producto?.precio?.toString() ?? '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(producto == null ? '➕ Agregar Producto' : '✏️ Editar Producto'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  initialValue: nombre,
                  decoration: const InputDecoration(
                    labelText: 'Nombre',
                    prefixIcon: Icon(Icons.fastfood),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) => nombre = value,
                  validator: (value) => value!.isEmpty ? 'Ingrese el nombre' : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  initialValue: descripcion,
                  decoration: const InputDecoration(
                    labelText: 'Descripción',
                    prefixIcon: Icon(Icons.description),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) => descripcion = value,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  initialValue: precio,
                  decoration: const InputDecoration(
                    labelText: 'Precio',
                    prefixIcon: Icon(Icons.attach_money),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) => precio = value,
                  validator: (value) => value!.isEmpty ? 'Ingrese el precio' : null,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton.icon(
              icon: Icon(producto == null ? Icons.save : Icons.update),
              label: Text(producto == null ? 'Guardar' : 'Actualizar'),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  if (producto == null) {
                    await _guardarProducto(0, nombre, descripcion, precio);
                    Navigator.of(context).pop();
                  } else {
                    final confirmado = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Confirmar actualización'),
                        content: const Text('¿Estás seguro que deseas actualizar la información del producto?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: const Text('Cancelar'),
                          ),
                          ElevatedButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: const Text('Actualizar'),
                          ),
                        ],
                      ),
                    );

                    if (confirmado == true) {
                      await _guardarProducto(producto.id, nombre, descripcion, precio);
                      Navigator.of(context).pop();
                    }
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF6EC),
      appBar: AppBar(
        backgroundColor: const Color(0xFF6D4C41),
        title: const Text('🫔 Catálogo de Productos'),
        centerTitle: true,
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _mostrarFormularioAgregar(context),
        icon: const Icon(Icons.add),
        label: const Text('Agregar'),
        backgroundColor: const Color(0xFF8D6E63),
      ),
      body: FutureBuilder<List<Producto>>(
        future: _productos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final productos = snapshot.data!;

          if (productos.isEmpty) {
            return const Center(child: Text('No hay productos registrados.'));
          }

          return Padding(
            padding: const EdgeInsets.all(10),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 3 / 4,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: productos.length,
              itemBuilder: (context, index) {
                final producto = productos[index];
                return ProductoCard(
                  producto: producto,
                  onDelete: () => _confirmarEliminarProducto(context, producto.id),
                  onEdit: () => _mostrarFormularioAgregar(context, producto: producto),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
