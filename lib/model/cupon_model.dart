import 'package:pharma/model/product_model.dart';

class Cupon {
  final int id;
  final String codigo;
  final String tipo;
  final double monto;
  final double? minimo;
  final String? validoHasta;
  final bool envioGratis;
  final int? cuponBaseId;

  Cupon({
    required this.id,
    required this.codigo,
    required this.tipo,
    required this.monto,
    this.minimo,
    this.validoHasta,
    required this.envioGratis,
    this.cuponBaseId,
  });

  factory Cupon.fromJson(Map<String, dynamic> json) => Cupon(
    id: json['id'],
    codigo: json['codigo'],
    tipo: json['tipo'],
    monto: (json['monto'] ?? 0).toDouble(),
    minimo: json['minimo'] != null ? (json['minimo']).toDouble() : null,
    validoHasta: json['valido_hasta'],
    envioGratis: json['envio_gratis'] ?? false,
    cuponBaseId: json['cupon_base_id'],
  );
}

class ProductoConCupon {
  final Product producto;
  final Cupon cupon;

  ProductoConCupon({required this.producto, required this.cupon});

  factory ProductoConCupon.fromJson(Map<String, dynamic> json) {
    return ProductoConCupon(
      producto: Product.fromJson({
        'id': int.tryParse(json['id'].toString()) ?? 0,
        'name': json['name']?.toString() ?? '',
        'image': json['image']?.toString() ?? '',
        'price': json['price']?.toString() ?? '',
        // Podés sumar más campos si el JSON lo incluye más adelante
      }),
      cupon: Cupon.fromJson(json['cupon']),
    );
  }
}

class CuponDisponible {
  final int clienteCuponId;
  final String code;
  final String description;
  final double amount;
  final String type;
  final int freeShipping;

  CuponDisponible({
    required this.clienteCuponId,
    required this.code,
    required this.description,
    required this.amount,
    required this.type,
    required this.freeShipping,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CuponDisponible &&
          runtimeType == other.runtimeType &&
          clienteCuponId == other.clienteCuponId;

  @override
  int get hashCode => clienteCuponId.hashCode;

  factory CuponDisponible.fromJson(Map<String, dynamic> json) {
    return CuponDisponible(
      clienteCuponId: int.parse(json['cliente_cupon_id'].toString()),
      code: json['code'],
      description: json['description'],
      amount: double.parse(json['amount'].toString()),
      type: json['type'],
      freeShipping: int.parse(json['free_shipping'].toString()),
    );
  }
}
