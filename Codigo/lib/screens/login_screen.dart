import 'package:flutter/material.dart';
import 'package:informe1_2/styles/estilos.dart';
import '../services/api_service.dart';
import 'crud_menu_screen.dart';
import 'register_screen.dart';

class PantallaInicioSesion extends StatefulWidget {
  @override
  _PantallaInicioSesionState createState() => _PantallaInicioSesionState();
}

class _PantallaInicioSesionState extends State<PantallaInicioSesion> {
  final _controladorCorreo = TextEditingController();
  final _controladorContrasena = TextEditingController();
  bool _cargando = false;
  bool _mostrarContrasena = false;
  String _mensajeError = "";

  void _iniciarSesion() async {
    if (_controladorCorreo.text.isEmpty ||
        _controladorContrasena.text.isEmpty) {
      setState(() => _mensajeError = "Completa todos los campos.");
      return;
    }

    setState(() {
      _cargando = true;
      _mensajeError = "";
    });

    try {
      final respuesta = await ApiService.login(
        _controladorCorreo.text.trim(),
        _controladorContrasena.text.trim(),
      );

      setState(() => _cargando = false);

      if (respuesta["success"]) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => PantallaMenuCRUD(
              token: respuesta["token"],
              idUsuario: respuesta["userId"],
            ),
          ),
        );
      } else {
        setState(
            () => _mensajeError = respuesta["message"] ?? "Error inesperado.");
      }
    } catch (e) {
      setState(() {
        _cargando = false;
        _mensajeError = "Error de conexión: Verifica tu red.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(24.0),
            child: Column(
              children: [
                SizedBox(height: 60),
                Center(
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Estilos.colorPrimario.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.person_outline,
                        color: Estilos.colorPrimario, size: 40),
                  ),
                ),
                SizedBox(height: 24),
                Text(
                  "Bienvenido",
                  textAlign: TextAlign.center,
                  style: Estilos.estiloEncabezado,
                ),
                SizedBox(height: 16),
                Text(
                  "Inicia sesión para continuar.",
                  textAlign: TextAlign.center,
                  style: Estilos.estiloInformativo,
                ),
                SizedBox(height: 48),
                TextField(
                  controller: _controladorCorreo,
                  decoration: Estilos.decoracionInput(
                      "Correo Electrónico", Icons.email_outlined),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _controladorContrasena,
                  obscureText: !_mostrarContrasena,
                  decoration:
                      Estilos.decoracionInput("Contraseña", Icons.lock_outline)
                          .copyWith(
                    suffixIcon: IconButton(
                      icon: Icon(
                        _mostrarContrasena
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: Estilos.colorPrimario.withOpacity(0.7),
                      ),
                      onPressed: () => setState(
                          () => _mostrarContrasena = !_mostrarContrasena),
                    ),
                  ),
                ),
                SizedBox(height: 24),
                if (_mensajeError.isNotEmpty)
                  Text(
                    _mensajeError,
                    style: Estilos.estiloError,
                  ),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _cargando ? null : _iniciarSesion,
                  style: Estilos.estiloBoton,
                  child: _cargando
                      ? CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        )
                      : Text("Iniciar Sesión"),
                ),
                SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PantallaRegistrarUsuario()),
                    );
                  },
                  child: Text(
                    "¿No tienes cuenta? Regístrate aquí",
                    style: TextStyle(color: Estilos.colorPrimario),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
