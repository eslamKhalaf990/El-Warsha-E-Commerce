import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:warsha_commerce/core/localization/app_strings.dart';
import 'package:warsha_commerce/core/theme/app_colors.dart';
import 'package:warsha_commerce/core/theme/app_radius.dart';
import 'package:warsha_commerce/core/theme/app_spacing.dart';
import 'package:warsha_commerce/core/utils/breakpoints.dart';
import 'package:warsha_commerce/core/widgets/app_button.dart';
import 'package:warsha_commerce/core/widgets/app_container.dart';
import 'package:warsha_commerce/core/widgets/app_text.dart';

class GiftEditPromoBand extends StatelessWidget {
  const GiftEditPromoBand({super.key});

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    final isDesktop = context.isDesktop;

    return AppContainer.blush(
      padding: EdgeInsetsDirectional.all(
        isDesktop ? AppSpacing.s48 : AppSpacing.s24,
      ),
      radius: AppRadius.card,
      child: isDesktop
          ? Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildEyebrow(strings.giftEditEyebrow),
                      const SizedBox(height: AppSpacing.s8),
                      AppText.display(
                        strings.giftEditTitle,
                        color: AppColors.deepWine,
                      ),
                      const SizedBox(height: AppSpacing.s8),
                      AppText.body(
                        strings.giftEditSubtitle,
                        color: AppColors.ink,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.s32),
                AppButton.primary(
                  label: strings.giftEditCta,
                  onPressed: () => context.push('/shop?gift=true'),
                ),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildEyebrow(strings.giftEditEyebrow),
                const SizedBox(height: AppSpacing.s8),
                AppText.headline(
                  strings.giftEditTitle,
                  color: AppColors.deepWine,
                ),
                const SizedBox(height: AppSpacing.s8),
                AppText.bodySmall(
                  strings.giftEditSubtitle,
                  color: AppColors.ink,
                ),
                const SizedBox(height: AppSpacing.s24),
                AppButton.primary(
                  label: strings.giftEditCta,
                  width: double.infinity,
                  onPressed: () => context.push('/shop?gift=true'),
                ),
              ],
            ),
    );
  }

  Widget _buildEyebrow(String text) {
    return Container(
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: AppSpacing.s8,
        vertical: AppSpacing.s4,
      ),
      decoration: BoxDecoration(
        color: AppColors.champagne,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: AppText.caption(
        text,
        color: AppColors.deepWine,
        weight: FontWeight.w700,
      ),
    );
  }
}
