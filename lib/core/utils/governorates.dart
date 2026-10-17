import 'package:warsha_commerce/core/di/di.dart';
import 'package:warsha_commerce/features/shipping/domain/repositories/shipping_repository.dart';

class Governorates {
  /// Returns cached governorate list names dynamically from backend API, or fallback list
  static List<String> get all {
    if (sl.isRegistered<ShippingRepository>()) {
      final cached = sl<ShippingRepository>().cachedGovernorates;
      if (cached != null && cached.isNotEmpty) {
        return cached.map((g) => g.governorate).toList();
      }
    }
    return const [
      'القاهرة',
      'الجيزة',
      'الإسكندرية',
      'القليوبية',
      'المنوفية',
      'الشرقية',
      'الغربية',
      'البحيرة',
      'الدقهلية',
      'كفر الشيخ',
      'الإسماعيلية',
      'السويس',
      'بورسعيد',
      'دمياط',
      'الفيوم',
      'بني سويف',
      'المنيا',
      'أسيوط',
      'سوهاج',
      'البحر الأحمر',
      'قنا',
      'الأقصر',
      'أسوان',
      'شمال سيناء',
      'جنوب سيناء',
      'مطروح',
      'الوادي الجديد',
    ];
  }

  /// Dynamic helper to retrieve price in EGP major units for a given governorate
  static double getPrice(String governorate) {
    if (sl.isRegistered<ShippingRepository>()) {
      final cachedPrice = sl<ShippingRepository>().getCachedPrice(governorate);
      if (cachedPrice != null) {
        return cachedPrice;
      }
    }
    return 80.0;
  }
}
