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
import 'package:stockmx/formularios/insumoPage.dart';
import 'package:stockmx/home.dart';

class TamalPage extends StatefulWidget {
  const TamalPage({super.key});

  @override
  State<TamalPage> createState() => _TamalPageState();
}

class _TamalPageState extends State<TamalPage> {
  final String _selectedMenu = 'Tamales';

  List<TamalModel> tamales = [];

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
  }else if (menu == 'Tamales') {
      return;
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomePage(initialMenu: menu)),
      );
    }
  }

  /// 🔹 Obtiene los tamales desde la API
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

  /// 🔹 Construye la lista de tamales con el diseño actualizado
  Widget _listViewTamales() {
    if (tamales.isEmpty) {
      return const Center(child: Text('No hay tamales disponibles'));
    }

    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount:
            2, // Puedes cambiar esto a 1 si prefieres mostrar en una columna
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio:
            0.75, // Ajustar la relación de aspecto para que se vea bien
      ),
      itemCount: tamales.length,
      itemBuilder: (context, index) {
        final tamal = tamales[index];
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
                  builder: (_) => TamalesForm(idTamal: tamal.idT),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.fastfood,
                    size: 40,
                    color: Color(
                      0xFF6D4C41,
                    ), // Color de ícono similar al de productos
                  ),
                  const SizedBox(height: 8),
                  Text(
                    tamal.nomT,
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
                    tamal.descripcion,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 13),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Color(0xFF6D4C41)),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => TamalesForm(idTamal: tamal.idT),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.redAccent),
                        onPressed: () {
                          eliminarTamal(tamal.idT);
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

  /// 🔹 Función para eliminar un tamal
  Future<void> eliminarTamal(int idTamal) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('¿Eliminar tamal?'),
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
      final url = Uri.parse('${Url.urlServer}/api/tamal/eliminar');
      final response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({'id': idTamal}),
      );

      if (response.statusCode == 200) {
        setState(() {
          tamales.removeWhere((t) => t.idT == idTamal);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tamal eliminado correctamente')),
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
    fnGetTamal();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MainDrawer(
        selectedMenu: _selectedMenu,
        onItemSelected: _onMenuSelected,
      ),
      appBar: AppBar(
        title: const Text('Tamales'),
        backgroundColor: const Color(
          0xFF6D4C41,
        ), // Color café en la parte superior
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFE3F2FD),
              Color(0xFFFFFFFF),
            ], // Gradiente de fondo
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: _listViewTamales(),
      ),
      floatingActionButton: (Url.rol != 'Proveedor' && Url.rol != 'Cliente')
          ? FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TamalesForm(idTamal: 0),
                  ),
                );
              },
              label: const Text('Agregar'),
              icon: const Icon(Icons.add),
              backgroundColor: const Color(
                0xFF6D4C41,
              ), // Aquí se cambia al color café
            )
          : null,
    );
  }
}
