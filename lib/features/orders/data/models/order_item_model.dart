import 'package:warsha_commerce/features/orders/domain/entities/order_item.dart';

class OrderItemModel extends OrderItem {
  const OrderItemModel({
    required super.productId,
    required super.productName,
    required super.quantity,
    required super.unitPrice,
    required super.totalPrice,
    super.imageUrl,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    final qty = (json['quantity'] as num?)?.toInt() ?? 1;
    final unitPriceDouble = (json['unitPrice'] as num?)?.toDouble() ?? 0.0;
    final unitPriceMinor = (unitPriceDouble * 100).round();

    final totalPriceDouble = (json['totalPrice'] as num?)?.toDouble();
    final totalPriceMinor = totalPriceDouble != null
        ? (totalPriceDouble * 100).round()
        : unitPriceMinor * qty;

    return OrderItemModel(
      productId: (json['productId'] ?? json['id'] ?? 0) as int,
      productName: (json['productName'] ?? json['name'] ?? '').toString(),
      quantity: qty,
      unitPrice: unitPriceMinor,
      totalPrice: totalPriceMinor,
      imageUrl: json['imageUrl']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'productName': productName,
      'quantity': quantity,
      'unitPrice': unitPrice / 100.0,
      'totalPrice': totalPrice / 100.0,
      if (imageUrl != null) 'imageUrl': imageUrl,
    };
  }
}
