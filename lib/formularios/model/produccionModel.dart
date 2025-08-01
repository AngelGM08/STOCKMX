class ProduccionModel {
  final int idProduccion;
  final int? idTamal;
  final DateTime fecha;
  final int cantidadTotal;

  ProduccionModel({
    required this.idProduccion,
    required this.idTamal,
    required this.fecha,
    required this.cantidadTotal,
  });

  factory ProduccionModel.fromJson(Map<String, dynamic> json) {
    return ProduccionModel(
      idProduccion: json['id_produccion'] as int? ?? 0,
      idTamal: json['id_tamal'] as int? ?? 0,
      fecha: json['fecha'] != null ? DateTime.parse(json['fecha']) : DateTime.now(),
      cantidadTotal: json['cantidad_total'] as int? ?? 0
    );
  }
}