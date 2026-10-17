class GovernorateModel {
  final String governorate;
  final double price;

  const GovernorateModel({
    required this.governorate,
    required this.price,
  });

  /// Delivery fee in minor units (piastres): e.g., 80.0 EGP -> 8000 piastres
  int get priceInMinor => (price * 100).round();

  factory GovernorateModel.fromJson(Map<String, dynamic> json) {
    return GovernorateModel(
      governorate: (json['governorate'] as String?)?.trim() ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() => {
    'governorate': governorate,
    'price': price,
  };
}
