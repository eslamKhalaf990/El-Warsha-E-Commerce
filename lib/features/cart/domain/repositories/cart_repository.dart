import 'package:dartz/dartz.dart';
import 'package:warsha_commerce/core/error/failures.dart';
import 'package:warsha_commerce/features/cart/domain/entities/cart_item.dart';
import 'package:warsha_commerce/features/catalog/domain/entities/product.dart';
import 'package:warsha_commerce/features/catalog/domain/entities/product_variant.dart';

abstract class CartRepository {
  Future<Either<Failure, List<CartItem>>> getCart();
  /// [variant] is the chosen size/color; required for products with variants.
  Future<Either<Failure, List<CartItem>>> addToCart(
    Product product, [
    int quantity = 1,
    ProductVariant? variant,
  ]);
  Future<Either<Failure, List<CartItem>>> updateQuantity(
    int productId,
    int quantity, {
    int? variantId,
  });
  Future<Either<Failure, List<CartItem>>> removeFromCart(
    int productId, {
    int? variantId,
  });
  Future<Either<Failure, Unit>> clearCart();
  Future<Either<Failure, int>> applyPromoCode(String promoCode);
  void removePromoCode();
  int getSubtotal();
  int getShippingFee();
  int getDiscount({String? promoCode});
  String? getAppliedPromoCode();
  int getTotal({String? promoCode});
}
