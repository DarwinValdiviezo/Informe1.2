import 'package:flutter/material.dart';
import 'package:informe1_2/styles/estilos.dart';
import '../services/api_service.dart';

class PantallaRegistrarUsuario extends StatefulWidget {
  @override
  _PantallaRegistrarUsuarioState createState() =>
      _PantallaRegistrarUsuarioState();
}

class _PantallaRegistrarUsuarioState extends State<PantallaRegistrarUsuario> {
  final _nombreController = TextEditingController();
  final _correoController = TextEditingController();
  final _contrasenaController = TextEditingController();
  String _mensajeError = "";

  // Lista de dominios permitidos
  final List<String> dominiosPermitidos = [
    "gmail.com",
    "yahoo.com",
    "outlook.com",
    "live.com",
    "espe.edu.ec"
  ];

  bool _validarCorreo(String correo) {
    final dominio = correo.split('@').last;
    return dominiosPermitidos.contains(dominio);
  }

  void _registrarUsuario() async {
    if (_nombreController.text.isEmpty ||
        _correoController.text.isEmpty ||
        _contrasenaController.text.isEmpty) {
      setState(() => _mensajeError = "Completa todos los campos.");
      return;
    }

    if (!_validarCorreo(_correoController.text.trim())) {
      setState(() => _mensajeError =
          "Correo no válido. Usa uno de estos dominios: ${dominiosPermitidos.join(', ')}");
      return;
    }

    final respuesta = await ApiService.register(
      _nombreController.text.trim(),
      _correoController.text.trim(),
      _contrasenaController.text.trim(),
    );

    if (respuesta["success"]) {
      Navigator.pop(context);
    } else {
      setState(
          () => _mensajeError = respuesta["message"] ?? "Error desconocido.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Estilos.colorPrimario,
        title: Text(
          "Registro de Usuario",
          style: Estilos.estiloEncabezado,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Crea tu cuenta",
              style: Estilos.estiloEncabezado,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            TextField(
              controller: _nombreController,
              decoration:
                  Estilos.decoracionInput("Nombre", Icons.person_outline),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _correoController,
              decoration: Estilos.decoracionInput(
                  "Correo Electrónico", Icons.email_outlined),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _contrasenaController,
              obscureText: true,
              decoration:
                  Estilos.decoracionInput("Contraseña", Icons.lock_outline),
            ),
            SizedBox(height: 24),
            if (_mensajeError.isNotEmpty)
              Text(
                _mensajeError,
                style: Estilos.estiloError,
              ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: _registrarUsuario,
              style: Estilos.estiloBoton,
              child: Text("Registrar"),
            ),
          ],
        ),
      ),
    );
  }
}
