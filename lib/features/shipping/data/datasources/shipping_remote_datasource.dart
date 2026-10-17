import 'package:warsha_commerce/core/network/api_constants.dart';
import 'package:warsha_commerce/core/network/dio_client.dart';
import 'package:warsha_commerce/features/shipping/data/models/governorate_model.dart';

abstract class ShippingRemoteDataSource {
  Future<List<GovernorateModel>> getGovernorates();
  Future<Map<String, double>> getGovernoratesMap();
  Future<GovernorateModel> getGovernoratePrice(String governorate);
}

class ShippingRemoteDataSourceImpl implements ShippingRemoteDataSource {
  final DioClient client;

  ShippingRemoteDataSourceImpl({required this.client});

  @override
  Future<List<GovernorateModel>> getGovernorates() async {
    final response = await client.dio.get(ApiConstants.governorates);
    final data = response.data;

    if (data is List) {
      return data
          .map((item) => GovernorateModel.fromJson(item as Map<String, dynamic>))
          .toList();
    }
    throw const FormatException('Unexpected response format from /governorates');
  }

  @override
  Future<Map<String, double>> getGovernoratesMap() async {
    final response = await client.dio.get(ApiConstants.governoratesMap);
    final data = response.data;

    if (data is Map) {
      return data.map(
        (key, value) => MapEntry(key.toString(), (value as num).toDouble()),
      );
    }
    throw const FormatException('Unexpected response format from /governorates/map');
  }

  @override
  Future<GovernorateModel> getGovernoratePrice(String governorate) async {
    final response = await client.dio.get(
      ApiConstants.governoratePrice(governorate),
    );
    final data = response.data;

    if (data is Map<String, dynamic>) {
      return GovernorateModel.fromJson(data);
    }
    throw const FormatException(
      'Unexpected response format from /governorates/price',
    );
  }
}
