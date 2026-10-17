import 'package:flutter/material.dart';
import 'package:warsha_commerce/core/theme/app_colors.dart';

enum OrderStatus {
  placed,
  confirmed,
  packed,
  shipped,
  delivered,
  cancelled;

  /// Human-readable label (English)
  String get labelEn => switch (this) {
    OrderStatus.placed => 'Placed',
    OrderStatus.confirmed => 'Confirmed',
    OrderStatus.packed => 'Packed',
    OrderStatus.shipped => 'Shipped',
    OrderStatus.delivered => 'Delivered',
    OrderStatus.cancelled => 'Cancelled',
  };

  /// Human-readable label (Arabic)
  String get labelAr => switch (this) {
    OrderStatus.placed => 'تم الطلب',
    OrderStatus.confirmed => 'تم التأكيد',
    OrderStatus.packed => 'تم التجهيز',
    OrderStatus.shipped => 'تم الشحن',
    OrderStatus.delivered => 'تم التوصيل',
    OrderStatus.cancelled => 'ملغي',
  };

  String label(Locale locale) =>
      locale.languageCode == 'ar' ? labelAr : labelEn;

  /// Background color for status pill
  Color get backgroundColor => switch (this) {
    OrderStatus.placed ||
    OrderStatus.confirmed ||
    OrderStatus.packed ||
    OrderStatus.shipped => AppStatusColors.inProgressBackground,
    OrderStatus.delivered => AppStatusColors.successBackground,
    OrderStatus.cancelled => AppStatusColors.neutralBackground,
  };

  /// Foreground text color for status pill
  Color get textColor => switch (this) {
    OrderStatus.placed ||
    OrderStatus.confirmed ||
    OrderStatus.packed ||
    OrderStatus.shipped => AppStatusColors.inProgressText,
    OrderStatus.delivered => AppStatusColors.successText,
    OrderStatus.cancelled => AppStatusColors.neutralText,
  };

  /// Single place to map backend API status strings to the enum.
  /// To be updated when backend establishes exact status strings.
  static OrderStatus fromBackendString(String value) {
    return switch (value.trim().toLowerCase()) {
      'placed' || 'pending' || 'جديد' => OrderStatus.placed,
      'confirmed' || 'مؤكد' => OrderStatus.confirmed,
      'packed' || 'جاهز' => OrderStatus.packed,
      'shipped' ||
      'out_for_delivery' ||
      'تم الشحن' ||
      'في الطريق' => OrderStatus.shipped,
      'delivered' ||
      'completed' ||
      'تم التوصيل' ||
      'مكتمل' => OrderStatus.delivered,
      'cancelled' || 'canceled' || 'ملغي' => OrderStatus.cancelled,
      _ => OrderStatus.placed,
    };
  }

  /// Maps the enum to backend API string format.
  String toBackendString() => name.toUpperCase();
}
