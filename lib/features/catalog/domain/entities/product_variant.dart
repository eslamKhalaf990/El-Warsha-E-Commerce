import 'package:equatable/equatable.dart';

/// One size/color of a product, with its own stock.
/// Prices are in minor units (piastres), like [Product].
class ProductVariant extends Equatable {
  final int id;
  final String? size;
  final String? color;
  final String? colorAr;

  /// e.g. `#1A1A1A`, for a swatch.
  final String? colorHex;
  final String? sku;

  /// Price before discount (the variant's own price, else the product's).
  final int price;

  /// Final price after the product discount.
  final int totalPrice;
  final int quantity;
  final String? imageUrl;

  const ProductVariant({
    required this.id,
    this.size,
    this.color,
    this.colorAr,
    this.colorHex,
    this.sku,
    required this.price,
    required this.totalPrice,
    required this.quantity,
    this.imageUrl,
  });

  bool get isOutOfStock => quantity <= 0;

  /// Color name in the given language, falling back to the other one.
  String? colorFor(String languageCode) =>
      languageCode == 'ar' && (colorAr?.isNotEmpty ?? false) ? colorAr : color;

  /// "M / أسود", "M" or "أسود".
  String labelFor(String languageCode) =>
      [size, colorFor(languageCode)].where((s) => s != null && s.isNotEmpty).join(' / ');

  @override
  List<Object?> get props => [id, size, color, colorAr, colorHex, sku, price, totalPrice, quantity, imageUrl];
}
