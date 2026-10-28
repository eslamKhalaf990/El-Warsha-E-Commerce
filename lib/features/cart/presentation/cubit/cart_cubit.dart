import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:warsha_commerce/features/cart/domain/repositories/cart_repository.dart';
import 'package:warsha_commerce/features/cart/presentation/cubit/cart_state.dart';
import 'package:warsha_commerce/features/catalog/domain/entities/product.dart';
import 'package:warsha_commerce/features/catalog/domain/entities/product_variant.dart';

class CartCubit extends Cubit<CartState> {
  final CartRepository cartRepository;

  CartCubit({required this.cartRepository}) : super(const CartState());

  Future<void> loadCart() async {
    emit(state.copyWith(status: CartStatus.loading));
    final result = await cartRepository.getCart();

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: CartStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (items) => emit(
        state.copyWith(
          status: CartStatus.success,
          items: items,
          subtotal: cartRepository.getSubtotal(),
          shippingFee: cartRepository.getShippingFee(),
          discount: cartRepository.getDiscount(),
          total: cartRepository.getTotal(),
          appliedPromoCode: cartRepository.getAppliedPromoCode(),
          errorMessage: null,
        ),
      ),
    );
  }

  Future<void> addToCart(Product product, [int quantity = 1, ProductVariant? variant]) async {
    final result = await cartRepository.addToCart(product, quantity, variant);

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: CartStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (items) => emit(
        state.copyWith(
          status: CartStatus.success,
          items: items,
          subtotal: cartRepository.getSubtotal(),
          shippingFee: cartRepository.getShippingFee(),
          discount: cartRepository.getDiscount(),
          total: cartRepository.getTotal(),
          errorMessage: null,
        ),
      ),
    );
  }

  Future<void> updateQuantity(int productId, int quantity, {int? variantId}) async {
    final result = await cartRepository.updateQuantity(productId, quantity, variantId: variantId);

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: CartStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (items) => emit(
        state.copyWith(
          status: CartStatus.success,
          items: items,
          subtotal: cartRepository.getSubtotal(),
          shippingFee: cartRepository.getShippingFee(),
          discount: cartRepository.getDiscount(),
          total: cartRepository.getTotal(),
          errorMessage: null,
        ),
      ),
    );
  }

  Future<void> removeFromCart(int productId, {int? variantId}) async {
    final result = await cartRepository.removeFromCart(productId, variantId: variantId);

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: CartStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (items) => emit(
        state.copyWith(
          status: CartStatus.success,
          items: items,
          subtotal: cartRepository.getSubtotal(),
          shippingFee: cartRepository.getShippingFee(),
          discount: cartRepository.getDiscount(),
          total: cartRepository.getTotal(),
          errorMessage: null,
        ),
      ),
    );
  }

  Future<void> clearCart() async {
    final result = await cartRepository.clearCart();

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: CartStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (_) => emit(
        state.copyWith(
          status: CartStatus.success,
          items: const [],
          subtotal: 0,
          shippingFee: 0,
          discount: 0,
          total: 0,
          clearPromoCode: true,
          errorMessage: null,
        ),
      ),
    );
  }

  Future<void> applyPromoCode(String promoCode) async {
    if (promoCode.trim().isEmpty) return;

    emit(state.copyWith(isApplyingPromo: true, clearPromoErrorMessage: true));

    final result = await cartRepository.applyPromoCode(promoCode);

    result.fold(
      (failure) => emit(
        state.copyWith(
          isApplyingPromo: false,
          promoErrorMessage: failure.message,
        ),
      ),
      (discount) => emit(
        state.copyWith(
          isApplyingPromo: false,
          appliedPromoCode: promoCode.trim().toUpperCase(),
          discount: discount,
          total: cartRepository.getTotal(),
          clearPromoErrorMessage: true,
        ),
      ),
    );
  }

  void removePromoCode() {
    cartRepository.removePromoCode();
    emit(
      state.copyWith(
        clearPromoCode: true,
        discount: 0,
        total: cartRepository.getTotal(),
        clearPromoErrorMessage: true,
      ),
    );
  }
}
