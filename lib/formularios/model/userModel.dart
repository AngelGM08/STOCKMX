class UserModel {
  final int id;
  final String name;
  final String email;
  final String password;
  final String rol;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.rol,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? 'N/A',
      email: json['email'] as String? ?? 'N/A',
      password: json['password'] as String? ?? 'N/A',
      rol: json['rol'] as String? ?? 'N/A',
    );
  }
}
