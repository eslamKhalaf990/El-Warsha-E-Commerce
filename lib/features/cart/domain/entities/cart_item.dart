import 'package:equatable/equatable.dart';
import 'package:warsha_commerce/features/catalog/domain/entities/product.dart';

class CartItem extends Equatable {
  final Product product;
  final int quantity;

  const CartItem({required this.product, required this.quantity});

  /// Total price for this cart row in minor units (piastres)
  int get totalPrice => product.totalPrice * quantity;

  CartItem copyWith({Product? product, int? quantity}) {
    return CartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  List<Object?> get props => [product, quantity];
}
