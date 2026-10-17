import 'package:dartz/dartz.dart' hide Order;
import 'package:dio/dio.dart';
import 'package:warsha_commerce/core/error/failures.dart';
import 'package:warsha_commerce/features/orders/data/datasources/orders_remote_datasource.dart';
import 'package:warsha_commerce/features/orders/domain/entities/order.dart';
import 'package:warsha_commerce/features/orders/domain/repositories/orders_repository.dart';

class OrdersRepositoryImpl implements OrdersRepository {
  final OrdersRemoteDataSource remoteDataSource;

  OrdersRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Order>>> getCustomerOrders() async {
    try {
      final orders = await remoteDataSource.getCustomerOrders();
      return Right(orders);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return const Left(UnauthorizedFailure());
      }
      return Left(ServerFailure(e.message ?? 'Failed to load customer orders'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Order>> getOrderById(int orderId) async {
    try {
      final orders = await remoteDataSource.getCustomerOrders();
      final order = orders.firstWhere((o) => o.orderId == orderId);
      return Right(order);
    } catch (e) {
      return const Left(ServerFailure('Order not found'));
    }
  }
}
