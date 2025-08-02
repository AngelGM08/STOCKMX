import 'package:flutter/material.dart';
import '../models/producto.dart';

class ProductoCard extends StatelessWidget {
  final Producto producto;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const ProductoCard({
    Key? key,
    required this.producto,
    required this.onDelete,
    required this.onEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onEdit,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 5,
        color: const Color(0xFFFFF8E7),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Parte superior con imagen o ícono
            Expanded(
              flex: 2,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFE6CBA8),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                ),
                width: double.infinity,
                alignment: Alignment.center,
                child: const Text(
                  '🫔', // O puedes usar una imagen si lo deseas
                  style: TextStyle(fontSize: 50),
                ),
              ),
            ),
            // Nombre, descripción y precio
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      producto.nombre??'',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color(0xFF6D4C41),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      producto.descripcion??'',
                      style: const TextStyle(fontSize: 12, color: Colors.black54),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '\$${producto.precio?.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Color(0xFF8D6E63),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Botones
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit, color: Color(0xFF6D4C41)),
                  tooltip: 'Editar',
                ),
                IconButton(
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete_forever, color: Colors.redAccent),
                  tooltip: 'Eliminar',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
