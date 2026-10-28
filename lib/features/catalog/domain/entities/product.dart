import 'package:equatable/equatable.dart';
import 'package:warsha_commerce/features/catalog/domain/entities/product_variant.dart';

class Product extends Equatable {
  final int id;
  final String name;
  final String description;

  /// Arabic name/description; empty when the admin hasn't entered them.
  final String nameAr;
  final String descriptionAr;

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

  /// Sizes/colors; empty for products without variants.
  final List<ProductVariant> variants;

  /// Extra gallery image URLs shown after the cover [imageUrl], in order.
  final List<String> images;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    this.nameAr = '',
    this.descriptionAr = '',
    this.buyingPrice,
    required this.sellingPrice,
    required this.discount,
    required this.totalPrice,
    this.imageUrl,
    required this.sku,
    required this.quantity,
    required this.categoryName,
    required this.categoryId,
    this.variants = const [],
    this.images = const [],
  });

  bool get isOutOfStock => quantity <= 0;
  bool get hasVariants => variants.isNotEmpty;

  /// Every image to swipe through: the cover first, then the gallery.
  List<String?> get galleryImages => [
        if (imageUrl != null && imageUrl!.isNotEmpty) imageUrl,
        ...images.where((url) => url != imageUrl),
      ];

  /// Name in the given language, falling back to English.
  String nameFor(String languageCode) =>
      languageCode == 'ar' && nameAr.isNotEmpty ? nameAr : name;

  /// Description in the given language, falling back to English.
  String descriptionFor(String languageCode) =>
      languageCode == 'ar' && descriptionAr.isNotEmpty ? descriptionAr : description;

  ProductVariant? variantById(int? id) {
    if (id == null) return null;
    for (final v in variants) {
      if (v.id == id) return v;
    }
    return null;
  }
  bool get hasDiscount => discount > 0;

  Product copyWith({
    int? id,
    String? name,
    String? description,
    String? nameAr,
    String? descriptionAr,
    int? buyingPrice,
    int? sellingPrice,
    int? discount,
    int? totalPrice,
    String? imageUrl,
    String? sku,
    int? quantity,
    String? categoryName,
    int? categoryId,
    List<ProductVariant>? variants,
    List<String>? images,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      nameAr: nameAr ?? this.nameAr,
      descriptionAr: descriptionAr ?? this.descriptionAr,
      buyingPrice: buyingPrice ?? this.buyingPrice,
      sellingPrice: sellingPrice ?? this.sellingPrice,
      discount: discount ?? this.discount,
      totalPrice: totalPrice ?? this.totalPrice,
      imageUrl: imageUrl ?? this.imageUrl,
      sku: sku ?? this.sku,
      quantity: quantity ?? this.quantity,
      categoryName: categoryName ?? this.categoryName,
      categoryId: categoryId ?? this.categoryId,
      variants: variants ?? this.variants,
      images: images ?? this.images,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    nameAr,
    descriptionAr,
    buyingPrice,
    sellingPrice,
    discount,
    totalPrice,
    imageUrl,
    sku,
    quantity,
    categoryName,
    categoryId,
    variants,
    images,
  ];
}
