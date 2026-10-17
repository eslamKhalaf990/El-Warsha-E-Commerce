import 'package:flutter/material.dart';

import 'package:warsha_commerce/core/theme/app_colors.dart';
import 'package:warsha_commerce/core/theme/app_radius.dart';
import 'package:warsha_commerce/core/theme/app_spacing.dart';
import 'package:warsha_commerce/core/widgets/app_container.dart';
import 'package:warsha_commerce/core/widgets/app_text.dart';

/// Pill-shaped chip built on top of [AppContainer] and [AppText].
class AppChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback? onTap;
  final Widget? icon;

  const AppChip({
    super.key,
    required this.label,
    this.isSelected = false,
    this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = isSelected ? AppColors.burgundy : AppColors.blush;
    final textColor = isSelected ? AppColors.white : AppColors.ink;
    final border = isSelected
        ? null
        : Border.all(color: AppColors.line, width: 1.0);

    return AppContainer(
      color: bgColor,
      border: border,
      radius: AppRadius.pill,
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: AppSpacing.s16,
        vertical: AppSpacing.s8,
      ),
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[icon!, const SizedBox(width: AppSpacing.s8)],
          AppText.bodySmall(
            label,
            color: textColor,
            weight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
        ],
      ),
    );
  }
}
