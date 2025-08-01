import 'package:flutter/material.dart';
import 'package:stockmx/formularios/productoPage.dart';
import 'login.dart'; // Agrega esta línea

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
      home: const ProductoPage  (), // ← Empieza en login
      debugShowCheckedModeBanner: false,
    );
  }
}
