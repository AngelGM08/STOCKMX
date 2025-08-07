import 'package:flutter/material.dart';
import 'package:stockmx/aviso_privacidad_page.dart';

class MainDrawer extends StatelessWidget {
  final String selectedMenu;
  final Function(String) onItemSelected;

  const MainDrawer({
    super.key,
    required this.selectedMenu,
    required this.onItemSelected,
  });

  Widget _buildDrawerItem(IconData icon, String title) {
    return Builder(
      builder: (context) {
        return ListTile(
          leading: Icon(icon, color: Colors.blueAccent),
          title: Text(title),
          selected: selectedMenu == title,
          selectedTileColor: Colors.blueAccent.withOpacity(0.2),
          onTap: () {
            Navigator.pop(context); // Cierra el Drawer
            onItemSelected(title);  // Notifica la selección
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1E88E5), Color(0xFF90CAF9)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.store, color: Colors.white, size: 40),
                SizedBox(width: 10),
                Text(
                  'Menú Principal',
                  style: TextStyle(color: Colors.white, fontSize: 22),
                ),
              ],
            ),
          ),
          _buildDrawerItem(Icons.home, 'Inicio'),
          _buildDrawerItem(Icons.kitchen, 'Insumos'),
          _buildDrawerItem(Icons.people, 'Proveedores'),
          _buildDrawerItem(Icons.inventory, 'Productos'),
          _buildDrawerItem(Icons.shopping_cart, 'Compras'),
          _buildDrawerItem(Icons.rice_bowl, 'Tamales'),
          _buildDrawerItem(Icons.factory, 'Producción'),

          const Divider(),

          // 🔐 Aviso de Privacidad
          ListTile(
            leading: const Icon(Icons.privacy_tip, color: Colors.grey),
            title: const Text('Aviso de Privacidad'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AvisoPrivacidadPage(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
