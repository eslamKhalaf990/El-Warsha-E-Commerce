import 'package:equatable/equatable.dart';
import 'package:warsha_commerce/features/orders/domain/entities/order_item.dart';
import 'package:warsha_commerce/features/orders/domain/entities/order_status.dart';
import 'package:warsha_commerce/features/orders/domain/entities/order_tracking_event.dart';
import 'package:warsha_commerce/features/profile/domain/entities/address.dart';

class Order extends Equatable {
  final int orderId;
  final String orderNumber;
  final DateTime orderDate;
  final OrderStatus status;
  final List<OrderItem> items;

  /// Subtotal in minor units (piastres)
  final int subtotal;

  /// Delivery fee in minor units (piastres)
  final int deliveryFee;

  /// Discount in minor units (piastres)
  final int discount;

  /// Final total in minor units (piastres) = subtotal + deliveryFee - discount - downPayment
  final int totalPrice;

  /// Down payment in minor units (piastres)
  final int downPayment;
  final String paymentMethod;
  final List<OrderTrackingEvent> trackingEvents;
  final Address? shippingAddress;

  const Order({
    required this.orderId,
    required this.orderNumber,
    required this.orderDate,
    required this.status,
    required this.items,
    required this.subtotal,
    required this.deliveryFee,
    required this.discount,
    required this.totalPrice,
    this.downPayment = 0,
    required this.paymentMethod,
    this.trackingEvents = const [],
    this.shippingAddress,
  });

  @override
  List<Object?> get props => [
    orderId,
    orderNumber,
    orderDate,
    status,
    items,
    subtotal,
    deliveryFee,
    discount,
    totalPrice,
    downPayment,
    paymentMethod,
    trackingEvents,
    shippingAddress,
  ];
}
