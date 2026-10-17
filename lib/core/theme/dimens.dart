import 'package:warsha_commerce/core/theme/app_radius.dart';
import 'package:warsha_commerce/core/theme/app_spacing.dart';

abstract final class Dimens {
  // Padding & Margins
  static const double p4 = AppSpacing.s4;
  static const double p8 = AppSpacing.s8;
  static const double p12 = AppSpacing.s12;
  static const double p16 = AppSpacing.s16;
  static const double p24 = AppSpacing.s24;
  static const double p32 = AppSpacing.s32;
  static const double p48 = AppSpacing.s48;
  static const double p64 = 64.0;

  // Border Radius
  static const double radiusSmall = AppRadius.small;
  static const double radiusInput = AppRadius.input;
  static const double radiusCard = AppRadius.card;
  static const double radiusPill = AppRadius.pill;

  static const double radius4 = 4.0;
  static const double radius8 = AppRadius.input;
  static const double radius12 = AppRadius.card;
  static const double radius16 = 16.0;

  // Icon Sizes
  static const double iconSmall = 16.0;
  static const double iconMedium = 24.0;
  static const double iconLarge = 32.0;
}
