import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:stockmx/formularios/insumoPage.dart';
import 'package:stockmx/formularios/model/url.dart';

class InsumoForm extends StatefulWidget {
  final int idInsumo;
  const InsumoForm({super.key, required this.idInsumo});

  @override
  State<InsumoForm> createState() => _InsumoFormState();
}

class _InsumoFormState extends State<InsumoForm> {
  int? selectedProduccion;
  int? selectedCompra;
  final txtCantidad = TextEditingController();
  bool isLoading = true;
  List<dynamic> producciones = [];
  List<dynamic> compras = [];

  Future<void> cargarListas() async {
    try {
      final responseProduccion =
          await http.get(Uri.parse('${Url.urlServer}/api/producciones'));
      final responseCompra = await http.post(
        Uri.parse('${Url.urlServer}/api/compras'),
        headers: {'Content-Type': 'application/json'},
      );

      if (responseProduccion.statusCode == 200 &&
          responseCompra.statusCode == 200) {
        producciones = jsonDecode(responseProduccion.body);
        compras = jsonDecode(responseCompra.body);
      } else {
        throw Exception('Error en los códigos de estado');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar listas: $e')),
      );
    }
  }

  Future<void> cargarInsumo() async {
    try {
      final response = await http
          .get(Uri.parse('${Url.urlServer}/api/insumos/${widget.idInsumo}'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        selectedProduccion = data['id_produccion'];
        selectedCompra = data['id_compra'];
        txtCantidad.text = data['cantidad_usada'].toString();
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error al cargar: $e')));
    }
  }

  Future<void> inicializarFormulario() async {
    await cargarListas();
    if (widget.idInsumo != 0) {
      await cargarInsumo();
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> guardarInsumo() async {
    if (selectedProduccion == null ||
        selectedCompra == null ||
        txtCantidad.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Completa todos los campos')),
      );
      return;
    }

    final body = {
      'id_produccion': selectedProduccion,
      'id_compra': selectedCompra,
      'cantidad_usada': double.parse(txtCantidad.text),
    };

    final uri = (widget.idInsumo == 0)
        ? Uri.parse('${Url.urlServer}/api/insumos')
        : Uri.parse('${Url.urlServer}/api/insumos/${widget.idInsumo}');

    final response = (widget.idInsumo == 0)
        ? await http.post(uri,
            body: jsonEncode(body),
            headers: {'Content-Type': 'application/json'})
        : await http.put(uri,
            body: jsonEncode(body),
            headers: {'Content-Type': 'application/json'});

    if (response.statusCode == 200 || response.statusCode == 201) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const InsumoPage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al guardar')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    inicializarFormulario();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Formulario Insumo')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(12),
              children: [
                const Text('Producción'),
                DropdownButtonFormField<int>(
                  value: producciones
                          .any((prod) => prod['id_produccion'] == selectedProduccion)
                      ? selectedProduccion
                      : null,
                  items: producciones.map<DropdownMenuItem<int>>((prod) {
                    final tamal = prod['tamal'];
                    final nombreTamal = tamal != null
                        ? tamal['nombre_tamal'] ?? 'Desconocido'
                        : 'Sin tamal';
                    final fecha = prod['fecha'] ?? 'Fecha no disponible';
                    return DropdownMenuItem<int>(
                      value: prod['id_produccion'],
                      child: Text('Tamal: $nombreTamal - Fecha: $fecha'),
                    );
                  }).toList(),
                  onChanged: (val) => setState(() => selectedProduccion = val),
                  decoration:
                      const InputDecoration(border: OutlineInputBorder()),
                ),
                const SizedBox(height: 10),
                const Text('Compra'),
                DropdownButtonFormField<int>(
                  value: compras
                          .any((compra) => compra['id_compra'] == selectedCompra)
                      ? selectedCompra
                      : null,
                  items: compras.map<DropdownMenuItem<int>>((compra) {
                    final producto = compra['producto'];
                    final nombreProd = producto != null
                        ? producto['nombre_prod'] ?? 'Desconocido'
                        : 'Sin producto';
                    return DropdownMenuItem<int>(
                      value: compra['id_compra'],
                      child: Text('Producto: $nombreProd'),
                    );
                  }).toList(),
                  onChanged: (val) => setState(() => selectedCompra = val),
                  decoration:
                      const InputDecoration(border: OutlineInputBorder()),
                ),
                const SizedBox(height: 10),
                const Text('Cantidad Usada'),
                TextField(
                  controller: txtCantidad,
                  keyboardType: TextInputType.number,
                  decoration:
                      const InputDecoration(border: OutlineInputBorder()),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: guardarInsumo,
                  child: const Text('Guardar'),
                ),
              ],
            ),
    );
  }
}
