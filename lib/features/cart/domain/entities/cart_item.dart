import 'package:equatable/equatable.dart';
import 'package:warsha_commerce/features/catalog/domain/entities/product.dart';
import 'package:warsha_commerce/features/catalog/domain/entities/product_variant.dart';

class CartItem extends Equatable {
  final Product product;
  final int quantity;

  /// The chosen size/color; null for products without variants.
  final ProductVariant? variant;

  const CartItem({required this.product, required this.quantity, this.variant});

  int? get variantId => variant?.id;

  /// Final price of one unit in minor units (piastres).
  int get unitPrice => variant?.totalPrice ?? product.totalPrice;

  /// Total price for this cart row in minor units (piastres)
  int get totalPrice => unitPrice * quantity;

  /// Stock available for this row: the variant's, else the product's.
  int get availableStock => variant?.quantity ?? product.quantity;

  /// True when this row is for [productId] in the size/color [variantId].
  bool isLine(int productId, int? variantId) =>
      product.id == productId && this.variantId == variantId;

  CartItem copyWith({Product? product, int? quantity, ProductVariant? variant}) {
    return CartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      variant: variant ?? this.variant,
    );
  }

  @override
  List<Object?> get props => [product, quantity, variant];
}
