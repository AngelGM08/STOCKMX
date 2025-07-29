class ProveedorModel {
  final int idP;
  final String nombre;
  final String apellidoPaterno;
  final String apellidoMaterno;
  final String telefono;
  final String email;

  ProveedorModel({
    required this.idP,
    required this.nombre,
    required this.apellidoPaterno,
    required this.apellidoMaterno,
    required this.telefono,
    required this.email,
  });

  factory ProveedorModel.fromJson(Map<String, dynamic> json) {
    return ProveedorModel(
      idP: json['id_proveedor'] as int? ?? 0,
      nombre: json['nombre'] as String? ?? 'N/A',
      apellidoPaterno: json['apellido_paterno'] as String? ?? 'N/A',
      apellidoMaterno: json['apellido_materno'] as String? ?? 'N/A',
      telefono: json['telefono'] as String? ?? 'N/A',
      email: json['email'] as String? ?? 'N/A',
    );
  }
}
