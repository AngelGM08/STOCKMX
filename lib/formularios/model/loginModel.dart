class LoginResponse {
  final String acceso;
  final String token;
  final String error;
  final int idUsuario;
  final String nombreUsuario;

  LoginResponse(
    this.acceso,
    this.token,
    this.error,
    this.idUsuario,
    this.nombreUsuario,
  );

  LoginResponse.fromJson(Map<String, dynamic> json)
    : acceso = json['acceso'],
      error = json['error'],
      token = json['token'],
      idUsuario = json['idUsuario'],
      nombreUsuario = json['nombreUsuario'];
}
