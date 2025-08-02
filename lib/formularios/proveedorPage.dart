import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:stockmx/drawer.dart';
import 'package:stockmx/formularios/compraPage.dart';
import 'package:stockmx/formularios/model/proveedorModel.dart';
import 'package:stockmx/formularios/model/url.dart';
import 'package:stockmx/formularios/produccionPage.dart';
import 'package:stockmx/formularios/productoPage.dart';
import 'package:stockmx/formularios/proveedores.dart';
import 'package:stockmx/formularios/tamalPage.dart';
import 'package:stockmx/home.dart';

class ProveedorPage extends StatefulWidget {
  const ProveedorPage({super.key});

  @override
  State<ProveedorPage> createState() => _ProveedorPageState();
}

class _ProveedorPageState extends State<ProveedorPage> {
  final String _selectedMenu = 'Proveedores';

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
    } else if (menu == 'Proveedores') {
      return;
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomePage(initialMenu: menu)),
      );
    }
  }

  List<ProveedorModel> proveedores = [];

  void fnGetProveedores() async {
    http.Response response;
    if (Url.rol == 'Proveedor') {
      response = await http.post(
        Uri.parse('${Url.urlServer}/api/usuario/roles'),
        body: jsonEncode({'rol': 'Cliente'}),
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

  Widget _listViewProveedor() {
    if (proveedores.isEmpty) {
      return const Center(
        child: Text(
          'No hay proveedores disponibles',
          style: TextStyle(fontSize: 16, color: Colors.black54),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: proveedores.length,
      itemBuilder: (context, index) {
        final proveedor = proveedores[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 6),
          color: const Color(0xFFE3F2FD),
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            leading: const Icon(Icons.person, color: Color(0xFF448AFF)),
            title: Text(proveedor.nombre,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('Email: ${proveedor.email}'),
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
                    content: Text('No tienes permiso para editar esta persona.'),
                  ),
                );
              }
            },
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
      drawer: MainDrawer(
        selectedMenu: _selectedMenu,
        onItemSelected: _onMenuSelected,
      ),
      appBar: AppBar(
        title: const Text(
          'Proveedores',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF448AFF), // Azul seleccionado
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFE3F2FD), // Azul claro arriba
              Color(0xFFFFFFFF), // Blanco abajo
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: _listViewProveedor(),
      ),
      floatingActionButton: (Url.rol != 'Proveedor' && Url.rol != 'Cliente')
          ? FloatingActionButton(
              backgroundColor: const Color(0xFF448AFF), // Botón azul
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProveedoresForm(idProveedor: 0),
                  ),
                );
              },
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
    );
  }
}

