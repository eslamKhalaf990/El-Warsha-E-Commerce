import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:warsha_commerce/core/error/failures.dart';
import 'package:warsha_commerce/features/catalog/data/datasources/catalog_remote_datasource.dart';
import 'package:warsha_commerce/features/catalog/domain/entities/category.dart';
import 'package:warsha_commerce/features/catalog/domain/entities/product.dart';
import 'package:warsha_commerce/features/catalog/domain/repositories/catalog_repository.dart';

class CatalogRepositoryImpl implements CatalogRepository {
  final CatalogRemoteDataSource remoteDataSource;

  List<Product>? _cachedProducts;
  List<Category>? _cachedCategories;
  DateTime? _lastProductsFetch;
  static const Duration _cacheTtl = Duration(minutes: 5);

  CatalogRepositoryImpl({required this.remoteDataSource});

  bool get _isCacheValid =>
      _cachedProducts != null &&
      _lastProductsFetch != null &&
      DateTime.now().difference(_lastProductsFetch!) < _cacheTtl;

  void clearCache() {
    _cachedProducts = null;
    _cachedCategories = null;
    _lastProductsFetch = null;
  }

  Failure _mapDioException(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout ||
        e.type == DioExceptionType.connectionError) {
      return const NetworkFailure();
    }
    final status = e.response?.statusCode;
    if (status == 401) {
      return const UnauthorizedFailure();
    }
    if (status == 400) {
      final msg = e.response?.data?.toString() ?? 'Bad request';
      return ValidationFailure(msg);
    }
    final data = e.response?.data;
    if (data is Map && data.containsKey('message')) {
      return ServerFailure(data['message'].toString());
    }
    return ServerFailure(e.message ?? 'Server failure');
  }

  @override
  Future<Either<Failure, List<Category>>> getCategories() async {
    if (_cachedCategories != null && _cachedCategories!.isNotEmpty) {
      return Right(_cachedCategories!);
    }

    try {
      final categories = await remoteDataSource.getCategories();
      _cachedCategories = categories;
      return Right(categories);
    } on DioException catch (e) {
      return Left(_mapDioException(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Product>>> getProducts({int? categoryId}) async {
    try {
      if (categoryId == null) {
        if (_isCacheValid) {
          return Right(_cachedProducts!);
        }
        final products = await remoteDataSource.getProducts();
        _cachedProducts = products;
        _lastProductsFetch = DateTime.now();
        return Right(products);
      } else {
        // If we already have the full list cached, filter client-side for immediate response
        if (_isCacheValid) {
          final filtered = _cachedProducts!
              .where((p) => p.categoryId == categoryId)
              .toList();
          return Right(filtered);
        }
        // Otherwise fetch by category directly
        final products = await remoteDataSource.getProducts(
          categoryId: categoryId,
        );
        return Right(products);
      }
    } on DioException catch (e) {
      return Left(_mapDioException(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Product>> getProductById(int id) async {
    try {
      // First check cached products if available
      if (_cachedProducts != null) {
        try {
          final cached = _cachedProducts!.firstWhere((p) => p.id == id);
          return Right(cached);
        } catch (_) {
          // Fall through to network lookup
        }
      }

      final product = await remoteDataSource.getProductById(id);
      return Right(product);
    } on DioException catch (e) {
      return Left(_mapDioException(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Product>>> getNewArrivals({
    int? categoryId,
  }) async {
    final productsResult = await getProducts();
    return productsResult.fold((failure) => Left(failure), (products) {
      // ASSUMPTION: Higher id = newer arrivals in the Warsha catalog
      var list = List<Product>.from(products);
      if (categoryId != null) {
        list = list.where((p) => p.categoryId == categoryId).toList();
      }
      list.sort((a, b) => b.id.compareTo(a.id));
      return Right(list.take(8).toList());
    });
  }

  @override
  Future<Either<Failure, List<Product>>> getBestSellers() async {
    final productsResult = await getProducts();
    return productsResult.fold((failure) => Left(failure), (products) {
      // ASSUMPTION: Products with discount > 0 or highest discount represent featured best sellers
      final list = List<Product>.from(products);
      list.sort((a, b) {
        final discountCmp = b.discount.compareTo(a.discount);
        if (discountCmp != 0) return discountCmp;
        return b.id.compareTo(a.id);
      });
      return Right(list.take(6).toList());
    });
  }
}
