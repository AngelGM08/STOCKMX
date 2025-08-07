import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:stockmx/drawer.dart';
import 'package:stockmx/formularios/compras.dart';
import 'package:stockmx/formularios/model/compraModel.dart';
import 'package:stockmx/formularios/model/productoModel.dart';
import 'package:stockmx/formularios/model/proveedorModel.dart';
import 'package:stockmx/formularios/model/url.dart';
import 'package:stockmx/formularios/produccionPage.dart';
import 'package:stockmx/formularios/productoPage.dart';
import 'package:stockmx/formularios/proveedorPage.dart';
import 'package:stockmx/formularios/tamalPage.dart';
import 'package:stockmx/formularios/insumoPage.dart';
import 'package:stockmx/home.dart';

class CompraPage extends StatefulWidget {
  const CompraPage({super.key});

  @override
  State<CompraPage> createState() => _CompraPageState();
}

class _CompraPageState extends State<CompraPage> {
  final String _selectedMenu = 'Compras';

  List<ProveedorModel> proveedores = [];
  String? selectedProveedorId;

  List<ProductoModel> productos = [];
  String? selectedProductoId;

  List<CompraModel> compras = [];

  /// 🔹 Navegación desde el Drawer
  void _onMenuSelected(String menu) {
    if (menu == 'Proveedores') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ProveedorPage()),
      );
    } else if (menu == 'Productos') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ProductoPage()),
      );
    } else if (menu == 'Tamales') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const TamalPage()),
      );
    } else if (menu == 'Producción') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ProduccionPage()),
      );
    } 
    else if (menu == 'Insumos') {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const InsumoPage()),
    );
  } 
    else if (menu == 'Compras') {
      return;
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomePage(initialMenu: menu)),
      );
    }
  }

  /// 🔹 Obtiene compras desde la API
  void fnGetCompra() async {
    http.Response response;
    if (Url.rol == 'Proveedor') {
      response = await http.post(
        Uri.parse('${Url.urlServer}/api/usuario/roles'),
        body: jsonEncode(<String, dynamic>{'rol': 'Cliente'}),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
    } else {
      response = await http.post(
        Uri.parse('${Url.urlServer}/api/compras'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
    }

    Iterable mapCompra = jsonDecode(response.body);
    compras = List<CompraModel>.from(
      mapCompra.map((model) => CompraModel.fromJson(model)),
    );

    setState(() {});
  }

  /// 🔹 Obtiene proveedores desde la API
  void fnGetProveedores() async {
    final response = await http.post(
      Uri.parse('${Url.urlServer}/api/proveedores'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    Iterable mapProv = jsonDecode(response.body);
    proveedores = List<ProveedorModel>.from(
      mapProv.map((model) => ProveedorModel.fromJson(model)),
    );
    setState(() {});
  }

  /// 🔹 Obtiene productos desde la API
  void fnGetProductos() async {
    final response = await http.post(
      Uri.parse('${Url.urlServer}/api/productos'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    Iterable mapProd = jsonDecode(response.body);
    productos = List<ProductoModel>.from(
      mapProd.map((model) => ProductoModel.fromJson(model)),
    );
    setState(() {});
  }

  /// 🔹 Busca el nombre del proveedor por ID
  String getNombreProveedor(int? idProv) {
    final prov = proveedores.firstWhere(
      (p) => p.idP == idProv,
      orElse: () => ProveedorModel(
        idP: 0,
        nombre: 'Desconocido',
        apellidoPaterno: '',
        apellidoMaterno: '',
        telefono: '',
        email: '',
      ),
    );
    return '${prov.nombre} ${prov.apellidoPaterno}';
  }

  /// 🔹 Busca el nombre del producto por ID
  String getNombreProducto(int? idProd) {
    final prod = productos.firstWhere(
      (p) => p.idProd == idProd,
      orElse: () => ProductoModel(
        idProd: 0,
        nombreProd: 'Desconocido',
        descripcion: '',
        precioU: 0.0,
      ),
    );
    return prod.nombreProd;
  }

  /// 🔹 Construye la lista de compras
  /// 🔹 Construye la lista de compras con un diseño similar al de productos
  Widget _listViewCompras() {
    if (compras.isEmpty) {
      return const Center(
        child: Text(
          'No hay compras disponibles',
          style: TextStyle(fontSize: 16, color: Colors.black54),
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount:
            2, // Cambiar esto a 1 si prefieres mostrar en una columna
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio:
            0.75, // Ajustar la relación de aspecto para que se vea bien
      ),
      itemCount: compras.length,
      itemBuilder: (context, index) {
        final compra = compras[index];
        final proveedorNombre = getNombreProveedor(compra.idProv);
        final productoNombre = getNombreProducto(compra.idProd);

        return Card(
          elevation: 6,
          color: const Color(
            0xFFFFF8E7,
          ), // Color de fondo similar al de productos
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ComprasForm(idCompra: compra.idCompra),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.shopping_cart,
                    size: 40,
                    color: Color(
                      0xFF6D4C41,
                    ), // Usando un color similar al de productos
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$productoNombre - $proveedorNombre',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Cantidad: ${compra.cantidad} ${compra.unidad}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 13),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Total: \$${compra.total.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Color(0xFF6D4C41)),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  ComprasForm(idCompra: compra.idCompra),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.redAccent),
                        onPressed: () {
                          // Llamar a la función para eliminar la compra (si es necesario)
                          eliminarCompra(compra.idCompra);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> eliminarCompra(int idCompra) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('¿Eliminar compra?'),
        content: const Text('Esta acción no se puede deshacer.'),
        actions: [
          TextButton(
            child: const Text('Cancelar'),
            onPressed: () => Navigator.pop(context, false),
          ),
          ElevatedButton(
            child: const Text('Eliminar'),
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      final url = Uri.parse('${Url.urlServer}/api/compra/eliminar');
      final response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({'id': idCompra}),
      );

      if (response.statusCode == 200) {
        setState(() {
          compras.removeWhere((compra) => compra.idCompra == idCompra);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Compra eliminada correctamente')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error al eliminar: $e')));
    }
  }

  @override
  void initState() {
    super.initState();
    fnGetCompra();
    fnGetProveedores();
    fnGetProductos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MainDrawer(
        selectedMenu: _selectedMenu,
        onItemSelected: _onMenuSelected,
      ),
      appBar: AppBar(
        backgroundColor: const Color(0xFF6D4C41),
        title: const Text('Compras', style: TextStyle(color: Colors.white)),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE3F2FD), Color(0xFFFFFFFF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: _listViewCompras(),
      ),
      floatingActionButton: (Url.rol != 'Proveedor' && Url.rol != 'Cliente')
          ? FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ComprasForm(idCompra: 0),
                  ),
                );
              },
              label: const Text('Agregar'),
              icon: const Icon(Icons.add),
              backgroundColor: const Color(0xFF8D6E63),
            )
          : null,
    );
  }
}
