import 'package:dartz/dartz.dart';
import 'package:warsha_commerce/core/error/failures.dart';
import 'package:warsha_commerce/features/shipping/data/models/governorate_model.dart';
import 'package:warsha_commerce/features/shipping/domain/repositories/shipping_repository.dart';

class MockShippingRepository implements ShippingRepository {
  static const List<GovernorateModel> _mockGovernorates = [
    GovernorateModel(governorate: 'القاهرة', price: 80.0),
    GovernorateModel(governorate: 'الجيزة', price: 80.0),
    GovernorateModel(governorate: 'الإسكندرية', price: 90.0),
    GovernorateModel(governorate: 'القليوبية', price: 100.0),
    GovernorateModel(governorate: 'المنوفية', price: 100.0),
    GovernorateModel(governorate: 'الشرقية', price: 100.0),
    GovernorateModel(governorate: 'الغربية', price: 100.0),
    GovernorateModel(governorate: 'البحيرة', price: 100.0),
    GovernorateModel(governorate: 'الدقهلية', price: 100.0),
    GovernorateModel(governorate: 'كفر الشيخ', price: 100.0),
    GovernorateModel(governorate: 'الإسماعيلية', price: 100.0),
    GovernorateModel(governorate: 'السويس', price: 100.0),
    GovernorateModel(governorate: 'بورسعيد', price: 100.0),
    GovernorateModel(governorate: 'دمياط', price: 100.0),
    GovernorateModel(governorate: 'الفيوم', price: 110.0),
    GovernorateModel(governorate: 'بني سويف', price: 110.0),
    GovernorateModel(governorate: 'المنيا', price: 110.0),
    GovernorateModel(governorate: 'أسيوط', price: 120.0),
    GovernorateModel(governorate: 'سوهاج', price: 120.0),
    GovernorateModel(governorate: 'البحر الأحمر', price: 120.0),
    GovernorateModel(governorate: 'قنا', price: 120.0),
    GovernorateModel(governorate: 'الأقصر', price: 120.0),
    GovernorateModel(governorate: 'أسوان', price: 120.0),
    GovernorateModel(governorate: 'شمال سيناء', price: 130.0),
    GovernorateModel(governorate: 'جنوب سيناء', price: 130.0),
    GovernorateModel(governorate: 'مطروح', price: 130.0),
    GovernorateModel(governorate: 'الوادي الجديد', price: 130.0),
  ];

  @override
  List<GovernorateModel>? get cachedGovernorates => _mockGovernorates;

  @override
  Map<String, double>? get cachedGovernoratesMap => {
        for (final item in _mockGovernorates) item.governorate: item.price,
      };

  @override
  double? getCachedPrice(String governorate) {
    final match = _mockGovernorates.firstWhere(
      (g) => g.governorate == governorate,
      orElse: () => const GovernorateModel(governorate: '', price: 80.0),
    );
    return match.price;
  }

  @override
  Future<Either<Failure, List<GovernorateModel>>> getGovernorates() async {
    return const Right(_mockGovernorates);
  }

  @override
  Future<Either<Failure, Map<String, double>>> getGovernoratesMap() async {
    return Right({
      for (final item in _mockGovernorates) item.governorate: item.price,
    });
  }

  @override
  Future<Either<Failure, double>> getGovernoratePrice(String governorate) async {
    return Right(getCachedPrice(governorate) ?? 80.0);
  }
}
