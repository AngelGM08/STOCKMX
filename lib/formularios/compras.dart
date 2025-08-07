import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:stockmx/formularios/compraPage.dart';
import 'package:stockmx/formularios/model/compraModel.dart';
import 'package:stockmx/formularios/model/productoModel.dart';
import 'model/url.dart';
import 'model/proveedorModel.dart';
import 'package:http/http.dart' as http;

class ComprasForm extends StatefulWidget {
  final int idCompra;
  const ComprasForm({super.key, required this.idCompra});

  @override
  State<ComprasForm> createState() => _ComprasFormState();
}

class _ComprasFormState extends State<ComprasForm> {
  double precioUnitario = 0.0;

  List<ProveedorModel> proveedores = [];
  String? selectedProveedorId;

  List<ProductoModel> productos = [];
  String? selectedProductoId;

  String? unidadSel;
  final unidad = ['kg', 'pieza', 'ml'];

  final TextEditingController txtCantidad = TextEditingController();
  final TextEditingController txtTotal = TextEditingController();
  bool isLoading = false;

  Future<void> cargarCompra() async {
    setState(() => isLoading = true);
    try {
      final response = await http.get(
        Uri.parse('${Url.urlServer}/api/compra/${widget.idCompra}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseJson = jsonDecode(response.body);
        final compra = CompraModel.fromJson(responseJson);

        setState(() {
          txtCantidad.text = compra.cantidad.toString();
          unidadSel = compra.unidad.toString();
          txtTotal.text = compra.total.toString();
        });
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Error cargando compras')));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> cargarProveedores() async {
    setState(() => isLoading = true);
    try {
      final responseProv = await http.post(
        Uri.parse('${Url.urlServer}/api/proveedores'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (responseProv.statusCode == 200) {
        Iterable mapProveedores = jsonDecode(responseProv.body);
        setState(() {
          proveedores = List<ProveedorModel>.from(
            mapProveedores.map((model) => ProveedorModel.fromJson(model)),
          );
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al cargar los proveedores')),
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

  Future<void> cargarProductos() async {
    setState(() => isLoading = true);
    try {
      final responseProd = await http.post(
        Uri.parse('${Url.urlServer}/api/productos'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (responseProd.statusCode == 200) {
        Iterable mapProductos = jsonDecode(responseProd.body);
        setState(() {
          productos = List<ProductoModel>.from(
            mapProductos.map((model) => ProductoModel.fromJson(model)),
          );
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al cargar los productos')),
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

  Future<void> enviarCompra() async {
    if (selectedProveedorId == null ||
        selectedProductoId == null ||
        txtCantidad.text.isEmpty ||
        unidadSel == null ||
        txtTotal.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, llena todos los campos')),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final response = await http.post(
        Uri.parse('${Url.urlServer}/api/compra/nuevo'),
        body: jsonEncode(<String, dynamic>{
          'id': widget.idCompra,
          'id_proveedor': selectedProveedorId,
          'id_producto': selectedProductoId,
          'cantidad': txtCantidad.text,
          'unidad': unidadSel,
          'total': txtTotal.text,
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.body == "ok") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const CompraPage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al guardar la compra')),
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

  Future<void> eliminarCompra() async {
    setState(() => isLoading = true);
    try {
      final response = await http.post(
        Uri.parse('${Url.urlServer}/api/compra/eliminar'),
        body: jsonEncode(<String, dynamic>{'id': widget.idCompra}),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.body == "ok") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const CompraPage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al eliminar la compra')),
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

  void calcularTotal() {
    final cantidad = double.tryParse(txtCantidad.text) ?? 0;
    final total = cantidad * precioUnitario;
    txtTotal.text = total.toStringAsFixed(2);
  }

  @override
  void initState() {
    super.initState();
    cargarProveedores();
    cargarProductos();
    txtCantidad.addListener(() {
      calcularTotal();
    });
    if (widget.idCompra != 0) {
      cargarCompra();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🛒 Compras'),
        backgroundColor: const Color(0xFF6D4C41),
        foregroundColor: Colors.white,
      ),
      backgroundColor: const Color(0xFFF5F5F5),
      body: Center(
        child: Card(
          margin: const EdgeInsets.all(16),
          color: const Color(0xFFFFF8E7),
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.shopping_cart,
                  size: 50,
                  color: Color(0xFF6D4C41),
                ),
                const SizedBox(height: 12),
                DropdownButton<String>(
                  value: selectedProveedorId,
                  hint: const Text('Selecciona un Proveedor'),
                  isExpanded: true,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedProveedorId = newValue;
                    });
                  },
                  items: proveedores.map<DropdownMenuItem<String>>((
                    ProveedorModel proveedor,
                  ) {
                    return DropdownMenuItem<String>(
                      value: proveedor.idP.toString(),
                      child: Text(
                        '${proveedor.idP} ${proveedor.nombre} ${proveedor.apellidoPaterno}',
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 12),
                DropdownButton<String>(
                  value: selectedProductoId,
                  hint: const Text('Selecciona un Producto'),
                  isExpanded: true,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedProductoId = newValue;
                      final productoSel = productos.firstWhere(
                        (prod) => prod.idProd.toString() == newValue,
                      );
                      precioUnitario = productoSel.precioU;
                      if (txtCantidad.text.isNotEmpty) {
                        calcularTotal();
                      }
                    });
                  },
                  items: productos.map<DropdownMenuItem<String>>((
                    ProductoModel producto,
                  ) {
                    return DropdownMenuItem<String>(
                      value: producto.idProd.toString(),
                      child: Text(
                        '${producto.idProd} ${producto.nombreProd} ${producto.precioU}',
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: txtCantidad,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Cantidad',
                    prefixIcon: Icon(Icons.shopping_basket),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: unidadSel,
                  hint: const Text('Selecciona una unidad'),
                  items: unidad
                      .map(
                        (rol) => DropdownMenuItem(value: rol, child: Text(rol)),
                      )
                      .toList(),
                  onChanged: (value) => setState(() => unidadSel = value),
                ),
                const SizedBox(height: 12),
                const Text('Total:'),
                TextFormField(
                  controller: txtTotal,
                  keyboardType: TextInputType.number,
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: 'Total',
                    prefixIcon: Icon(Icons.attach_money),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8D6E63),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                  onPressed: enviarCompra,
                  icon: const Icon(Icons.save),
                  label: const Text('Guardar'),
                ),
                if (widget.idCompra != 0) ...[
                  const SizedBox(height: 12),
                  TextButton.icon(
                    onPressed: eliminarCompra,
                    icon: const Icon(Icons.delete, color: Colors.red),
                    label: const Text(
                      'Eliminar',
                      style: TextStyle(color: Colors.red),
                    ),
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
