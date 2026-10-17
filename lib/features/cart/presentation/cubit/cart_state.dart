import 'package:equatable/equatable.dart';
import 'package:warsha_commerce/features/cart/domain/entities/cart_item.dart';

enum CartStatus { initial, loading, success, failure }

class CartState extends Equatable {
  final CartStatus status;
  final List<CartItem> items;
  final int subtotal;
  final int shippingFee;
  final int discount;
  final int total;
  final String? appliedPromoCode;
  final String? promoErrorMessage;
  final bool isApplyingPromo;
  final String? errorMessage;

  const CartState({
    this.status = CartStatus.initial,
    this.items = const [],
    this.subtotal = 0,
    this.shippingFee = 0,
    this.discount = 0,
    this.total = 0,
    this.appliedPromoCode,
    this.promoErrorMessage,
    this.isApplyingPromo = false,
    this.errorMessage,
  });

  /// Total count of all individual items in the cart
  int get itemCount => items.fold<int>(0, (sum, item) => sum + item.quantity);

  bool get isEmpty => items.isEmpty;

  CartState copyWith({
    CartStatus? status,
    List<CartItem>? items,
    int? subtotal,
    int? shippingFee,
    int? discount,
    int? total,
    String? appliedPromoCode,
    bool clearPromoCode = false,
    String? promoErrorMessage,
    bool clearPromoErrorMessage = false,
    bool? isApplyingPromo,
    String? errorMessage,
  }) {
    return CartState(
      status: status ?? this.status,
      items: items ?? this.items,
      subtotal: subtotal ?? this.subtotal,
      shippingFee: shippingFee ?? this.shippingFee,
      discount: discount ?? this.discount,
      total: total ?? this.total,
      appliedPromoCode: clearPromoCode
          ? null
          : (appliedPromoCode ?? this.appliedPromoCode),
      promoErrorMessage: clearPromoErrorMessage
          ? null
          : (promoErrorMessage ?? this.promoErrorMessage),
      isApplyingPromo: isApplyingPromo ?? this.isApplyingPromo,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    items,
    subtotal,
    shippingFee,
    discount,
    total,
    appliedPromoCode,
    promoErrorMessage,
    isApplyingPromo,
    errorMessage,
  ];
}
