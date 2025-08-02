class Produccion {
  final int id;
  final String? fecha;
  final int? cantidadTotal;
  final String? nombreTamal;
  final int? idTamal;



  Produccion({
    required this.id,
    this.fecha,
    this.cantidadTotal,
    this.nombreTamal,
    this.idTamal,
  });

  factory Produccion.fromJson(Map<String, dynamic> json) {
    return Produccion(
      id: json['id_produccion'],
      fecha: json['fecha'],
      cantidadTotal: json['cantidad_total'],
      nombreTamal: json['nombre_tamal'], // Asegúrate de que tu API lo devuelva así
      idTamal: json['id_tamal'],   
    );
  }
}
