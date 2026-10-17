import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final int id;
  final String name;
  final String description;

  /// Internal cost price in minor units (piastres).
  /// NEVER display this in the UI. Flagged as sensitive backend exposure.
  final int? buyingPrice;

  /// Selling price before discount in minor units (piastres).
  final int sellingPrice;

  /// Discount amount in minor units (piastres).
  final int discount;

  /// Final price in minor units (piastres) = sellingPrice - discount.
  final int totalPrice;
  final String? imageUrl;
  final String sku;
  final int quantity;
  final String categoryName;
  final int categoryId;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    this.buyingPrice,
    required this.sellingPrice,
    required this.discount,
    required this.totalPrice,
    this.imageUrl,
    required this.sku,
    required this.quantity,
    required this.categoryName,
    required this.categoryId,
  });

  bool get isOutOfStock => quantity <= 0;
  bool get hasDiscount => discount > 0;

  Product copyWith({
    int? id,
    String? name,
    String? description,
    int? buyingPrice,
    int? sellingPrice,
    int? discount,
    int? totalPrice,
    String? imageUrl,
    String? sku,
    int? quantity,
    String? categoryName,
    int? categoryId,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      buyingPrice: buyingPrice ?? this.buyingPrice,
      sellingPrice: sellingPrice ?? this.sellingPrice,
      discount: discount ?? this.discount,
      totalPrice: totalPrice ?? this.totalPrice,
      imageUrl: imageUrl ?? this.imageUrl,
      sku: sku ?? this.sku,
      quantity: quantity ?? this.quantity,
      categoryName: categoryName ?? this.categoryName,
      categoryId: categoryId ?? this.categoryId,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    buyingPrice,
    sellingPrice,
    discount,
    totalPrice,
    imageUrl,
    sku,
    quantity,
    categoryName,
    categoryId,
  ];
}
