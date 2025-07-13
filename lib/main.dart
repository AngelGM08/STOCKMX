import 'package:flutter/material.dart';
import 'formularios/insumos.dart';
import 'formularios/proveedores.dart';
import 'formularios/productos.dart';
import 'formularios/compras.dart';
import 'formularios/produccion.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tamalería App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.brown),
        useMaterial3: true,
      ),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _selectedMenu = 'Inicio';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sistema de Inventario - Tamalería')),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.brown),
              child: Text(
                'Menú Principal',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            _buildDrawerItem('Inicio'),
            _buildDrawerItem('Insumos'),
            _buildDrawerItem('Proveedores'),
            _buildDrawerItem('Productos'),
            _buildDrawerItem('Compras'),
            _buildDrawerItem('Producción'),
          ],
        ),
      ),
      body: _getMainContent(),
    );
  }

  Widget _buildDrawerItem(String title) {
    return ListTile(
      title: Text(title),
      selected: _selectedMenu == title,
      onTap: () {
        setState(() {
          _selectedMenu = title;
        });
        Navigator.pop(context); // Cierra el drawer
      },
    );
  }

  Widget _getMainContent() {
    switch (_selectedMenu) {
      case 'Insumos':
        return const InsumosForm();
      case 'Proveedores':
        return const ProveedoresForm();
      case 'Productos':
        return const ProductosForm();
      case 'Compras':
        return const ComprasForm();
      case 'Producción':
        return const ProduccionForm();
      case 'Inicio':
      default:
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Text(
                'Bienvenido a la Tamalería "El Buen Sabor"',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Image.asset(
                'assets/images/tamales.jpg',
                height: 250,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 20),
              const Text(
                'Gestiona eficientemente insumos, proveedores, productos, compras y producción de tamales con esta aplicación desarrollada en Flutter.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
    }
  }
}
