import 'package:flutter/material.dart';
import 'package:informe1_2/styles/estilos.dart';
import '../services/api_service.dart';

class UpdateUserScreen extends StatefulWidget {
  final String token;
  final int userId;
  final String currentName;
  final String currentEmail;

  UpdateUserScreen({
    required this.token,
    required this.userId,
    required this.currentName,
    required this.currentEmail,
  });

  @override
  _UpdateUserScreenState createState() => _UpdateUserScreenState();
}

class _UpdateUserScreenState extends State<UpdateUserScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  bool _isLoading = false;
  String _errorMessage = "";

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.currentName);
    _emailController = TextEditingController(text: widget.currentEmail);
  }

  void _updateUser() async {
    setState(() => _isLoading = true);

    final response = await ApiService.updateUser(
      widget.token,
      widget.userId,
      _nameController.text.trim(),
      _emailController.text.trim(),
    );

    setState(() => _isLoading = false);

    if (response["success"]) {
      Navigator.pop(context);
    } else {
      setState(() {
        _errorMessage = response["message"] ?? "Error al actualizar usuario.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Actualizar Usuario", style: Estilos.estiloEncabezado),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameController,
              decoration: Estilos.decoracionInput("Nombre", Icons.person),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration:
                  Estilos.decoracionInput("Correo Electrónico", Icons.email),
            ),
            if (_errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(
                  _errorMessage,
                  style: Estilos.estiloError,
                ),
              ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isLoading ? null : _updateUser,
              style: Estilos.estiloBoton,
              child:
                  _isLoading ? CircularProgressIndicator() : Text("Actualizar"),
            ),
          ],
        ),
      ),
    );
  }
}
