import 'package:flutter/material.dart';
import '../services/api_service.dart';

class ReadUsersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de Usuarios"),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: ApiService.getUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No se encontraron usuarios"));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final user = snapshot.data![index];
                return ListTile(
                  leading: Icon(Icons.person, color: Colors.green),
                  title: Text(user["name"]),
                  subtitle: Text(user["email"]),
                );
              },
            );
          }
        },
      ),
    );
  }
}
