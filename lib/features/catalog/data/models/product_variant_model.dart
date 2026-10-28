import 'package:warsha_commerce/features/catalog/domain/entities/product_variant.dart';

class ProductVariantModel extends ProductVariant {
  const ProductVariantModel({
    required super.id,
    super.size,
    super.color,
    super.colorAr,
    super.colorHex,
    super.sku,
    required super.price,
    required super.totalPrice,
    required super.quantity,
    super.imageUrl,
  });

  /// The backend sends prices in EGP; the app keeps minor units.
  factory ProductVariantModel.fromJson(Map<String, dynamic> json) {
    int minor(Object? v) => (((v as num?)?.toDouble() ?? 0) * 100).round();
    String? text(Object? v) => (v == null || v.toString().isEmpty) ? null : v.toString();
    return ProductVariantModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      size: text(json['size']),
      color: text(json['color']),
      colorAr: text(json['colorAr']),
      colorHex: text(json['colorHex']),
      sku: text(json['sku']),
      price: minor(json['price']),
      totalPrice: minor(json['totalPrice']),
      quantity: (json['quantity'] as num?)?.toInt() ?? 0,
      imageUrl: text(json['imageUrl']),
    );
  }

  static Map<String, dynamic> toJsonOf(ProductVariant v) => {
        'id': v.id,
        'size': v.size,
        'color': v.color,
        'colorAr': v.colorAr,
        'colorHex': v.colorHex,
        'sku': v.sku,
        'price': v.price / 100.0,
        'totalPrice': v.totalPrice / 100.0,
        'quantity': v.quantity,
        'imageUrl': v.imageUrl,
      };
}
