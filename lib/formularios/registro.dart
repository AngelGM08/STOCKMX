import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:stockmx/formularios/model/url.dart';
import 'package:stockmx/login.dart';

class RegistroPage extends StatefulWidget {
  const RegistroPage({super.key});

  @override
  State<RegistroPage> createState() => _RegistroPageState();
}

class _RegistroPageState extends State<RegistroPage> {
  final TextEditingController txtName = TextEditingController();
  final TextEditingController txtEmail = TextEditingController();
  final TextEditingController txtPassword = TextEditingController();
  final TextEditingController txtRol = TextEditingController();
  String? rolSeleccionado;
  final roles = ['Proveedor', 'Administrador', 'Cliente'];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(title: const Text('Registro de Usuario')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextFormField(
              controller: txtName,
              decoration: const InputDecoration(
                labelText: 'Nombre completo',
                prefixIcon: Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: txtEmail,
              decoration: const InputDecoration(
                labelText: 'Correo electrónico',
                prefixIcon: Icon(Icons.email),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: txtPassword,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Contraseña',
                prefixIcon: Icon(Icons.lock),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField(
              value: rolSeleccionado,
              hint: const Text('Selecciona un rol'),
              items: roles
                  .map((rol) => DropdownMenuItem(value: rol, child: Text(rol)))
                  .toList(),
              onChanged: (value) => setState(() => rolSeleccionado = value),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: size.height * 0.07,
              child: ElevatedButton(
                onPressed: () async {
                  final response = await http.post(
                    Uri.parse('${Url.urlServer}/api/usuario/nuevo'),
                    body: jsonEncode(<String, dynamic>{
                      'name': txtName.text,
                      'email': txtEmail.text,
                      'password': txtPassword.text,
                      'rol': rolSeleccionado,
                    }),
                    headers: <String, String>{
                      'Content-Type': 'application/json; charset=UTF-8',
                    },
                  );

                  if (response.body == 'ok') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Registrarse',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
