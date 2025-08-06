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
  List<ProveedorModel> proveedores = [];

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

    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.75,
      ),
      itemCount: proveedores.length,
      itemBuilder: (context, index) {
        final proveedor = proveedores[index];
        return Card(
          elevation: 6,
          color: const Color(0xFFFFF8E7), // Mismo color de fondo que en ProductoPage
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {
              if (Url.rol != 'Administrador' || Url.id == proveedor.idP) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProveedoresForm(idProveedor: proveedor.idP),
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
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.person,
                    size: 40,
                    color: Color(0xFF6D4C41), // Mismo color que en ProductoPage
                  ),
                  const SizedBox(height: 8),
                  Text(
                    proveedor.nombre,
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
                    'Email: ${proveedor.email}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 13),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Color(0xFF6D4C41)), // Mismo color que en ProductoPage
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ProveedoresForm(idProveedor: proveedor.idP),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.redAccent),
                        onPressed: () {
                          // Llamar función para eliminar proveedor
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
        backgroundColor: const Color(0xFF6D4C41), // Mismo color que en ProductoPage
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Proveedores',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFF8E7), Color(0xFFFFFFFF)], // Mismo fondo de gradiente que en ProductoPage
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: _listViewProveedor(),
      ),
      floatingActionButton: (Url.rol != 'Proveedor' && Url.rol != 'Cliente')
          ? FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ProveedoresForm(idProveedor: 0),
                  ),
                );
              },
              label: const Text('Agregar'),
              icon: const Icon(Icons.add),
              backgroundColor: const Color(0xFF8D6E63), // Mismo color que en ProductoPage
            )
          : null,
    );
  }
}
