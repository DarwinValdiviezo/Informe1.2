import 'package:flutter/material.dart';
import 'package:informe1_2/screens/login_screen.dart';

void main() {
  runApp(AplicacionCRUD());
}

class AplicacionCRUD extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gestión de Usuarios',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        scaffoldBackgroundColor: Color(0xFFF8F9FC), // Fondo gris claro
      ),
      home: PantallaInicioSesion(),
    );
  }
}
