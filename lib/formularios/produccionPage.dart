import 'dart:convert';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
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
          title: 'Aviso',
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
      response = await http.get(
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

  Future<void> eliminarProduccionDesdeCatalogo(int idProduccion) async {
  final confirm = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('¿Eliminar producción?'),
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
    final url = Uri.parse('${Url.urlServer}/api/produccion/eliminar');
    final response = await http.post(
      url,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({'id': idProduccion}),
    );

    final data = jsonDecode(response.body);

    if (data['status'] == 'ok') {
      setState(() => producciones.removeWhere((p) => p.idProduccion == idProduccion));
      mostrarSnackbarCentrado(context, 'Producción eliminada correctamente');
    } else if (data['status'] == 'foreign_key_violation') {
      mostrarSnackbarCentrado(context, 'Esta producción está vinculada y no puede eliminarse.');
    } else {
      mostrarSnackbarCentrado(context, 'Error al eliminar: ${data['message'] ?? 'desconocido'}');
    }
  } catch (e) {
    mostrarSnackbarCentrado(context, 'Error al eliminar: ${e.toString()}');
  }
}


  /// 🔹 Construye la vista de producciones en formato de tarjetas
Widget _listViewTamales() {
  if (producciones.isEmpty) {
    return const Center(
      child: Text(
        'No hay producciones disponibles',
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
      childAspectRatio: 0.8,
    ),
    itemCount: producciones.length,
    itemBuilder: (context, index) {
      final produccion = producciones[index];
      final tamalNombre = getNombreTamal(produccion.idTamal);

      return Card(
        elevation: 6,
        color: const Color(0xFFFFF8E7),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              const Icon(
                Icons.factory, // Icono representativo de producción
                size: 40,
                color: Color(0xFF6D4C41),
              ),
              const SizedBox(height: 6),
              Text(
                tamalNombre,
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
                'Fecha: ${produccion.fecha}',
                style: const TextStyle(fontSize: 13),
              ),
              Text(
                'Cantidad: ${produccion.cantidadTotal}',
                style: const TextStyle(fontSize: 13),
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
                          builder: (_) => ProduccionForm(
                            idProduccion: produccion.idProduccion,
                          ),
                        ),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.redAccent),
                    onPressed: () {
                      eliminarProduccionDesdeCatalogo(produccion.idProduccion);
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
      backgroundColor: const Color(0xFF6D4C41), // Mismo tono café usado en ProductoPage
      iconTheme: const IconThemeData(color: Colors.white),
      title: const Text(
        '🛠 Producción',
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
      child: _listViewTamales(),
    ),
    floatingActionButton: (Url.rol != 'Proveedor' && Url.rol != 'Cliente')
        ? FloatingActionButton.extended(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ProduccionForm(idProduccion: 0),
                ),
              );
            },
            label: const Text('Agregar'),
            icon: const Icon(Icons.add),
            backgroundColor: const Color(0xFF8D6E63), // Café más oscuro
          )
        : null,
  );
}
}
