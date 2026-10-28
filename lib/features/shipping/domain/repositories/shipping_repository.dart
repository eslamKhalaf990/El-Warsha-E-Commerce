import 'package:dartz/dartz.dart';
import 'package:warsha_commerce/core/error/failures.dart';
import 'package:warsha_commerce/features/shipping/data/models/governorate_model.dart';

abstract class ShippingRepository {
  Future<Either<Failure, List<GovernorateModel>>> getGovernorates();

  /// Drops the cached prices and loads them again, so changes made in the ERP show up.
  Future<Either<Failure, List<GovernorateModel>>> refreshGovernorates();
  Future<Either<Failure, Map<String, double>>> getGovernoratesMap();
  Future<Either<Failure, double>> getGovernoratePrice(String governorate);

  List<GovernorateModel>? get cachedGovernorates;
  Map<String, double>? get cachedGovernoratesMap;
  double? getCachedPrice(String governorate);
}
