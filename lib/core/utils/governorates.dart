import 'package:warsha_commerce/core/di/di.dart';
import 'package:warsha_commerce/features/shipping/domain/repositories/shipping_repository.dart';

/// Governorates and delivery prices, read from the price list the backend serves
/// (edited in the ERP's Shipping Zones). Nothing here is hardcoded.
class Governorates {
  /// Governorates the store delivers to; empty until the price list has loaded.
  static List<String> get all {
    if (sl.isRegistered<ShippingRepository>()) {
      final cached = sl<ShippingRepository>().cachedGovernorates;
      if (cached != null) return cached.map((g) => g.governorate).toList();
    }
    return const [];
  }

  /// Delivery price in EGP, or null when the governorate isn't delivered to
  /// (or the price list hasn't loaded).
  static double? getPrice(String governorate) {
    if (!sl.isRegistered<ShippingRepository>()) return null;
    return sl<ShippingRepository>().getCachedPrice(governorate);
  }
}

/// Matching key for Arabic governorate names (same rules as the backend), so
/// "الاسكندريه" and "الإسكندرية" are the same place.
String governorateKey(String name) {
  final s = name
      .trim()
      .replaceAll(RegExp('[ً-ٟـ]'), '')
      .replaceAll(RegExp('[أإآ]'), 'ا')
      .replaceAll('ة', 'ه')
      .replaceAll('ى', 'ي')
      .replaceAll(RegExp(r'\s+'), ' ');
  return s.startsWith('ال') ? s.substring(2) : s;
}
