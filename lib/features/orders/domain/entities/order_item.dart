import 'package:equatable/equatable.dart';

class OrderItem extends Equatable {
  final int productId;
  final String productName;
  final int quantity;

  /// Unit price in minor units (piastres)
  final int unitPrice;

  /// Total price in minor units (piastres) = unitPrice * quantity
  final int totalPrice;
  final String? imageUrl;

  const OrderItem({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
    this.imageUrl,
  });

  @override
  List<Object?> get props => [
    productId,
    productName,
    quantity,
    unitPrice,
    totalPrice,
    imageUrl,
  ];
}
