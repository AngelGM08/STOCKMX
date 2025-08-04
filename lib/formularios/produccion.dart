import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:stockmx/formularios/model/produccionModel.dart';
import 'package:stockmx/formularios/model/tamalModel.dart';
import 'package:stockmx/formularios/produccionPage.dart';
import 'model/url.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';

class ProduccionForm extends StatefulWidget {
  final int idProduccion;
  const ProduccionForm({super.key, required this.idProduccion});

  @override
  State<ProduccionForm> createState() => _ProduccionFormState();
}

class _ProduccionFormState extends State<ProduccionForm> {
  List<TamalModel> tamales = [];
  String? selectedTamalId;

  final TextEditingController txtFecha = TextEditingController();
  final TextEditingController txtCantidadT = TextEditingController();
  final formatoFecha = DateFormat('yyyy-MM-dd'); // o 'dd/MM/yyyy'
  bool isLoading = false;

  Future<void> cargarProduccion() async {
    setState(() => isLoading = true);
    try {
      final response = await http.get(
        Uri.parse('${Url.urlServer}/api/produccion/${widget.idProduccion}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseJson = jsonDecode(response.body);
        final produccion = ProduccionModel.fromJson(responseJson);

        setState(() {
          selectedTamalId = produccion.idTamal.toString();
          txtFecha.text = formatoFecha.format(produccion.fecha);
          txtCantidadT.text = produccion.cantidadTotal.toString();
          
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error cargando produccion')),
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

  Future<void> cargarTamal() async {
    setState(() => isLoading = true);
    try {
      final responseTamal = await http.post(
        Uri.parse('${Url.urlServer}/api/tamales'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (responseTamal.statusCode == 200) {
        Iterable mapTamales = jsonDecode(responseTamal.body);
        setState(() {
          tamales = List<TamalModel>.from(
            mapTamales.map((model) => TamalModel.fromJson(model)),
          );
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al cargar los tamales')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')));
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> enviarProduccion() async {
    if (txtFecha.text.isEmpty || txtCantidadT.text.isEmpty || selectedTamalId == null)  {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, llena todos los campos')),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final response = await http.post(
        Uri.parse('${Url.urlServer}/api/produccion/nuevo'),
        body: jsonEncode(<String, dynamic>{
          'id': widget.idProduccion,
          'id_tamal': selectedTamalId,
          'fecha': txtFecha.text,
          'cantidad_total': txtCantidadT.text,
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      final data = jsonDecode(response.body);
      
      if (data['status'] == 'ok') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ProduccionPage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al guardar la produccion')),
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

  Future<void> eliminarProduccion() async {
    setState(() => isLoading = true);
    try {
      final response = await http.post(
        Uri.parse('${Url.urlServer}/api/produccion/eliminar'),
        body: jsonEncode(<String, dynamic>{'id': widget.idProduccion}),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      final data = jsonDecode(response.body);
      
      if (data['status'] == 'ok') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ProduccionPage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al eliminar la produccion')),
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

  Future<void> _selectFecha(TextEditingController controller) async {
    final result = await showCalendarDatePicker2Dialog(
      context: context,
      config: CalendarDatePicker2WithActionButtonsConfig(
        calendarType: CalendarDatePicker2Type.single,
      ),
      dialogSize: const Size(325, 400),
      value: [],
      borderRadius: BorderRadius.circular(15),
    );
    if (result != null && result.isNotEmpty && result.first != null) {
      final fecha = result.first!;
      controller.text = fecha.toIso8601String().split('T').first;
    }
  }

  @override
void initState() {
  super.initState();
  cargarTodo();
}

Future<void> cargarTodo() async {
  await cargarTamal(); // Esperar a que termine de cargar tamales
  if (widget.idProduccion != 0) {
    await cargarProduccion(); // Ahora sí, cargar la producción
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Produccion')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                const Text('Tamal: '),
                DropdownButton<String>(
                  value: selectedTamalId,
                  hint: const Text('Selecciona un Tamal'),
                  isExpanded: true,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedTamalId = newValue;
                      // Buscar el producto seleccionado y asignar su precio unitario
                      final tamalSel = tamales.firstWhere(
                        (tamal) => tamal.idT.toString() == newValue,
                      );
                    });
                  },
                  items: tamales.map<DropdownMenuItem<String>>((
                    TamalModel tamal,
                  ) {
                    return DropdownMenuItem<String>(
                      value: tamal.idT.toString(),
                      child: Text('${tamal.idT} ${tamal.nomT}'),
                    );
                  }).toList(),
                ),
                const Text('Fecha: '),
                TextFormField(
                  controller: txtFecha,
                  readOnly: true,
                  onTap: () => _selectFecha(txtFecha),
                  decoration: InputDecoration(labelText: 'Fecha'),
                ),
                const Text('Cantidad Total: '),
                TextFormField(controller: txtCantidadT),
                TextButton(
                  onPressed: enviarProduccion,
                  child: const Text('Guardar'),
                ),
                if (widget.idProduccion != 0)
                  ElevatedButton(
                    onPressed: eliminarProduccion,
                    child: const Text('Eliminar'),
                  ),
              ],
            ),
    );
  }
}
