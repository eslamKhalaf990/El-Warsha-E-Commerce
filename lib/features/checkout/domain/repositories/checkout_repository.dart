import 'package:dartz/dartz.dart' hide Order;
import 'package:warsha_commerce/core/error/failures.dart';
import 'package:warsha_commerce/features/checkout/domain/entities/checkout_order_params.dart';
import 'package:warsha_commerce/features/orders/domain/entities/order.dart';

abstract class CheckoutRepository {
  /// Calculate delivery fee in minor units (piastres) based on governorate name
  int calculateDeliveryFee(String governorate);

  /// Places a customer order and returns confirmed [Order]
  Future<Either<Failure, Order>> placeOrder(CheckoutOrderParams params);
}
