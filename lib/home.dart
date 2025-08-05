import 'package:flutter/material.dart';
import 'package:stockmx/formularios/compraPage.dart';
import 'package:stockmx/formularios/productoPage.dart';
import 'package:stockmx/formularios/proveedorPage.dart';
import 'package:stockmx/formularios/tamalPage.dart';
import 'package:stockmx/formularios/produccion.dart';
import 'package:stockmx/formularios/produccionPage.dart';
import 'package:stockmx/formularios/insumoPage.dart';

import 'drawer.dart';

class HomePage extends StatefulWidget {
  final String initialMenu;
  const HomePage({super.key, this.initialMenu = 'Inicio'});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late String _selectedMenu;

  @override
  void initState() {
    super.initState();
    _selectedMenu = widget.initialMenu;
  }

  void _onMenuSelected(String menu) {
  if (menu == 'Insumos') {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const InsumoPage()),
    );
  } else if (menu == 'Proveedores') {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ProveedorPage()),
    );
  } else if (menu == 'Productos') {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ProductoPage()),
    );
  } else if (menu == 'Compras') {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CompraPage()),
    );
  } else if (menu == 'Tamales') {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const TamalPage()),
    );
  } else if (menu == 'Producción') {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ProduccionPage()),
    );
  } else {
    setState(() {
      _selectedMenu = menu;
    });
  }
}


  @override
  Widget build(BuildContext context) {
    final colorFondo = const Color(0xFFFDF6EC);
    final colorIconos = const Color(0xFF6D4C41);

    return Scaffold(
      drawer: MainDrawer(
        selectedMenu: _selectedMenu,
        onItemSelected: _onMenuSelected,
      ),
      appBar: AppBar(
        title: const Text('🌽 Tamalería - Menú Principal'),
        backgroundColor: colorIconos,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      backgroundColor: colorFondo,
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          children: [
            _buildMenuItem(
              icon: '🫔',
              label: 'Productos',
              onTap: () => _onMenuSelected('Productos'),
            ),
            _buildMenuItem(
              icon: '📦',
              label: 'Compras',
              onTap: () => _onMenuSelected('Compras'),
            ),
            _buildMenuItem(
              icon: '🏭',
              label: 'Producción',
              onTap: () => _onMenuSelected('Producción'),
            ),
            _buildMenuItem(
              icon: '👩‍🌾',
              label: 'Proveedores',
              onTap: () => _onMenuSelected('Proveedores'),
            ),
            _buildMenuItem(
              icon: '🥡',
              label: 'Tamales',
              onTap: () => _onMenuSelected('Tamales'),
            ),
            _buildMenuItem(
              icon: '👤',
              label: 'Perfil',
              onTap: () => _onMenuSelected('Perfil'), // futuro
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required String icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(icon, style: const TextStyle(fontSize: 40)),
            const SizedBox(height: 10),
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF6D4C41),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
