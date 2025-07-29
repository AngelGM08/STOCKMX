import 'package:flutter/material.dart';
import 'package:stockmx/formularios/compraPage.dart';
import 'package:stockmx/formularios/productoPage.dart';
import 'package:stockmx/formularios/proveedorPage.dart';
import 'formularios/insumos.dart';
import 'drawer.dart';
import 'formularios/produccion.dart';

class HomePage extends StatefulWidget {
  final String initialMenu; // 🔹 nuevo parámetro
  const HomePage({super.key, this.initialMenu = 'Inicio'});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late String _selectedMenu;

  @override
  void initState() {
    super.initState();
    _selectedMenu = widget.initialMenu; // 🔹 usar el valor recibido
  }

  /// 🔹 Manejo de selección de menú
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
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const CompraPage()),
      );
    } else {
      // Las secciones que no tienen página propia se renderizan aquí
      setState(() {
        _selectedMenu = menu;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MainDrawer(
        selectedMenu: _selectedMenu,
        onItemSelected: _onMenuSelected,
      ),
      appBar: AppBar(
        title: const Text('Sistema de Inventario - Tamalería'),
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
        child: _getMainContent(),
      ),
    );
  }

  /// 🔹 Contenido solo para secciones internas
  Widget _getMainContent() {
    switch (_selectedMenu) {
      case 'Insumos':
        return const InsumosForm();
      case 'Compras':
        return const CompraPage();
      case 'Producción':
        return const ProduccionForm();
      case 'Inicio':
      default:
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: ListView(
                children: [
                  const SizedBox(height: 10),
                  Center(
                    child: Text(
                      'Bienvenido a la Tamalería "El Buen Sabor"',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      'assets/images/tamales.jpg',
                      height: 250,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Gestiona eficientemente insumos, proveedores, productos, compras y producción de tamales con esta aplicación desarrollada en Flutter.',
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
    }
  }
}
