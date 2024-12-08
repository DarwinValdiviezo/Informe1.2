import 'package:flutter/material.dart';
import 'package:informe1_2/styles/estilos.dart';
import '../services/api_service.dart';

class PantallaMenuCRUD extends StatefulWidget {
  final String token;
  final int idUsuario;

  PantallaMenuCRUD({
    required this.token,
    required this.idUsuario,
  });

  @override
  _PantallaMenuCRUDState createState() => _PantallaMenuCRUDState();
}

class _PantallaMenuCRUDState extends State<PantallaMenuCRUD> {
  late Future<List<dynamic>> _usuarios;

  @override
  void initState() {
    super.initState();
    _recargarUsuarios();
  }

  void _recargarUsuarios() {
    setState(() {
      _usuarios = ApiService.getUsers();
    });
  }

  void _cerrarSesion() {
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }

  void _eliminarUsuario(int userId) async {
    final respuesta = await ApiService.deleteUser(widget.token, userId);

    if (respuesta["success"]) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Usuario eliminado correctamente."),
        backgroundColor: Colors.green,
      ));
      _recargarUsuarios();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(respuesta["message"] ?? "Error al eliminar usuario."),
        backgroundColor: Colors.red,
      ));
    }
  }

  void _editarUsuario(Map<String, dynamic> usuario) {
    final id = usuario["id"] is int
        ? usuario["id"]
        : int.tryParse(usuario["id"].toString()) ?? 0;

    TextEditingController _controladorNombre =
        TextEditingController(text: usuario["name"] ?? "");
    TextEditingController _controladorCorreo =
        TextEditingController(text: usuario["email"] ?? "");

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Editar Usuario"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _controladorNombre,
                decoration:
                    Estilos.decoracionInput("Nombre", Icons.person_outline),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _controladorCorreo,
                decoration: Estilos.decoracionInput(
                    "Correo Electrónico", Icons.email_outlined),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancelar"),
            ),
            ElevatedButton(
              onPressed: () async {
                final respuesta = await ApiService.updateUser(
                  widget.token,
                  id,
                  _controladorNombre.text.trim(),
                  _controladorCorreo.text.trim(),
                );

                Navigator.pop(context);

                if (respuesta["success"]) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("Usuario actualizado correctamente."),
                    backgroundColor: Colors.green,
                  ));
                  _recargarUsuarios();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content:
                        Text(respuesta["message"] ?? "Error al actualizar."),
                    backgroundColor: Colors.red,
                  ));
                }
              },
              child: Text("Guardar"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Estilos.colorPrimario,
        title: Text(
          "CRUD API",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white),
            onPressed: _cerrarSesion,
          ),
        ],
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _usuarios,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                "Error al cargar usuarios: ${snapshot.error}",
                style: Estilos.estiloError,
                textAlign: TextAlign.center,
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                "No hay usuarios registrados.",
                style: Estilos.estiloInformativo,
                textAlign: TextAlign.center,
              ),
            );
          } else {
            final usuarios = snapshot.data!;
            return ListView.builder(
              itemCount: usuarios.length,
              itemBuilder: (context, index) {
                final usuario = usuarios[index];
                final userId = usuario["id"] is int
                    ? usuario["id"]
                    : int.tryParse(usuario["id"].toString()) ?? 0;

                final nombre = usuario["name"] ?? "Nombre no disponible";
                final email = usuario["email"] ?? "Correo no disponible";

                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Estilos.colorPrimario,
                      child: Icon(Icons.person, color: Colors.white),
                    ),
                    title: Text(
                      nombre,
                      style: Estilos.estiloEncabezado.copyWith(fontSize: 18),
                    ),
                    subtitle: Text(
                      email,
                      style: Estilos.estiloInformativo,
                    ),
                    trailing: widget.idUsuario ==
                            userId //este widget.idUsuario == userId sirve para que solo se muestre el icono de editar y eliminar en el usuario que esta logeado
                        //tailing sirve para poner un icono al final de la lista de usuarios
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit, color: Colors.blue),
                                onPressed: () => _editarUsuario(usuario),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text("Confirmar Eliminación"),
                                      content: Text(
                                          "¿Estás seguro de que deseas eliminar tu cuenta?"),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: Text("Cancelar"),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                            _eliminarUsuario(userId);
                                          },
                                          child: Text(
                                            "Eliminar",
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          )
                        : null, //este null sirve para que no se muestre el icono de editar y eliminar en usuarios que no estan logeados
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
