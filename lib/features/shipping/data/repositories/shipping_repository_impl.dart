import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:warsha_commerce/core/error/failures.dart';
import 'package:warsha_commerce/core/utils/governorates.dart';
import 'package:warsha_commerce/features/shipping/data/datasources/shipping_remote_datasource.dart';
import 'package:warsha_commerce/features/shipping/data/models/governorate_model.dart';
import 'package:warsha_commerce/features/shipping/domain/repositories/shipping_repository.dart';

class ShippingRepositoryImpl implements ShippingRepository {
  final ShippingRemoteDataSource remoteDataSource;

  List<GovernorateModel>? _cachedGovernorates;
  Map<String, double>? _cachedMap;

  ShippingRepositoryImpl({required this.remoteDataSource});

  @override
  List<GovernorateModel>? get cachedGovernorates => _cachedGovernorates;

  @override
  Map<String, double>? get cachedGovernoratesMap => _cachedMap;

  @override
  double? getCachedPrice(String governorate) {
    if (_cachedMap == null) return null;
    if (_cachedMap!.containsKey(governorate)) {
      return _cachedMap![governorate];
    }
    // Arabic normalization fallback lookup
    final normalizedSearch = governorateKey(governorate);
    for (final entry in _cachedMap!.entries) {
      if (governorateKey(entry.key) == normalizedSearch) {
        return entry.value;
      }
    }
    return null;
  }

  @override
  Future<Either<Failure, List<GovernorateModel>>> getGovernorates() async {
    if (_cachedGovernorates != null && _cachedGovernorates!.isNotEmpty) {
      return Right(_cachedGovernorates!);
    }

    try {
      final list = await remoteDataSource.getGovernorates();
      _cachedGovernorates = List.unmodifiable(list);
      _cachedMap = Map.unmodifiable({
        for (final item in list) item.governorate: item.price,
      });
      return Right(_cachedGovernorates!);
    } on DioException catch (e) {
      return Left(_mapDioException(e));
    } catch (e) {
      return Left(ServerFailure('فشل استرجاع قائمة المحافظات: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<GovernorateModel>>> refreshGovernorates() async {
    final previousList = _cachedGovernorates;
    final previousMap = _cachedMap;
    _cachedGovernorates = null;
    _cachedMap = null;
    final result = await getGovernorates();
    if (result.isLeft()) {
      // Keep showing the last known prices if the refresh fails
      _cachedGovernorates = previousList;
      _cachedMap = previousMap;
    }
    return result;
  }

  @override
  Future<Either<Failure, Map<String, double>>> getGovernoratesMap() async {
    if (_cachedMap != null && _cachedMap!.isNotEmpty) {
      return Right(_cachedMap!);
    }

    try {
      final map = await remoteDataSource.getGovernoratesMap();
      _cachedMap = Map.unmodifiable(map);
      _cachedGovernorates = List.unmodifiable(
        map.entries.map((e) => GovernorateModel(governorate: e.key, price: e.value)),
      );
      return Right(_cachedMap!);
    } on DioException catch (e) {
      return Left(_mapDioException(e));
    } catch (e) {
      return Left(ServerFailure('فشل استرجاع أسعار التوصيل: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, double>> getGovernoratePrice(String governorate) async {
    final cached = getCachedPrice(governorate);
    if (cached != null) {
      return Right(cached);
    }

    try {
      final item = await remoteDataSource.getGovernoratePrice(governorate);
      // Update cache
      if (_cachedMap != null) {
        final mutableMap = Map<String, double>.from(_cachedMap!);
        mutableMap[item.governorate] = item.price;
        _cachedMap = Map.unmodifiable(mutableMap);
      }
      return Right(item.price);
    } on DioException catch (e) {
      return Left(_mapDioException(e));
    } catch (e) {
      return Left(ServerFailure('فشل استرجاع سعر التوصيل للمحافظة: ${e.toString()}'));
    }
  }

  Failure _mapDioException(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout ||
        e.type == DioExceptionType.connectionError) {
      return const NetworkFailure();
    }
    final data = e.response?.data;
    if (data is Map && data.containsKey('error')) {
      return ServerFailure(data['error'].toString());
    }
    return ServerFailure(e.message ?? 'حدث خطأ في الاتصال بقائمة أسعار الشحن');
  }
}
