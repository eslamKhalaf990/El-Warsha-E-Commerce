import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:warsha_commerce/features/cart/data/models/cart_item_model.dart';
import 'package:warsha_commerce/features/cart/domain/entities/cart_item.dart';

abstract class CartLocalDataSource {
  Future<List<CartItem>> getCartItems();
  Future<void> saveCartItems(List<CartItem> items);
  Future<void> clearCart();
  Future<String?> getAppliedPromoCode();
  Future<void> saveAppliedPromoCode(String? promoCode);
}

class CartLocalDataSourceImpl implements CartLocalDataSource {
  final SharedPreferences sharedPreferences;
  static const String cartItemsKey = 'cached_cart_items';
  static const String cartPromoKey = 'cached_cart_promo_code';

  CartLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<CartItem>> getCartItems() async {
    final rawJson = sharedPreferences.getString(cartItemsKey);
    if (rawJson == null || rawJson.trim().isEmpty) {
      return <CartItem>[];
    }
    try {
      final decoded = jsonDecode(rawJson);
      if (decoded is List) {
        return decoded
            .map((item) {
              final model = CartItemModel.fromJson(
                item as Map<String, dynamic>,
              );
              return CartItem(
                product: model.product,
                quantity: model.quantity,
              );
            })
            .toList();
      }
    } catch (_) {
      // If corrupted, reset gracefully
      await sharedPreferences.remove(cartItemsKey);
    }
    return <CartItem>[];
  }

  @override
  Future<void> saveCartItems(List<CartItem> items) async {
    final jsonList = items
        .map((i) => CartItemModel.fromEntity(i).toJson())
        .toList();
    await sharedPreferences.setString(cartItemsKey, jsonEncode(jsonList));
  }

  @override
  Future<void> clearCart() async {
    await sharedPreferences.remove(cartItemsKey);
    await sharedPreferences.remove(cartPromoKey);
  }

  @override
  Future<String?> getAppliedPromoCode() async {
    return sharedPreferences.getString(cartPromoKey);
  }

  @override
  Future<void> saveAppliedPromoCode(String? promoCode) async {
    if (promoCode == null || promoCode.trim().isEmpty) {
      await sharedPreferences.remove(cartPromoKey);
    } else {
      await sharedPreferences.setString(
        cartPromoKey,
        promoCode.trim().toUpperCase(),
      );
    }
  }
}
