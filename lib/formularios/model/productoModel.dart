class ProductoModel {
  final int idProd;
  final String nombreProd;
  final String descripcion;
  final double precioU;

  ProductoModel({
    required this.idProd,
    required this.nombreProd,
    required this.descripcion,
    required this.precioU,
  });

  factory ProductoModel.fromJson(Map<String, dynamic> json) {
    return ProductoModel(
      idProd: json['id_producto'] as int? ?? 0,
      nombreProd: json['nombre_prod'] as String? ?? 'N/A',
      descripcion: json['descripcion'] as String? ?? 'N/A',
      //precioU: json['precio_unitario'] as String? ?? 'N/A',
      precioU: json['precio_unitario'] is double
          ? json['precio_unitario']
          : double.tryParse(json['precio_unitario'].toString()) ?? 0.0,
    );
  }
}
