import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:stockmx/drawer.dart';
import 'package:stockmx/formularios/compraPage.dart';
import 'package:stockmx/formularios/model/proveedorModel.dart';
import 'package:stockmx/formularios/model/url.dart';
import 'package:stockmx/formularios/productoPage.dart';
import 'package:stockmx/formularios/proveedores.dart';
import 'package:stockmx/home.dart';

class ProveedorPage extends StatefulWidget {
  const ProveedorPage({super.key});

  @override
  State<ProveedorPage> createState() => _ProveedorPageState();
}

class _ProveedorPageState extends State<ProveedorPage> {
  final String _selectedMenu = 'Proveedores';

  /// 🔹 Manejo de selección del menú del Drawer
  void _onMenuSelected(String menu) {
    if (menu == 'Productos') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ProductoPage()),
      );
    } else if (menu == 'Compras') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const CompraPage()),
      );
    } else if (menu == 'Proveedores') {
      return; // ya estamos aquí
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomePage(initialMenu: menu)),
      );
    }
  }

  List<ProveedorModel> proveedores = [];

  /// 🔹 Obtiene la lista de proveedores desde la API
  void fnGetProveedores() async {
    http.Response response;
    if (Url.rol == 'Proveedor') {
      response = await http.post(
        Uri.parse('${Url.urlServer}/api/usuario/roles'),
        body: jsonEncode(<String, dynamic>{'rol': 'Cliente'}),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
      );
    } else {
      response = await http.post(
        Uri.parse('${Url.urlServer}/api/proveedores'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
      );
    }

    Iterable mapProveedores = jsonDecode(response.body);
    proveedores = List<ProveedorModel>.from(
      mapProveedores.map((model) => ProveedorModel.fromJson(model)),
    );

    setState(() {});
  }

  /// 🔹 Construye la lista de proveedores
  Widget _listViewProveedor() {
    if (proveedores.isEmpty) {
      return const Center(child: Text('No hay proveedores disponibles'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: proveedores.length,
      itemBuilder: (context, index) {
        final proveedor = proveedores[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 3,
          child: ListTile(
            onTap: () {
              if (Url.rol != 'Administrador' || Url.id == proveedor.idP) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ProveedoresForm(idProveedor: proveedor.idP),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'No tienes permiso para editar esta persona.',
                    ),
                  ),
                );
              }
            },
            title: Text(proveedor.nombre),
            subtitle: Text('Email: ${proveedor.email}'),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    fnGetProveedores();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// ✅ Usa el Drawer compartido
      drawer: MainDrawer(
        selectedMenu: _selectedMenu,
        onItemSelected: _onMenuSelected,
      ),

      /// ✅ Se eliminó el AppBar duplicado (usamos solo el del Drawer)
      appBar: AppBar(
        title: const Text('Proveedores'),
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
        child: _listViewProveedor(),
      ),

      /// ✅ Botón flotante solo si tiene permisos
      floatingActionButton: (Url.rol != 'Proveedor' && Url.rol != 'Cliente')
          ? FloatingActionButton(
              backgroundColor: Colors.red.shade100,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProveedoresForm(idProveedor: 0),
                  ),
                );
              },
              child: const Icon(Icons.add, color: Colors.black87),
            )
          : null,
    );
  }
}
