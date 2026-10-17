import 'package:dartz/dartz.dart';
import 'package:warsha_commerce/core/error/failures.dart';
import 'package:warsha_commerce/features/cart/domain/entities/cart_item.dart';
import 'package:warsha_commerce/features/catalog/domain/entities/product.dart';

abstract class CartRepository {
  Future<Either<Failure, List<CartItem>>> getCart();
  Future<Either<Failure, List<CartItem>>> addToCart(
    Product product, [
    int quantity = 1,
  ]);
  Future<Either<Failure, List<CartItem>>> updateQuantity(
    int productId,
    int quantity,
  );
  Future<Either<Failure, List<CartItem>>> removeFromCart(int productId);
  Future<Either<Failure, Unit>> clearCart();
  Future<Either<Failure, int>> applyPromoCode(String promoCode);
  void removePromoCode();
  int getSubtotal();
  int getShippingFee();
  int getDiscount({String? promoCode});
  String? getAppliedPromoCode();
  int getTotal({String? promoCode});
}
