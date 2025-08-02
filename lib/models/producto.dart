class Producto {
  final int id;
  final String? nombre;
  final String? descripcion;
  final double? precio;

  Producto({
    required this.id,
    this.nombre,
    this.descripcion,
    this.precio,
  });

  factory Producto.fromJson(Map<String, dynamic> json) {
    return Producto(
      id: json['id_producto'],
      nombre: json['nombre_prod'],
      descripcion: json['descripcion'],
      precio: json['precio_unitario'] != null
          ? double.tryParse(json['precio_unitario'].toString())
          : null,
    );
  }
}
