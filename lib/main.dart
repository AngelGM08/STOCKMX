import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(TamaleriaApp());
}

class TamaleriaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tamalería',
      theme: ThemeData(primarySwatch: Colors.green),
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}