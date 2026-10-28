import 'package:flutter/widgets.dart';
import 'package:warsha_commerce/features/catalog/domain/entities/product.dart';
import 'package:warsha_commerce/features/catalog/domain/entities/product_variant.dart';

/// Product text in the app's current language (Arabic when available).
extension ProductText on Product {
  String localizedName(BuildContext context) =>
      nameFor(Localizations.localeOf(context).languageCode);

  String localizedDescription(BuildContext context) =>
      descriptionFor(Localizations.localeOf(context).languageCode);
}

extension ProductVariantText on ProductVariant {
  String localizedLabel(BuildContext context) =>
      labelFor(Localizations.localeOf(context).languageCode);
}
