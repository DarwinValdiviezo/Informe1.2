class User {
  final int id; // El id se maneja como entero
  final String name;
  final String email;

  User({required this.id, required this.name, required this.email});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'], // Espera un entero desde el backend
      name: json['name'],
      email: json['email'],
    );
  }
}
