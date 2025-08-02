import 'package:flutter/material.dart';
import 'productos_screen.dart';
import 'produccion_screen.dart';
// Importa las demás pantallas cuando estén listas

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorFondo = const Color(0xFFFDF6EC);
    final colorIconos = const Color(0xFF6D4C41);

    return Scaffold(
      backgroundColor: colorFondo,
      appBar: AppBar(
        title: const Text('🌽 Tamalería - Menú Principal'),
        backgroundColor: colorIconos,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          children: [
            _buildMenuItem(
              context,
              icon: '🫔',
              label: 'Productos',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProductosScreen()),
              ),
            ),
            _buildMenuItem(
              context,
              icon: '📦',
              label: 'Compras',
              onTap: () {
                
              },
            ),
            _buildMenuItem(
              context,
              icon: '🏭',
              label: 'Producción',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProduccionScreen()),
              ),
            ),
            _buildMenuItem(
              context,
              icon: '👩‍🌾',
              label: 'Proveedores',
              onTap: () {
                // Navegar a pantalla de Proveedores
              },
            ),
            _buildMenuItem(
              context,
              icon: '🥡',
              label: 'Tamales',
              onTap: () {
                // Navegar a pantalla de Tamales
              },
            ),
            _buildMenuItem(
              context,
              icon: '👤',
              label: 'Perfil',
              onTap: () {
                // Navegar al perfil del usuario
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context,
      {required String icon, required String label, required VoidCallback onTap}) {
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
