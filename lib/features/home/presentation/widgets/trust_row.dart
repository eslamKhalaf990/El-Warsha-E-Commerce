import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import 'package:warsha_commerce/core/l10n/app_strings.dart';
import 'package:warsha_commerce/core/theme/app_colors.dart';
import 'package:warsha_commerce/core/theme/app_radius.dart';
import 'package:warsha_commerce/core/theme/app_spacing.dart';
import 'package:warsha_commerce/core/utils/breakpoints.dart';
import 'package:warsha_commerce/core/widgets/app_container.dart';
import 'package:warsha_commerce/core/widgets/app_text.dart';

class TrustRow extends StatelessWidget {
  const TrustRow({super.key});

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    final isDesktop = context.isDesktop;

    final trustItems = [
      (
        Iconsax.gift,
        strings.trustFreeWrappingTitle,
        strings.trustFreeWrappingDesc,
      ),
      (
        Iconsax.refresh_2,
        strings.trustEasyExchangeTitle,
        strings.trustEasyExchangeDesc,
      ),
      (
        Iconsax.lock,
        strings.trustSecureCheckoutTitle,
        strings.trustSecureCheckoutDesc,
      ),
    ];

    if (isDesktop) {
      return Row(
        children: trustItems.map((item) {
          return Expanded(
            child: Padding(
              padding: const EdgeInsetsDirectional.symmetric(
                horizontal: AppSpacing.s8,
              ),
              child: _buildItem(item.$1, item.$2, item.$3),
            ),
          );
        }).toList(),
      );
    }

    return Column(
      children: trustItems.map((item) {
        return Padding(
          padding: const EdgeInsetsDirectional.only(bottom: AppSpacing.s12),
          child: _buildItem(item.$1, item.$2, item.$3),
        );
      }).toList(),
    );
  }

  Widget _buildItem(IconData icon, String title, String subtitle) {
    return AppContainer.surface(
      padding: const EdgeInsetsDirectional.all(AppSpacing.s16),
      radius: AppRadius.card,
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.blush,
              borderRadius: BorderRadius.circular(AppRadius.pill),
            ),
            child: Icon(icon, color: AppColors.burgundy, size: 24),
          ),
          const SizedBox(width: AppSpacing.s16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                AppText.label(title, color: AppColors.deepWine),
                const SizedBox(height: AppSpacing.s4),
                AppText.bodySmall(
                  subtitle,
                  color: AppColors.muted,
                  maxLines: 2,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
