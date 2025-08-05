import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:stockmx/formularios/model/url.dart';
import 'package:stockmx/formularios/model/insumoModel.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:stockmx/drawer.dart';
import 'package:stockmx/formularios/insumoForm.dart';
import 'package:stockmx/home.dart';
import 'package:stockmx/formularios/compraPage.dart';
import 'package:stockmx/formularios/produccionPage.dart';
import 'package:stockmx/formularios/productoPage.dart';
import 'package:stockmx/formularios/proveedorPage.dart';
import 'package:stockmx/formularios/tamalPage.dart';

class InsumoPage extends StatefulWidget {
  const InsumoPage({super.key});

  @override
  State<InsumoPage> createState() => _InsumoPageState();
}

class _InsumoPageState extends State<InsumoPage> {
  final String _selectedMenu = 'Insumos';
  List<InsumoModel> insumos = [];

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
    } else if (menu == 'Productos') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ProductoPage()),
      );
    } else if (menu == 'Insumos') {
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
            title: 'Error',
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

  Future<void> fnGetInsumos() async {
    try {
      final response = await http.get(
        Uri.parse('${Url.urlServer}/api/insumos'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
      );

      if (response.statusCode == 200) {
        Iterable map = jsonDecode(response.body);
        setState(() {
          insumos =
              List<InsumoModel>.from(map.map((i) => InsumoModel.fromJson(i)));
        });
      } else {
        mostrarSnackbarCentrado(context, 'Error al cargar los insumos.');
      }
    } catch (e) {
      mostrarSnackbarCentrado(context, 'Error: ${e.toString()}');
    }
  }

  Future<void> eliminarInsumoDesdeCatalogo(int idInsumo) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('¿Eliminar insumo?'),
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
      final url = Uri.parse('${Url.urlServer}/api/insumos/$idInsumo');
      final response = await http.delete(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        setState(() => insumos.removeWhere((i) => i.id == idInsumo));
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Insumo eliminado correctamente')),
        );
      } else {
        mostrarSnackbarCentrado(context, 'Error al eliminar el insumo.');
      }
    } catch (e) {
      mostrarSnackbarCentrado(context, 'Error: ${e.toString()}');
    }
  }

  Widget _listViewInsumos() {
    if (insumos.isEmpty) {
      return const Center(
        child: Text(
          'No hay insumos disponibles',
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
      itemCount: insumos.length,
      itemBuilder: (context, index) {
        final insumo = insumos[index];
        return Card(
          elevation: 6,
          color: const Color(0xFFFFF8E7),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.inventory_2,
                    size: 40, color: Color(0xFF6D4C41)),
                const SizedBox(height: 8),
                Text(
                  'Prod: ${insumo.nombreProducto}',
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
                  'Tamal: ${insumo.nombreTamal}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 13),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text(
                  'Cant: ${insumo.cantidadUsada}',
                  style: const TextStyle(fontSize: 16, color: Colors.black87),
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon:
                          const Icon(Icons.edit, color: Color(0xFF6D4C41)),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => InsumoForm(idInsumo: insumo.id),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon:
                          const Icon(Icons.delete, color: Colors.redAccent),
                      onPressed: () {
                        eliminarInsumoDesdeCatalogo(insumo.id);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    fnGetInsumos();
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
          '📦 Catálogo de Insumos',
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
        child: _listViewInsumos(),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const InsumoForm(idInsumo: 0),
            ),
          );
        },
        label: const Text('Agregar'),
        icon: const Icon(Icons.add),
        backgroundColor: const Color(0xFF8D6E63),
      ),
    );
  }
}
