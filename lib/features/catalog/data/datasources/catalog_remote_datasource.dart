import 'package:dio/dio.dart';
import 'package:warsha_commerce/core/network/api_constants.dart';
import 'package:warsha_commerce/core/network/dio_client.dart';
import 'package:warsha_commerce/features/catalog/data/models/category_model.dart';
import 'package:warsha_commerce/features/catalog/data/models/product_model.dart';

abstract class CatalogRemoteDataSource {
  Future<List<CategoryModel>> getCategories();
  Future<List<ProductModel>> getProducts({int? categoryId});
  Future<ProductModel> getProductById(int id);
}

class CatalogRemoteDataSourceImpl implements CatalogRemoteDataSource {
  final DioClient client;

  CatalogRemoteDataSourceImpl({required this.client});

  @override
  Future<List<CategoryModel>> getCategories() async {
    final response = await client.dio.get(ApiConstants.categories);
    final data = response.data;
    if (data is List) {
      return data
          .map((item) => CategoryModel.fromJson(item as Map<String, dynamic>))
          .toList();
    }
    throw const FormatException('Expected a list of categories from API');
  }

  @override
  Future<List<ProductModel>> getProducts({int? categoryId}) async {
    final Response response;
    if (categoryId != null) {
      response = await client.dio.get(
        ApiConstants.productsByCategory,
        queryParameters: {'categoryId': categoryId},
      );
    } else {
      response = await client.dio.get(ApiConstants.products);
    }

    final data = response.data;
    if (data is List) {
      return data
          .map((item) => ProductModel.fromJson(item as Map<String, dynamic>))
          .toList();
    }
    throw const FormatException('Expected a list of products from API');
  }

  @override
  Future<ProductModel> getProductById(int id) async {
    final response = await client.dio.get(ApiConstants.productDetails(id));
    final data = response.data;
    if (data is Map<String, dynamic>) {
      return ProductModel.fromJson(data);
    }
    throw const FormatException('Expected product object from API');
  }
}
