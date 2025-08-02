import 'package:flutter/material.dart';
import '../models/produccion.dart';

class ProduccionCard extends StatelessWidget {
  final Produccion produccion;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const ProduccionCard({
    Key? key,
    required this.produccion,
    required this.onDelete,
    required this.onEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFFFFF8E7),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Text('🏭', style: TextStyle(fontSize: 40)),
            Text(
              produccion.nombreTamal ?? 'Sin asignar',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            Text('Fecha: ${produccion.fecha ?? '---'}'),
            Text('Cantidad: ${produccion.cantidadTotal ?? 0}'),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(onPressed: onEdit, icon: const Icon(Icons.edit, color: Colors.brown)),
                IconButton(onPressed: onDelete, icon: const Icon(Icons.delete, color: Colors.red)),
              ],
            )
          ],
        ),
      ),
    );
  }
}
