import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class AvisoPrivacidadPage extends StatefulWidget {
  const AvisoPrivacidadPage({super.key});

  @override
  State<AvisoPrivacidadPage> createState() => _AvisoPrivacidadPageState();
}

class _AvisoPrivacidadPageState extends State<AvisoPrivacidadPage> {
  String aviso = '';

  @override
  void initState() {
    super.initState();
    cargarTexto();
  }

  Future<void> cargarTexto() async {
    final contenido = await rootBundle.loadString('assets/aviso_privacidad.txt');
    setState(() => aviso = contenido);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Aviso de Privacidad'),
        backgroundColor: const Color(0xFF6D4C41),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: aviso.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Text(
                  aviso,
                  textAlign: TextAlign.justify,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
      ),
    );
  }
}
