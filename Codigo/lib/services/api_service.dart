import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://192.168.0.7/backend/api";

  // Iniciar Sesión
  static Future<Map<String, dynamic>> login(
      String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/login.php"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          "success": data["exito"] ?? false,
          "token": data["token"],
          "userId": data["idUsuario"] is int
              ? data["idUsuario"]
              : int.tryParse(data["idUsuario"].toString()) ??
                  0, // Convertir a int
        };
      } else if (response.statusCode == 401) {
        final data = jsonDecode(response.body);
        return {
          "success": false,
          "message": data["mensaje"] ?? "Credenciales inválidas"
        };
      } else {
        return {"success": false, "message": "Error desconocido"};
      }
    } catch (e) {
      return {"success": false, "message": "Error de conexión: $e"};
    }
  }

  // Registrar Usuario
  static Future<Map<String, dynamic>> register(
      String name, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/create_user.php"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"name": name, "email": email, "password": password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          "success": data["exito"] ?? false,
          "message": data["message"] ?? "Usuario registrado correctamente"
        };
      } else {
        final data = jsonDecode(response.body);
        return {
          "success": false,
          "message": data["message"] ?? "Error desconocido"
        };
      }
    } catch (e) {
      return {"success": false, "message": "Error de conexión: $e"};
    }
  }

  // Obtener Usuarios
  static Future<List<dynamic>> getUsers() async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/read_users.php"));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data["data"] ?? [];
      } else {
        throw Exception("Error al obtener usuarios: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error de conexión: $e");
    }
  }

  // Actualizar Usuario
  static Future<Map<String, dynamic>> updateUser(
      String token, int userId, String name, String email) async {
    try {
      final response = await http.put(
        Uri.parse("$baseUrl/update_user.php"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({"id": userId, "name": name, "email": email}),
      );

      if (response.statusCode == 200) {
        return {"success": true};
      } else {
        final data = jsonDecode(response.body);
        return {
          "success": false,
          "message": data["message"] ?? "Error desconocido"
        };
      }
    } catch (e) {
      return {"success": false, "message": "Error de conexión: $e"};
    }
  }

  // Eliminar Usuario
  static Future<Map<String, dynamic>> deleteUser(
      String token, int userId) async {
    try {
      final response = await http.delete(
        Uri.parse("$baseUrl/delete_user.php"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({"id": userId}),
      );

      if (response.statusCode == 200) {
        return {"success": true};
      } else {
        final data = jsonDecode(response.body);
        return {
          "success": false,
          "message": data["message"] ?? "Error desconocido"
        };
      }
    } catch (e) {
      return {"success": false, "message": "Error de conexión: $e"};
    }
  }
}
