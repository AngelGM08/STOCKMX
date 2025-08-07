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

      if (!mounted) return;

      if (responseProduccion.statusCode == 200 &&
          responseCompra.statusCode == 200) {
        setState(() {
          producciones = jsonDecode(responseProduccion.body);
          compras = jsonDecode(responseCompra.body);
        });
      } else {
        throw Exception('Error en los códigos de estado');
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar listas: $e')),
      );
    }
  }

  Future<void> cargarInsumo() async {
    try {
      final response = await http
          .get(Uri.parse('${Url.urlServer}/api/insumos/${widget.idInsumo}'));

      if (!mounted) return;

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          selectedProduccion = data['id_produccion'];
          selectedCompra = data['id_compra'];
          txtCantidad.text = data['cantidad_usada'].toString();
        });
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar: $e')),
      );
    }
  }

  Future<void> inicializarFormulario() async {
    await cargarListas();
    if (!mounted) return;
    if (widget.idInsumo != 0) {
      await cargarInsumo();
    }
    if (!mounted) return;
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

    if (!mounted) return;

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
      appBar: AppBar(
        title: const Text('📦 Insumo'),
        backgroundColor: const Color(0xFF6D4C41),
        foregroundColor: Colors.white,
      ),
      backgroundColor: const Color(0xFFF5F5F5),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: SizedBox(
                width: 360,
                child: Card(
                  margin: const EdgeInsets.all(16),
                  color: const Color(0xFFFFF8E7),
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.inventory,
                            size: 50, color: Color(0xFF6D4C41)),
                        const SizedBox(height: 12),
                        DropdownButtonFormField<int>(
                          value: selectedProduccion,
                          items: producciones.map<DropdownMenuItem<int>>((prod) {
                            final tamal = prod['tamal'];
                            final nombreTamal = tamal != null
                                ? tamal['nombre_tamal'] ?? 'Desconocido'
                                : 'Sin tamal';
                            
                            return DropdownMenuItem<int>(
                              value: prod['id_produccion'],
                              child: Text(
                                'Tamal: $nombreTamal',
                                overflow: TextOverflow.ellipsis,
                              ),
                            );
                          }).toList(),
                          onChanged: (val) =>
                              setState(() => selectedProduccion = val),
                          decoration: const InputDecoration(
                            labelText: 'Producción',
                            prefixIcon: Icon(Icons.kitchen),
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 12),
                        DropdownButtonFormField<int>(
                          value: selectedCompra,
                          items: compras.map<DropdownMenuItem<int>>((compra) {
                            final producto = compra['producto'];
                            final nombreProd = producto != null
                                ? producto['nombre_prod'] ?? 'Desconocido'
                                : 'Sin producto';
                            return DropdownMenuItem<int>(
                              value: compra['id_compra'],
                              child: Text(
                                'Producto: $nombreProd',
                                overflow: TextOverflow.ellipsis,
                              ),
                            );
                          }).toList(),
                          onChanged: (val) =>
                              setState(() => selectedCompra = val),
                          decoration: const InputDecoration(
                            labelText: 'Compra',
                            prefixIcon: Icon(Icons.shopping_cart),
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: txtCantidad,
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          decoration: const InputDecoration(
                            labelText: 'Cantidad usada',
                            prefixIcon: Icon(Icons.scale),
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF8D6E63),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
                          ),
                          onPressed: guardarInsumo,
                          icon: const Icon(Icons.save),
                          label: const Text('Guardar'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
