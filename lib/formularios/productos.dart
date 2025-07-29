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

      if (response.body == "ok") {
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

      if (response.body == "ok") {
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
      appBar: AppBar(title: const Text('Productos')),
      body: ListView(
        children: [
          const Text('Nombre Producto: '),
          TextFormField(controller: txtNombreProd),
          const Text('Descripción: '),
          TextFormField(controller: txtDescripcion),
          const Text('Precio Unitario: '),
          TextFormField(controller: txtPrecio),
          TextButton(onPressed: enviarProducto, child: const Text('Guardar')),
          if (widget.idProducto != 0)
            ElevatedButton(
              onPressed: eliminarProducto,
              child: const Text('Eliminar'),
            ),
        ],
      ),
    );
  }
}
