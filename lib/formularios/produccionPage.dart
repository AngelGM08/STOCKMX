import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:stockmx/drawer.dart';
import 'package:stockmx/formularios/compraPage.dart';
import 'package:stockmx/formularios/model/produccionModel.dart';
import 'package:stockmx/formularios/model/tamalModel.dart';
import 'package:stockmx/formularios/model/url.dart';
import 'package:stockmx/formularios/produccion.dart';
import 'package:stockmx/formularios/productoPage.dart';
import 'package:stockmx/formularios/proveedorPage.dart';
import 'package:stockmx/formularios/tamalPage.dart';
import 'package:stockmx/home.dart';

class ProduccionPage extends StatefulWidget {
  const ProduccionPage({super.key});

  @override
  State<ProduccionPage> createState() => _ProduccionPageState();
}

class _ProduccionPageState extends State<ProduccionPage> {
  final String _selectedMenu = 'Producción';

  List<TamalModel> tamales = [];
  String? selectedTamalId;

  List<ProduccionModel> producciones = [];

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
    } else if (menu == 'Producto') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ProductoPage()),
      );
    } else if (menu == 'Compras') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const CompraPage()),
      );
    } else if (menu == 'Producción') {
      return;
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomePage(initialMenu: menu)),
      );
    }
  }

  /// 🔹 Obtiene compras desde la API
  void fnGetProduccion() async {
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
        Uri.parse('${Url.urlServer}/api/producciones'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
    }

    Iterable mapProduccion = jsonDecode(response.body);
    producciones = List<ProduccionModel>.from(
      mapProduccion.map((model) => ProduccionModel.fromJson(model)),
    );

    setState(() {});
  }

  /// 🔹 Obtiene tamales desde la API
  void fnGetTamales() async {
    final response = await http.post(
      Uri.parse('${Url.urlServer}/api/tamales'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    Iterable mapTamal = jsonDecode(response.body);
    tamales = List<TamalModel>.from(
      mapTamal.map((model) => TamalModel.fromJson(model)),
    );
    setState(() {});
  }

  /// 🔹 Busca el nombre del tamal por ID
  String getNombreTamal(int? idTamal) {
    final tamal = tamales.firstWhere(
      (t) => t.idT == idTamal,
      orElse: () => TamalModel(idT: 0, nomT: 'Desconocido', descripcion: ''),
    );
    return tamal.nomT;
  }

  /// 🔹 Construye la lista de tamales
  Widget _listViewTamales() {
    if (tamales.isEmpty) {
      return const Center(child: Text('No hay producciones disponibles'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: producciones.length,
      itemBuilder: (context, index) {
        final produccion = producciones[index];
        final tamalNombre = getNombreTamal(produccion.idTamal);

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 3,
          child: ListTile(
            onTap: () {
              if (Url.rol != 'Administrador' ||
                  Url.id == produccion.idProduccion) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ProduccionForm(idProduccion: produccion.idProduccion),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'No tienes permiso para editar esta produccion.',
                    ),
                  ),
                );
              }
            },
            title: Text('Tamal: ${tamalNombre}'),
            subtitle: Text(
              'Fecha: ${produccion.fecha}\n'
              'Cantidad Total: ${produccion.cantidadTotal}',
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    fnGetProduccion();
    fnGetTamales();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MainDrawer(
        selectedMenu: _selectedMenu,
        onItemSelected: _onMenuSelected,
      ),
      appBar: AppBar(
        title: const Text('Produccion'),
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
        child: _listViewTamales(),
      ),
      floatingActionButton: (Url.rol != 'Proveedor' && Url.rol != 'Cliente')
          ? FloatingActionButton(
              backgroundColor: Colors.red.shade100,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProduccionForm(idProduccion: 0),
                  ),
                );
              },
              child: const Icon(Icons.add, color: Colors.black87),
            )
          : null,
    );
  }
}
