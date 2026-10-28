import 'package:warsha_commerce/core/utils/governorates.dart';
import 'package:warsha_commerce/features/shipping/data/models/governorate_model.dart';

enum ShippingStatus { initial, loading, success, failure }

class ShippingState {
  final ShippingStatus status;
  final List<GovernorateModel> governorates;
  final Map<String, double> governoratesMap;
  final String? errorMessage;

  const ShippingState({
    this.status = ShippingStatus.initial,
    this.governorates = const [],
    this.governoratesMap = const {},
    this.errorMessage,
  });

  bool get isLoading =>
      status == ShippingStatus.loading && governorates.isEmpty;
  bool get isSuccess =>
      status == ShippingStatus.success || governorates.isNotEmpty;

  List<String> get governorateNames =>
      governorates.map((g) => g.governorate).toList();

  /// Delivery price in EGP, or null when the governorate isn't in the price list.
  double? getPriceFor(String governorateName) {
    final exact = governoratesMap[governorateName];
    if (exact != null) return exact;
    final key = governorateKey(governorateName);
    for (final g in governorates) {
      if (governorateKey(g.governorate) == key) return g.price;
    }
    return null;
  }

  int? getMinorPriceFor(String governorateName) {
    final price = getPriceFor(governorateName);
    return price == null ? null : (price * 100).round();
  }

  ShippingState copyWith({
    ShippingStatus? status,
    List<GovernorateModel>? governorates,
    Map<String, double>? governoratesMap,
    String? errorMessage,
  }) {
    return ShippingState(
      status: status ?? this.status,
      governorates: governorates ?? this.governorates,
      governoratesMap: governoratesMap ?? this.governoratesMap,
      errorMessage: errorMessage,
    );
  }
}
