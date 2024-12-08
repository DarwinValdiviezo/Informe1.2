import 'package:flutter/material.dart';

class Estilos {
  // Colores principales
  static const Color colorPrimario = Color(0xFF6B4EFF); // Violeta
  static const Color colorTexto = Color(0xFF2D3748); // Gris oscuro
  static const Color colorError = Color(0xFFE53E3E); // Rojo para errores

  // Estilo de encabezados
  static const TextStyle estiloEncabezado = TextStyle(
    color: colorTexto,
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );

  // Estilo para mensajes de error
  static const TextStyle estiloError = TextStyle(
    color: colorError,
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );

  // Estilo de texto informativo
  static TextStyle estiloInformativo = TextStyle(
    color: colorTexto.withOpacity(0.7),
    fontSize: 16,
  );

  // Decoración para campos de texto
  static InputDecoration decoracionInput(String etiqueta, IconData icono) {
    return InputDecoration(
      labelText: etiqueta,
      labelStyle: TextStyle(color: colorTexto.withOpacity(0.7)),
      prefixIcon: Icon(icono, color: colorPrimario.withOpacity(0.7)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colorPrimario.withOpacity(0.2)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colorPrimario, width: 2),
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }

  // Estilo de botones
  static ButtonStyle estiloBoton = ElevatedButton.styleFrom(
    backgroundColor: colorPrimario,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    padding: EdgeInsets.symmetric(vertical: 16),
    elevation: 0,
  );
}
