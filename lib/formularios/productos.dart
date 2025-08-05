import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:stockmx/formularios/model/productoModel.dart';
import 'package:stockmx/formularios/productoPage.dart';
import 'model/url.dart';
import 'package:http/http.dart' as http;

class ProductosForm extends StatefulWidget {
  final int idProducto;
  const ProductosForm({super.key, required this.idProducto});

  @override
  State<ProductosForm> createState() => _ProveedoresFormState();
}

class _ProveedoresFormState extends State<ProductosForm> {
  final TextEditingController txtNombreProd = TextEditingController();
  final TextEditingController txtDescripcion = TextEditingController();
  final TextEditingController txtPrecio = TextEditingController();
  bool isLoading = false;

  Future<void> cargarProducto() async {
    setState(() => isLoading = true);
    try {
      final response = await http.get(
        Uri.parse('${Url.urlServer}/api/producto/${widget.idProducto}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseJson = jsonDecode(response.body);
        final producto = ProductoModel.fromJson(responseJson);
        setState(() {
          txtNombreProd.text = producto.nombreProd.toString();
          txtDescripcion.text = producto.descripcion.toString();
          txtPrecio.text = producto.precioU.toString();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error cargando producto')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> enviarProducto() async {
    if (txtNombreProd.text.isEmpty ||
        txtDescripcion.text.isEmpty ||
        txtPrecio.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, llena todos los campos')),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final response = await http.post(
        Uri.parse('${Url.urlServer}/api/producto/nuevo'),
        body: jsonEncode(<String, dynamic>{
          'id': widget.idProducto,
          'nombre_prod': txtNombreProd.text,
          'descripcion': txtDescripcion.text,
          'precio_unitario': double.tryParse(txtPrecio.text) ?? 0.0,
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      final data = jsonDecode(response.body);
      
      if (data['status'] == 'ok') {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ProductoPage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al guardar el producto')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> eliminarProducto() async {
    setState(() => isLoading = true);
    try {
      final response = await http.post(
        Uri.parse('${Url.urlServer}/api/producto/eliminar'),
        body: jsonEncode(<String, dynamic>{'id': widget.idProducto}),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      final data = jsonDecode(response.body);
      
      if (data['status'] == 'ok') {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProductoPage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al eliminar el producto')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    } finally {
      setState(() => isLoading = false);
    }
  }

  

  @override
  void initState() {
    super.initState();
    if (widget.idProducto != 0) {
      cargarProducto();
    }
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('🫔 Producto'),
      backgroundColor: const Color(0xFF6D4C41),
      foregroundColor: Colors.white,
    ),
    backgroundColor: const Color(0xFFF5F5F5),
    body: Center(
      child: Card(
        margin: const EdgeInsets.all(16),
        color: const Color(0xFFFFF8E7),
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.local_dining, size: 50, color: Color(0xFF6D4C41)),
              const SizedBox(height: 12),
              TextFormField(
                controller: txtNombreProd,
                decoration: const InputDecoration(
                  labelText: 'Nombre del producto',
                  prefixIcon: Icon(Icons.fastfood),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: txtDescripcion,
                decoration: const InputDecoration(
                  labelText: 'Descripción',
                  prefixIcon: Icon(Icons.description),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: txtPrecio,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Precio unitario',
                  prefixIcon: Icon(Icons.attach_money),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8D6E63),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                onPressed: enviarProducto,
                icon: const Icon(Icons.save),
                label: const Text('Guardar'),
              ),
              if (widget.idProducto != 0) ...[
                const SizedBox(height: 12),
                TextButton.icon(
                  onPressed: eliminarProducto,
                  icon: const Icon(Icons.delete, color: Colors.red),
                  label: const Text('Eliminar', style: TextStyle(color: Colors.red)),
                ),
              ],
            ],
          ),
        ),
      ),
    ),
  );
}

}
