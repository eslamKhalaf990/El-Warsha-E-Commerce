import 'package:dartz/dartz.dart' hide Order;
import 'package:warsha_commerce/core/error/failures.dart';
import 'package:warsha_commerce/features/orders/domain/entities/order.dart';

abstract class OrdersRepository {
  Future<Either<Failure, List<Order>>> getCustomerOrders();
  Future<Either<Failure, Order>> getOrderById(int orderId);
}
