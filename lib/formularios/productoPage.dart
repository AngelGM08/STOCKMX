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

class ProductoPage extends StatefulWidget {
  const ProductoPage({super.key});

  @override
  State<ProductoPage> createState() => _ProductoPageState();
}

class _ProductoPageState extends State<ProductoPage> {
  final String _selectedMenu = 'Productos';

  /// 🔹 Manejo de navegación desde el Drawer
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
    }else if (menu == 'Productos') {
      return; // ya estamos aquí
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomePage(initialMenu: menu)),
      );
    }
  }

  List<ProductoModel> productos = [];

  /// 🔹 Obtiene productos desde la API
  void fnGetProducto() async {
    http.Response response;
    if (Url.rol == 'Proveedor') {
      response = await http.post(
        Uri.parse('${Url.urlServer}/api/usuario/roles'),
        body: jsonEncode(<String, dynamic>{'rol': 'Cliente'}),
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

    setState(() {});
  }

  /// 🔹 Construye la lista de productos
  Widget _listViewProducto() {
    if (productos.isEmpty) {
      return const Center(child: Text('No hay productos disponibles'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: productos.length,
      itemBuilder: (context, index) {
        final producto = productos[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 3,
          child: ListTile(
            onTap: () {
              if (Url.rol != 'Administrador' || Url.id == producto.idProd) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductosForm(idProducto: producto.idProd),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'No tienes permiso para editar este producto.',
                    ),
                  ),
                );
              }
            },
            title: Text(producto.nombreProd),
            subtitle: Text('Descripción: ${producto.descripcion}\n''Precio: \$${producto.precioU.toStringAsFixed(2)}'),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    fnGetProducto();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// ✅ Drawer compartido
      drawer: MainDrawer(
        selectedMenu: _selectedMenu,
        onItemSelected: _onMenuSelected,
      ),

      /// ✅ AppBar consistente
      appBar: AppBar(
        title: const Text('Productos'),
        backgroundColor: Colors.blueAccent,
      ),

      /// ✅ Fondo con gradiente
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
        child: _listViewProducto(),
      ),

      /// ✅ Botón flotante solo para roles permitidos
      floatingActionButton: (Url.rol != 'Proveedor' && Url.rol != 'Cliente')
          ? FloatingActionButton(
              backgroundColor: Colors.red.shade100,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProductosForm(idProducto: 0),
                  ),
                );
              },
              child: const Icon(Icons.add, color: Colors.black87),
            )
          : null,
    );
  }
}
