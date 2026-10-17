import 'dart:math';

import 'package:dartz/dartz.dart';
import 'package:warsha_commerce/core/utils/governorates.dart';
import 'package:warsha_commerce/features/shipping/domain/repositories/shipping_repository.dart';
import 'package:warsha_commerce/features/cart/data/datasources/cart_local_datasource.dart';
import 'package:warsha_commerce/features/cart/domain/entities/cart_item.dart';
import 'package:warsha_commerce/features/cart/domain/repositories/cart_repository.dart';
import 'package:warsha_commerce/features/catalog/domain/entities/product.dart';
import 'package:warsha_commerce/features/catalog/domain/repositories/catalog_repository.dart';

class CartRepositoryImpl implements CartRepository {
  final CartLocalDataSource localDataSource;
  final CatalogRepository? catalogRepository;
  final ShippingRepository? shippingRepository;

  List<CartItem> _items = <CartItem>[];
  String? _appliedPromoCode;

  CartRepositoryImpl({
    required this.localDataSource,
    this.catalogRepository,
    this.shippingRepository,
  });

  @override
  int getSubtotal() {
    return _items.fold(0, (sum, item) => sum + item.totalPrice);
  }

  @override
  int getShippingFee([String governorate = 'القاهرة']) {
    if (_items.isEmpty) return 0;
    final price = shippingRepository?.getCachedPrice(governorate) ??
        Governorates.getPrice(governorate);
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
    localDataSource.saveAppliedPromoCode(null);
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
    try {
      final cachedItems = await localDataSource.getCartItems();
      _appliedPromoCode = await localDataSource.getAppliedPromoCode();

      // Optionally reconcile items with live backend product data if catalogRepository is available
      if (catalogRepository != null && cachedItems.isNotEmpty) {
        final List<CartItem> reconciled = [];
        for (final item in cachedItems) {
          final productResult = await catalogRepository!.getProductById(item.product.id);
          productResult.fold(
            (failure) {
              // Network error or product unavailable: keep cached item as fallback
              reconciled.add(item);
            },
            (freshProduct) {
              // Update with latest backend product info (price, stock, image)
              final cappedQty = freshProduct.quantity > 0
                  ? min(item.quantity, freshProduct.quantity)
                  : item.quantity;
              reconciled.add(CartItem(product: freshProduct, quantity: cappedQty));
            },
          );
        }
        _items = List<CartItem>.from(reconciled);
        await _saveCurrentItems();
      } else {
        _items = List<CartItem>.from(cachedItems);
      }

      return Right(List.unmodifiable(_items));
    } catch (e) {
      return Left(ServerFailure('فشل استرجاع سلة التسوق: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<CartItem>>> addToCart(
    Product product, [
    int quantity = 1,
  ]) async {
    try {
      final existingIndex = _items.indexWhere(
        (item) => item.product.id == product.id,
      );

      final int maxStock = product.quantity > 0 ? product.quantity : 999;

      if (existingIndex >= 0) {
        final existing = _items[existingIndex];
        final newQty = min(existing.quantity + quantity, maxStock);
        _items[existingIndex] = existing.copyWith(
          product: product,
          quantity: newQty,
        );
      } else {
        final addQty = min(quantity, maxStock);
        _items.add(CartItem(product: product, quantity: addQty));
      }

      await _saveCurrentItems();
      return Right(List.unmodifiable(_items));
    } catch (e) {
      return Left(ServerFailure('فشل إضافة المنتج إلى السلة: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<CartItem>>> updateQuantity(
    int productId,
    int quantity,
  ) async {
    try {
      final index = _items.indexWhere((item) => item.product.id == productId);
      if (index >= 0) {
        if (quantity <= 0) {
          _items.removeAt(index);
        } else {
          final current = _items[index];
          final maxStock = current.product.quantity > 0
              ? current.product.quantity
              : 999;
          _items[index] = current.copyWith(
            quantity: min(quantity, maxStock),
          );
        }
        await _saveCurrentItems();
      }
      return Right(List.unmodifiable(_items));
    } catch (e) {
      return Left(ServerFailure('فشل تحديث الكمية: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<CartItem>>> removeFromCart(int productId) async {
    try {
      _items.removeWhere((item) => item.product.id == productId);
      await _saveCurrentItems();
      return Right(List.unmodifiable(_items));
    } catch (e) {
      return Left(ServerFailure('فشل إزالة المنتج من السلة: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Unit>> clearCart() async {
    try {
      _items.clear();
      _appliedPromoCode = null;
      await localDataSource.clearCart();
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure('فشل إفراغ السلة: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, int>> applyPromoCode(String promoCode) async {
    final code = promoCode.trim().toUpperCase();
    if (code == 'WARSHA10' || code == 'ROSE10') {
      _appliedPromoCode = code;
      await localDataSource.saveAppliedPromoCode(code);
      final discount = (getSubtotal() * 0.10).round();
      return Right(discount);
    }
    return const Left(
      ValidationFailure('كود الخصم غير صالح أو منتهي الصلاحية'),
    );
  }

  Future<void> _saveCurrentItems() async {
    await localDataSource.saveCartItems(_items);
  }
}
