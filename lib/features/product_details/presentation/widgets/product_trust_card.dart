import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import 'package:warsha_commerce/core/l10n/app_strings.dart';
import 'package:warsha_commerce/core/theme/app_colors.dart';
import 'package:warsha_commerce/core/theme/app_radius.dart';
import 'package:warsha_commerce/core/theme/app_spacing.dart';
import 'package:warsha_commerce/core/widgets/app_container.dart';
import 'package:warsha_commerce/core/widgets/app_text.dart';

class ProductTrustCard extends StatelessWidget {
  const ProductTrustCard({super.key});

  @override
  Widget build(BuildContext context) {
    return AppContainer.surface(
      padding: const EdgeInsetsDirectional.all(AppSpacing.s16),
      radius: AppRadius.card,
      child: Column(
        children: [
          _buildItem(
            icon: Iconsax.gift,
            title: AppStrings.trustFreeWrappingTitle,
            subtitle: AppStrings.trustFreeWrappingDesc,
          ),
          const Divider(color: AppColors.line, height: AppSpacing.s24),
          _buildItem(
            icon: Iconsax.box_tick,
            title: AppStrings.trustEasyExchangeTitle,
            subtitle: AppStrings.trustEasyExchangeDesc,
          ),
          const Divider(color: AppColors.line, height: AppSpacing.s24),
          _buildItem(
            icon: Iconsax.shield_tick,
            title: AppStrings.trustSecureCheckoutTitle,
            subtitle: AppStrings.trustSecureCheckoutDesc,
          ),
        ],
      ),
    );
  }

  Widget _buildItem({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: AppColors.blush,
            borderRadius: BorderRadius.circular(AppRadius.small),
          ),
          child: Icon(icon, size: 18, color: AppColors.burgundy),
        ),
        const SizedBox(width: AppSpacing.s12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText.titleSmall(
                title,
                weight: FontWeight.w700,
                color: AppColors.deepWine,
              ),
              const SizedBox(height: 4),
              AppText.caption(subtitle, color: AppColors.muted),
            ],
          ),
        ),
      ],
    );
  }
}
