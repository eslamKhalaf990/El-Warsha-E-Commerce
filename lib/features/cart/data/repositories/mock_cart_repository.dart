import 'dart:math';

import 'package:dartz/dartz.dart';
import 'package:warsha_commerce/core/config/mock_debug_state.dart';
import 'package:warsha_commerce/core/error/failures.dart';
import 'package:warsha_commerce/core/utils/governorates.dart';
import 'package:warsha_commerce/features/shipping/domain/repositories/shipping_repository.dart';
import 'package:warsha_commerce/features/cart/domain/entities/cart_item.dart';
import 'package:warsha_commerce/features/cart/domain/repositories/cart_repository.dart';
import 'package:warsha_commerce/features/catalog/domain/entities/product.dart';
import 'package:warsha_commerce/features/catalog/domain/entities/product_variant.dart';

class MockCartRepository implements CartRepository {
  final MockDebugController _debugController;
  final ShippingRepository? shippingRepository;
  final Random _random = Random();

  /// In-memory cart items (defaults to empty unless explicit initial items provided)
  late List<CartItem> _items;
  String? _appliedPromoCode;

  MockCartRepository({
    MockDebugController? debugController,
    List<CartItem>? initialItems,
    this.shippingRepository,
  }) : _debugController = debugController ?? MockDebugController.instance {
    resetToInitial(initialItems);
  }

  void resetToInitial([List<CartItem>? items]) {
    _appliedPromoCode = null;
    _items = items != null ? List<CartItem>.from(items) : [];
  }

  Future<void> _simulateLatency() async {
    final ms = 200 + _random.nextInt(200); // 200-400 ms
    await Future.delayed(Duration(milliseconds: ms));
  }

  @override
  int getSubtotal() {
    return _items.fold(0, (sum, item) => sum + item.totalPrice);
  }

  @override
  int getShippingFee([String? governorate]) {
    if (_items.isEmpty) return 0;
    final gov = governorate ?? (Governorates.all.isEmpty ? '' : Governorates.all.first);
    final price = shippingRepository?.getCachedPrice(gov) ??
        Governorates.getPrice(gov) ?? 0;
    return (price * 100).round();
  }

  @override
  int getDiscount({String? promoCode}) {
    final code = promoCode ?? _appliedPromoCode;
    final subtotal = getSubtotal();
    if (subtotal == 0) return 0;

    if (code?.toUpperCase() == 'WARSHA10' || code?.toUpperCase() == 'ROSE10') {
      return (subtotal * 0.10).round();
    }
    return 0;
  }

  @override
  String? getAppliedPromoCode() => _appliedPromoCode;

  @override
  void removePromoCode() {
    _appliedPromoCode = null;
  }

  @override
  int getTotal({String? promoCode}) {
    final subtotal = getSubtotal();
    if (subtotal == 0) return 0;
    final discount = getDiscount(promoCode: promoCode);
    final shipping = getShippingFee();
    return max(0, subtotal - discount + shipping);
  }

  @override
  Future<Either<Failure, List<CartItem>>> getCart() async {
    await _simulateLatency();

    switch (_debugController.state) {
      case MockRepoState.error:
        return const Left(ServerFailure('Failed to load cart'));
      case MockRepoState.empty:
        return const Right([]);
      case MockRepoState.loading:
        await Future.delayed(const Duration(seconds: 10));
        return const Right([]);
      case MockRepoState.normal:
        return Right(List.unmodifiable(_items));
    }
  }

  @override
  Future<Either<Failure, List<CartItem>>> addToCart(
    Product product, [
    int quantity = 1,
    ProductVariant? variant,
  ]) async {
    await _simulateLatency();

    switch (_debugController.state) {
      case MockRepoState.error:
        return const Left(ServerFailure('Failed to add item to cart'));
      case MockRepoState.empty:
      case MockRepoState.loading:
      case MockRepoState.normal:
        final existingIndex = _items.indexWhere(
          (item) => item.isLine(product.id, variant?.id),
        );
        if (existingIndex >= 0) {
          final existing = _items[existingIndex];
          _items[existingIndex] = existing.copyWith(
            quantity: existing.quantity + quantity,
          );
        } else {
          _items.add(CartItem(product: product, quantity: quantity, variant: variant));
        }
        return Right(List.unmodifiable(_items));
    }
  }

  @override
  Future<Either<Failure, List<CartItem>>> updateQuantity(
    int productId,
    int quantity, {
    int? variantId,
  }) async {
    await _simulateLatency();

    switch (_debugController.state) {
      case MockRepoState.error:
        return const Left(ServerFailure('Failed to update quantity'));
      case MockRepoState.empty:
      case MockRepoState.loading:
      case MockRepoState.normal:
        final index = _items.indexWhere((item) => item.isLine(productId, variantId));
        if (index >= 0) {
          if (quantity <= 0) {
            _items.removeAt(index);
          } else {
            _items[index] = _items[index].copyWith(quantity: quantity);
          }
        }
        return Right(List.unmodifiable(_items));
    }
  }

  @override
  Future<Either<Failure, List<CartItem>>> removeFromCart(
    int productId, {
    int? variantId,
  }) async {
    await _simulateLatency();

    switch (_debugController.state) {
      case MockRepoState.error:
        return const Left(ServerFailure('Failed to remove item'));
      case MockRepoState.empty:
      case MockRepoState.loading:
      case MockRepoState.normal:
        _items.removeWhere((item) => item.isLine(productId, variantId));
        return Right(List.unmodifiable(_items));
    }
  }

  @override
  Future<Either<Failure, Unit>> clearCart() async {
    await _simulateLatency();

    switch (_debugController.state) {
      case MockRepoState.error:
        return const Left(ServerFailure('Failed to clear cart'));
      case MockRepoState.empty:
      case MockRepoState.loading:
      case MockRepoState.normal:
        _items.clear();
        _appliedPromoCode = null;
        return const Right(unit);
    }
  }

  @override
  Future<Either<Failure, int>> applyPromoCode(String promoCode) async {
    await _simulateLatency();

    switch (_debugController.state) {
      case MockRepoState.error:
        return const Left(ServerFailure('Failed to validate promo code'));
      case MockRepoState.empty:
      case MockRepoState.loading:
      case MockRepoState.normal:
        final code = promoCode.trim().toUpperCase();
        if (code == 'WARSHA10' || code == 'ROSE10') {
          _appliedPromoCode = code;
          final discount = (getSubtotal() * 0.10).round();
          return Right(discount);
        }
        return const Left(
          ValidationFailure('كود الخصم غير صالح أو منتهي الصلاحية'),
        );
    }
  }
}
