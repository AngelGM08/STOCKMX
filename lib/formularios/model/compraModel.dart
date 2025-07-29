class CompraModel {
  final int idCompra;
  final int? idProv;
  final int? idProd;
  final double cantidad;
  final String unidad;
  final double total;

  CompraModel({
    required this.idCompra,
    required this.idProv,
    required this.idProd,
    required this.cantidad,
    required this.unidad,
    required this.total,
  });

  factory CompraModel.fromJson(Map<String, dynamic> json) {
    return CompraModel(
      idCompra: json['id_compra'] as int? ?? 0,
      idProv: json['id_proveedor'] as int? ?? 0,
      idProd: json['id_producto'] as int? ?? 0,
      cantidad: double.tryParse(json['cantidad'].toString()) ?? 0.0,
      unidad: json['unidad'] as String? ?? 'N/A',
      total: double.tryParse(json['total'].toString()) ?? 0.0,
    );
  }
}
