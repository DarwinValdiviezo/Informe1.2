import 'package:flutter/material.dart';
import '../services/api_service.dart';

class DeleteUserScreen extends StatelessWidget {
  final String token;
  final int userId; // id como int

  DeleteUserScreen({required this.token, required this.userId});

  void _deleteUser(BuildContext context) async {
    final response = await ApiService.deleteUser(token, userId);

    if (response["success"]) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Usuario eliminado correctamente.")),
      );
      Navigator.popUntil(context, (route) => route.isFirst);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(response["message"] ?? "Error al eliminar usuario.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Eliminar Cuenta"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _deleteUser(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
          child: Text("Eliminar mi Cuenta"),
        ),
      ),
    );
  }
}
