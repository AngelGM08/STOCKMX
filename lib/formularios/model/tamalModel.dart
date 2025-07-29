class TamalModel {
  final int idT;
  final String nomT;
  final String descripcion;

  TamalModel({
    required this.idT,
    required this.nomT,
    required this.descripcion,
  });

  factory TamalModel.fromJson(Map<String, dynamic> json) {
    return TamalModel(
      idT: json['id_tamal'] as int? ?? 0,
      nomT: json['nombre_tamal'] as String? ?? 'N/A',
      descripcion: json['descripcion'] as String? ?? 'N/A',
    );
  }
}
