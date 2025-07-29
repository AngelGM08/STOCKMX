import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:stockmx/drawer.dart';
import 'package:stockmx/formularios/compras.dart';
import 'package:stockmx/formularios/model/compraModel.dart';
import 'package:stockmx/formularios/model/productoModel.dart';
import 'package:stockmx/formularios/model/proveedorModel.dart';
import 'package:stockmx/formularios/model/url.dart';
import 'package:stockmx/formularios/productoPage.dart';
import 'package:stockmx/formularios/proveedorPage.dart';
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
    } else if (menu == 'Compras') {
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
  Widget _listViewCompras() {
    if (compras.isEmpty) {
      return const Center(child: Text('No hay compras disponibles'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: compras.length,
      itemBuilder: (context, index) {
        final compra = compras[index];
        final proveedorNombre = getNombreProveedor(compra.idProv);
        final productoNombre = getNombreProducto(compra.idProd);

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 3,
          child: ListTile(
            onTap: () {
              if (Url.rol != 'Administrador' || Url.id == compra.idCompra) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ComprasForm(idCompra: compra.idCompra),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('No tienes permiso para editar esta compra.'),
                  ),
                );
              }
            },
            title: Text('$productoNombre - $proveedorNombre'),
            subtitle: Text(
              'Cantidad: ${compra.cantidad} ${compra.unidad}\n'
              'Total: \$${compra.total.toStringAsFixed(2)}',
            ),
          ),
        );
      },
    );
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
        title: const Text('Compras'),
        backgroundColor: Colors.blueAccent,
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
          ? FloatingActionButton(
              backgroundColor: Colors.red.shade100,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ComprasForm(idCompra: 0),
                  ),
                );
              },
              child: const Icon(Icons.add, color: Colors.black87),
            )
          : null,
    );
  }
}
