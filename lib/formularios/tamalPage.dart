import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:stockmx/drawer.dart';
import 'package:stockmx/formularios/compraPage.dart';
import 'package:stockmx/formularios/model/tamalModel.dart';
import 'package:stockmx/formularios/model/url.dart';
import 'package:stockmx/formularios/produccionPage.dart';
import 'package:stockmx/formularios/productoPage.dart';
import 'package:stockmx/formularios/proveedorPage.dart';
import 'package:stockmx/formularios/tamales.dart';
import 'package:stockmx/home.dart';

class TamalPage extends StatefulWidget {
  const TamalPage({super.key});

  @override
  State<TamalPage> createState() => _TamalPageState();
}

class _TamalPageState extends State<TamalPage> {
  final String _selectedMenu = 'Tamales';

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
    } else if (menu == 'Productos') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ProductoPage()),
      );
    }else if (menu == 'Producción') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ProduccionPage()),
      );
    } else if (menu == 'Tamales') {
      return;
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomePage(initialMenu: menu)),
      );
    }
  }

  List<TamalModel> tamales = [];

  /// 🔹 Obtiene productos desde la API
  void fnGetTamal() async {
    http.Response response;
    if (Url.rol == 'Proveedor') {
      response = await http.post(
        Uri.parse('${Url.urlServer}/api/usuario/roles'),
        body: jsonEncode(<String, dynamic>{'rol': 'Cliente'}),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
      );
    } else {
      response = await http.post(
        Uri.parse('${Url.urlServer}/api/tamales'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
      );
    }

    Iterable mapTamal = jsonDecode(response.body);
    tamales = List<TamalModel>.from(
      mapTamal.map((model) => TamalModel.fromJson(model)),
    );

    setState(() {});
  }

  /// 🔹 Construye la lista de productos
  Widget _listViewProducto() {
    if (tamales.isEmpty) {
      return const Center(child: Text('No hay tamales disponibles'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: tamales.length,
      itemBuilder: (context, index) {
        final tamal = tamales[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 3,
          child: ListTile(
            onTap: () {
              if (Url.rol != 'Administrador' || Url.id == tamal.idT) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        TamalesForm(idTamal: tamal.idT),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'No tienes permiso para editar este tamal.',
                    ),
                  ),
                );
              }
            },
            title: Text(tamal.nomT),
            subtitle: Text(
              'Descripción: ${tamal.descripcion}'),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    fnGetTamal();
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
        title: const Text('Tamales'),
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
                    builder: (context) => const TamalesForm(idTamal: 0),
                  ),
                );
              },
              child: const Icon(Icons.add, color: Colors.black87),
            )
          : null,
    );
  }
}
