import 'package:warsha_commerce/features/catalog/domain/entities/product.dart';

class ProductModel extends Product {
  const ProductModel({
    required super.id,
    required super.name,
    required super.description,
    super.buyingPrice,
    required super.sellingPrice,
    required super.discount,
    required super.totalPrice,
    super.imageUrl,
    required super.sku,
    required super.quantity,
    required super.categoryName,
    required super.categoryId,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    // The Warsha backend sends prices in EGP (double or int).
    // Domain & UI represent money exclusively in minor units (piastres = 1/100 EGP).
    final sellingPriceDouble =
        (json['sellingPrice'] as num?)?.toDouble() ?? 0.0;
    final sellingPriceMinor = (sellingPriceDouble * 100).round();

    final discountDouble = (json['discount'] as num?)?.toDouble() ?? 0.0;
    final discountMinor = (discountDouble * 100).round();

    final totalPriceDouble = (json['totalPrice'] as num?)?.toDouble();
    final totalPriceMinor = totalPriceDouble != null
        ? (totalPriceDouble * 100).round()
        : (sellingPriceMinor - discountMinor);

    // Quantity arrives as a string in Warsha backend ("10"). Safely parse to int.
    final rawQty = json['quantity'];
    final int parsedQty;
    if (rawQty is num) {
      parsedQty = rawQty.toInt();
    } else if (rawQty is String) {
      parsedQty = int.tryParse(rawQty) ?? 0;
    } else {
      parsedQty = 0;
    }

    return ProductModel(
      id: (json['id'] ?? json['productId'] ?? 0) as int,
      name: (json['name'] ?? json['productName'] ?? '').toString(),
      description: (json['description'] ?? '').toString(),
      // buyingPrice omitted per spec (internal cost price never exposed)
      buyingPrice: null,
      sellingPrice: sellingPriceMinor,
      discount: discountMinor,
      totalPrice: totalPriceMinor,
      imageUrl: json['imageUrl']?.toString(),
      sku: (json['sku'] ?? '').toString(),
      quantity: parsedQty,
      categoryId: (json['categoryId'] as num?)?.toInt() ?? 0,
      categoryName: (json['categoryName'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'sellingPrice': sellingPrice / 100.0,
      'discount': discount / 100.0,
      'totalPrice': totalPrice / 100.0,
      if (imageUrl != null) 'imageUrl': imageUrl,
      'sku': sku,
      'quantity': quantity.toString(),
      'categoryId': categoryId,
      'categoryName': categoryName,
    };
  }
}
