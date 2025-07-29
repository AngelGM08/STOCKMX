import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:stockmx/formularios/model/tamalModel.dart';
import 'package:stockmx/formularios/tamalPage.dart';
import 'model/url.dart';
import 'package:http/http.dart' as http;

class TamalesForm extends StatefulWidget {
  final int idTamal;
  const TamalesForm({super.key, required this.idTamal});

  @override
  State<TamalesForm> createState() => _TamalesFormState();
}

class _TamalesFormState extends State<TamalesForm> {
  final TextEditingController txtNomTam = TextEditingController();
  final TextEditingController txtDescripcion = TextEditingController();
  bool isLoading = false;

  Future<void> cargarTamal() async {
    setState(() => isLoading = true);
    try {
      final response = await http.get(
        Uri.parse('${Url.urlServer}/api/tamal/${widget.idTamal}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseJson = jsonDecode(response.body);
        final tamal = TamalModel.fromJson(responseJson);

        setState(() {
          txtNomTam.text = tamal.nomT.toString();
          txtDescripcion.text = tamal.descripcion.toString();
        });
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Error cargando tamales')));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> enviarTamal() async {
    if (txtNomTam.text.isEmpty || txtDescripcion.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, llena todos los campos')),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final response = await http.post(
        Uri.parse('${Url.urlServer}/api/tamal/nuevo'),
        body: jsonEncode(<String, dynamic>{
          'id': widget.idTamal,
          'nombre_tamal': txtNomTam.text,
          'descripcion': txtDescripcion.text,
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.body == "ok") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const TamalPage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al guardar el tamal')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> eliminarTamal() async {
    setState(() => isLoading = true);
    try {
      final response = await http.post(
        Uri.parse('${Url.urlServer}/api/tamal/eliminar'),
        body: jsonEncode(<String, dynamic>{'id': widget.idTamal}),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.body == "ok") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const TamalPage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al eliminar el tamal')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    } finally {
      setState(() => isLoading = false);
    }
  }


  @override
  void initState() {
    super.initState();
    if (widget.idTamal != 0) {
      cargarTamal();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tamales')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                const Text('Nombre del Tamal: '),
                TextFormField(controller: txtNomTam),
                const Text('Descripcion: '),
                TextFormField(controller: txtDescripcion),
                TextButton(
                  onPressed: enviarTamal,
                  child: const Text('Guardar'),
                ),
                if (widget.idTamal != 0)
                  ElevatedButton(
                    onPressed: eliminarTamal,
                    child: const Text('Eliminar'),
                  ),
              ],
            ),
    );
  }
}
