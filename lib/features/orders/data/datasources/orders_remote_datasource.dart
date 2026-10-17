import 'package:warsha_commerce/core/network/api_constants.dart';
import 'package:warsha_commerce/core/network/dio_client.dart';
import 'package:warsha_commerce/features/orders/data/models/order_model.dart';

abstract class OrdersRemoteDataSource {
  Future<List<OrderModel>> getCustomerOrders();
}

class OrdersRemoteDataSourceImpl implements OrdersRemoteDataSource {
  final DioClient client;

  OrdersRemoteDataSourceImpl({required this.client});

  @override
  Future<List<OrderModel>> getCustomerOrders() async {
    final response = await client.dio.get(ApiConstants.customerOrders);
    final data = response.data;
    if (data is List) {
      return data
          .map((item) => OrderModel.fromJson(item as Map<String, dynamic>))
          .toList();
    }
    return [];
  }
}
