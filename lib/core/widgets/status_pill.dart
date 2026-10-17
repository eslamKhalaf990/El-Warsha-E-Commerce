import 'package:flutter/material.dart';

import 'package:warsha_commerce/core/theme/app_colors.dart';
import 'package:warsha_commerce/core/theme/app_radius.dart';
import 'package:warsha_commerce/core/theme/app_spacing.dart';
import 'package:warsha_commerce/core/widgets/app_container.dart';
import 'package:warsha_commerce/core/widgets/app_text.dart';
import 'package:warsha_commerce/features/orders/domain/entities/order_status.dart';

/// Pill widget displaying order or general status, built on top of [AppContainer] and [AppText].
class StatusPill extends StatelessWidget {
  final String label;
  final Color textColor;
  final Color backgroundColor;

  const StatusPill({
    super.key,
    required this.label,
    required this.textColor,
    required this.backgroundColor,
  });

  /// Factory constructor taking an [OrderStatus] and optional locale.
  factory StatusPill.fromStatus(
    OrderStatus status, {
    Key? key,
    Locale locale = const Locale('en'),
  }) {
    return StatusPill(
      key: key,
      label: status.label(locale),
      textColor: status.textColor,
      backgroundColor: status.backgroundColor,
    );
  }

  /// In-progress status pill
  const StatusPill.inProgress({super.key, required this.label})
    : textColor = AppStatusColors.inProgressText,
      backgroundColor = AppStatusColors.inProgressBackground;

  /// Success status pill
  const StatusPill.success({super.key, required this.label})
    : textColor = AppStatusColors.successText,
      backgroundColor = AppStatusColors.successBackground;

  /// Neutral status pill
  const StatusPill.neutral({super.key, required this.label})
    : textColor = AppStatusColors.neutralText,
      backgroundColor = AppStatusColors.neutralBackground;

  /// Error status pill
  const StatusPill.error({super.key, required this.label})
    : textColor = AppStatusColors.errorText,
      backgroundColor = AppStatusColors.errorBackground;

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      color: backgroundColor,
      radius: AppRadius.pill,
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: AppSpacing.s12,
        vertical: AppSpacing.s4,
      ),
      child: AppText.caption(label, color: textColor, weight: FontWeight.w600),
    );
  }
}
