import 'dart:math';

import 'package:dartz/dartz.dart';
import 'package:warsha_commerce/core/config/mock_debug_state.dart';
import 'package:warsha_commerce/core/error/failures.dart';
import 'package:warsha_commerce/features/catalog/data/repositories/mock_catalog_data.dart';
import 'package:warsha_commerce/features/catalog/domain/entities/category.dart';
import 'package:warsha_commerce/features/catalog/domain/entities/product.dart';
import 'package:warsha_commerce/features/catalog/domain/repositories/catalog_repository.dart';

class MockCatalogRepository implements CatalogRepository {
  final MockDebugController _debugController;
  final Random _random = Random();

  MockCatalogRepository({MockDebugController? debugController})
    : _debugController = debugController ?? MockDebugController.instance;

  Future<void> _simulateLatency() async {
    final ms = 300 + _random.nextInt(300); // 300-600 ms
    await Future.delayed(Duration(milliseconds: ms));
  }

  @override
  Future<Either<Failure, List<Category>>> getCategories() async {
    await _simulateLatency();

    switch (_debugController.state) {
      case MockRepoState.error:
        return const Left(ServerFailure('Failed to load categories'));
      case MockRepoState.empty:
        return const Right([]);
      case MockRepoState.loading:
        await Future.delayed(const Duration(seconds: 10));
        return const Right([]);
      case MockRepoState.normal:
        return Right(mockCategories);
    }
  }

  @override
  Future<Either<Failure, List<Product>>> getProducts({int? categoryId}) async {
    await _simulateLatency();

    switch (_debugController.state) {
      case MockRepoState.error:
        return const Left(ServerFailure('Failed to load products'));
      case MockRepoState.empty:
        return const Right([]);
      case MockRepoState.loading:
        await Future.delayed(const Duration(seconds: 10));
        return const Right([]);
      case MockRepoState.normal:
        if (categoryId != null) {
          final filtered = mockProducts
              .where((product) => product.categoryId == categoryId)
              .toList();
          return Right(filtered);
        }
        return Right(mockProducts);
    }
  }

  @override
  Future<Either<Failure, Product>> getProductById(int id) async {
    await _simulateLatency();

    switch (_debugController.state) {
      case MockRepoState.error:
        return const Left(ServerFailure('Failed to load product'));
      case MockRepoState.empty:
      case MockRepoState.loading:
      case MockRepoState.normal:
        try {
          final product = mockProducts.firstWhere((p) => p.id == id);
          return Right(product);
        } catch (_) {
          return const Left(ServerFailure('Product not found'));
        }
    }
  }

  @override
  Future<Either<Failure, List<Product>>> getNewArrivals({
    int? categoryId,
  }) async {
    await _simulateLatency();

    switch (_debugController.state) {
      case MockRepoState.error:
        return const Left(ServerFailure('Failed to load new arrivals'));
      case MockRepoState.empty:
        return const Right([]);
      case MockRepoState.loading:
        await Future.delayed(const Duration(seconds: 10));
        return const Right([]);
      case MockRepoState.normal:
        // Use highest IDs for "new" products, optionally filtered by category
        var list = List<Product>.from(mockProducts);
        if (categoryId != null) {
          list = list.where((p) => p.categoryId == categoryId).toList();
        }
        list.sort((a, b) => b.id.compareTo(a.id));
        return Right(list.take(8).toList());
    }
  }

  @override
  Future<Either<Failure, List<Product>>> getBestSellers() async {
    await _simulateLatency();

    switch (_debugController.state) {
      case MockRepoState.error:
        return const Left(ServerFailure('Failed to load best sellers'));
      case MockRepoState.empty:
        return const Right([]);
      case MockRepoState.loading:
        await Future.delayed(const Duration(seconds: 10));
        return const Right([]);
      case MockRepoState.normal:
        // Distinct curated subset of top-selling accessories
        const bestSellerIds = [2, 4, 6, 8, 1, 10];
        final list = mockProducts
            .where((p) => bestSellerIds.contains(p.id))
            .toList();
        return Right(list);
    }
  }
}
