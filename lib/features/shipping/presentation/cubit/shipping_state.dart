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

  bool get isLoading => status == ShippingStatus.loading && governorates.isEmpty;
  bool get isSuccess => status == ShippingStatus.success || governorates.isNotEmpty;

  List<String> get governorateNames =>
      governorates.map((g) => g.governorate).toList();

  double getPriceFor(String governorateName) {
    if (governoratesMap.containsKey(governorateName)) {
      return governoratesMap[governorateName]!;
    }
    // Fallback search
    final match = governorates.firstWhere(
      (g) => g.governorate == governorateName,
      orElse: () => const GovernorateModel(governorate: '', price: 80.0),
    );
    return match.price;
  }

  int getMinorPriceFor(String governorateName) {
    return (getPriceFor(governorateName) * 100).round();
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
