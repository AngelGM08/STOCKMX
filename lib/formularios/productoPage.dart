import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:stockmx/drawer.dart';
import 'package:stockmx/formularios/compraPage.dart';
import 'package:stockmx/formularios/model/productoModel.dart';
import 'package:stockmx/formularios/model/url.dart';
import 'package:stockmx/formularios/produccionPage.dart';
import 'package:stockmx/formularios/productos.dart';
import 'package:stockmx/formularios/proveedorPage.dart';
import 'package:stockmx/formularios/tamalPage.dart';
import 'package:stockmx/home.dart';
import 'package:stockmx/formularios/insumoPage.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';


class ProductoPage extends StatefulWidget {
  const ProductoPage({super.key});

  @override
  State<ProductoPage> createState() => _ProductoPageState();
}

class _ProductoPageState extends State<ProductoPage> {
  final String _selectedMenu = 'Productos';
  List<ProductoModel> productos = [];

  void _onMenuSelected(String menu) {
    if (menu == 'Proveedores') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ProveedorPage()),
      );
    } else if (menu == 'Compras') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const CompraPage()),
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
  }else if (menu == 'Productos') {
      return;
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomePage(initialMenu: menu)),
      );
    }
  }

  
void mostrarSnackbarCentrado(BuildContext context, String mensaje) {
  final overlay = Overlay.of(context);
  final overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      top: MediaQuery.of(context).size.height * 0.4,
      left: 20,
      right: 20,
      child: Material(
        elevation: 10,
        borderRadius: BorderRadius.circular(16),
        child: AwesomeSnackbarContent(
          title: 'No se puede eliminar',
          message: mensaje,
          contentType: ContentType.failure,
          inMaterialBanner: true,
        ),
      ),
    ),
  );

  overlay.insert(overlayEntry);
  Future.delayed(const Duration(seconds: 3), () => overlayEntry.remove());
}


  void fnGetProducto() async {
    http.Response response;
    if (Url.rol == 'Proveedor') {
      response = await http.post(
        Uri.parse('${Url.urlServer}/api/usuario/roles'),
        body: jsonEncode({'rol': 'Cliente'}),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
      );
    } else {
      response = await http.post(
        Uri.parse('${Url.urlServer}/api/productos'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
      );
    }

    Iterable mapProducto = jsonDecode(response.body);
    productos = List<ProductoModel>.from(
      mapProducto.map((model) => ProductoModel.fromJson(model)),
    );

    print('Productos cargados: ${productos.length}');

    setState(() {});
  }

  Widget _listViewProducto() {
    if (productos.isEmpty) {
      return const Center(
        child: Text(
          'No hay productos disponibles',
          style: TextStyle(fontSize: 16, color: Colors.black54),
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.75,
      ),
      itemCount: productos.length,
      itemBuilder: (context, index) {
        final producto = productos[index];
        return Card(
          elevation: 6,
          color: const Color(0xFFFFF8E7),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ProductosForm(idProducto: producto.idProd),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.rice_bowl,
                    size: 40,
                    color: Color(0xFF6D4C41),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    producto.nombreProd,
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
                    producto.descripcion,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 13),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '\$${producto.precioU.toStringAsFixed(2)}',
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
                                  ProductosForm(idProducto: producto.idProd),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.redAccent),
                        onPressed: () {
                          eliminarProductoDesdeCatalogo(producto.idProd);
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

  Future<void> eliminarProductoDesdeCatalogo(int idProducto) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('¿Eliminar producto?'),
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
      final url = Uri.parse('${Url.urlServer}/api/producto/eliminar');
      print('👉 POST a: $url con id: $idProducto');

      final response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({'id': idProducto}),
      );

      print('🔁 STATUS: ${response.statusCode}');
      print('🔁 BODY: ${response.body}');

      if (response.statusCode == 200 &&
          response.headers['content-type']?.contains('application/json') ==
              true) {
        final data = jsonDecode(response.body);

        if (data['status'] == 'ok') {
          setState(() => productos.removeWhere((p) => p.idProd == idProducto));
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Producto eliminado correctamente')),
          );
        } else if (data['status'] == 'foreign_key_violation') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'No se puede eliminar: el producto está vinculado a compras.',
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error inesperado: ${data['message']}')),
          );
        }
      } else {
        final data = jsonDecode(response.body);

        if (data['status'] == 'ok') {
          setState(() => productos.removeWhere((p) => p.idProd == idProducto));
          mostrarSnackbarCentrado(context, 'Producto eliminado correctamente');
        } else if (data['status'] == 'foreign_key_violation') {
          mostrarSnackbarCentrado(
            context,
            'Este producto está vinculado a compras y no puede eliminarse.',
          );
        } else {
          mostrarSnackbarCentrado(
            context,
            'Error al eliminar: ${data['message'] ?? 'desconocido'}',
          );
        }
      }
    } catch (e) {
      print('🛑 Error al eliminar: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    }
  }

  @override
  void initState() {
    super.initState();
    fnGetProducto();
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
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          '🫔 Catálogo de Productos',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFF8E7), Color(0xFFFFFFFF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: _listViewProducto(),
      ),
      floatingActionButton: (Url.rol != 'Proveedor' && Url.rol != 'Cliente')
          ? FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ProductosForm(idProducto: 0),
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
