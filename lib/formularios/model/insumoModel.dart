class InsumoModel {
  final int id;
  final double cantidadUsada;
  final String nombreProducto;
  final String nombreTamal;

  InsumoModel({
    required this.id,
    required this.cantidadUsada,
    required this.nombreProducto,
    required this.nombreTamal,
  });

  factory InsumoModel.fromJson(Map<String, dynamic> json) {
    return InsumoModel(
      id: json['id'],
      cantidadUsada: double.parse(json['cantidad_usada'].toString()),
      nombreProducto: json['compra']['producto']['nombre_prod'],
      nombreTamal: json['produccion']['tamal']['nombre_tamal'],
    );
  }
}
