import 'package:dartz/dartz.dart';
import 'package:warsha_commerce/core/error/failures.dart';
import 'package:warsha_commerce/features/catalog/domain/entities/category.dart';
import 'package:warsha_commerce/features/catalog/domain/entities/product.dart';

abstract class CatalogRepository {
  Future<Either<Failure, List<Category>>> getCategories();
  Future<Either<Failure, List<Product>>> getProducts({int? categoryId});
  Future<Either<Failure, Product>> getProductById(int id);

  /// Shelf query: Latest arrivals (highest IDs first, optionally filtered by category).
  Future<Either<Failure, List<Product>>> getNewArrivals({int? categoryId});

  /// Shelf query: Featured best selling accessories.
  Future<Either<Failure, List<Product>>> getBestSellers();
}
