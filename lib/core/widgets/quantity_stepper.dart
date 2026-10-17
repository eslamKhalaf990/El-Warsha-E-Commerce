import 'package:flutter/material.dart';

import 'package:warsha_commerce/core/theme/app_colors.dart';
import 'package:warsha_commerce/core/theme/app_radius.dart';
import 'package:warsha_commerce/core/theme/app_spacing.dart';
import 'package:warsha_commerce/core/widgets/app_container.dart';
import 'package:warsha_commerce/core/widgets/app_text.dart';

/// Stepper widget for incrementing / decrementing item quantity.
/// Built strictly with [AppContainer] and [AppText].
class QuantityStepper extends StatelessWidget {
  final int quantity;
  final int minQuantity;
  final int maxQuantity;
  final ValueChanged<int>? onChanged;

  const QuantityStepper({
    super.key,
    required this.quantity,
    this.minQuantity = 1,
    this.maxQuantity = 99,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final canDecrement = onChanged != null && quantity > minQuantity;
    final canIncrement = onChanged != null && quantity < maxQuantity;

    return AppContainer.surface(
      radius: AppRadius.pill,
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: AppSpacing.s4,
        vertical: AppSpacing.s4,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Decrement button
          AppContainer(
            width: 32,
            height: 32,
            radius: AppRadius.pill,
            color: canDecrement ? AppColors.blush : AppColors.transparent,
            padding: EdgeInsetsDirectional.zero,
            onTap: canDecrement ? () => onChanged?.call(quantity - 1) : null,
            child: Center(
              child: AppText.titleSmall(
                '−',
                color: canDecrement ? AppColors.deepWine : AppColors.muted,
                weight: FontWeight.w600,
              ),
            ),
          ),

          // Quantity display
          Container(
            constraints: const BoxConstraints(minWidth: 36),
            padding: const EdgeInsetsDirectional.symmetric(
              horizontal: AppSpacing.s8,
            ),
            alignment: Alignment.center,
            child: AppText.titleSmall(
              '$quantity',
              weight: FontWeight.w600,
              color: AppColors.ink,
            ),
          ),

          // Increment button
          AppContainer(
            width: 32,
            height: 32,
            radius: AppRadius.pill,
            color: canIncrement ? AppColors.blush : AppColors.transparent,
            padding: EdgeInsetsDirectional.zero,
            onTap: canIncrement ? () => onChanged?.call(quantity + 1) : null,
            child: Center(
              child: AppText.titleSmall(
                '+',
                color: canIncrement ? AppColors.deepWine : AppColors.muted,
                weight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
