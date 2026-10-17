import 'package:equatable/equatable.dart';
import 'package:warsha_commerce/features/cart/domain/entities/cart_item.dart';
import 'package:warsha_commerce/features/checkout/domain/entities/receipt_attachment.dart';
import 'package:warsha_commerce/features/profile/domain/entities/address.dart';

class CheckoutOrderParams extends Equatable {
  final Address shippingAddress;
  final String paymentMethod;
  final String? notes;
  final List<CartItem> cartItems;
  final int subtotal;
  final int deliveryFee;
  final int discount;
  final int total;
  final int downPayment;
  final ReceiptAttachment? depositReceipt;

  const CheckoutOrderParams({
    required this.shippingAddress,
    required this.paymentMethod,
    this.notes,
    required this.cartItems,
    required this.subtotal,
    required this.deliveryFee,
    required this.discount,
    required this.total,
    this.downPayment = 0,
    this.depositReceipt,
  });

  @override
  List<Object?> get props => [
    shippingAddress,
    paymentMethod,
    notes,
    cartItems,
    subtotal,
    deliveryFee,
    discount,
    total,
    downPayment,
    depositReceipt,
  ];
}
