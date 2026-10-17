import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

import 'package:warsha_commerce/core/l10n/app_strings.dart';
import 'package:warsha_commerce/core/theme/app_colors.dart';
import 'package:warsha_commerce/core/theme/app_radius.dart';
import 'package:warsha_commerce/core/theme/app_spacing.dart';
import 'package:warsha_commerce/core/widgets/app_button.dart';
import 'package:warsha_commerce/core/widgets/app_container.dart';
import 'package:warsha_commerce/core/widgets/app_text.dart';

class CartEmptyView extends StatelessWidget {
  const CartEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: AppContainer.surface(
          radius: AppRadius.card,
          padding: const EdgeInsetsDirectional.all(36.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Bag Icon Badge
              Container(
                width: 90,
                height: 90,
                decoration: const BoxDecoration(
                  color: AppColors.blush,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(
                    Iconsax.shopping_bag,
                    size: 46,
                    color: AppColors.burgundy,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.s24),

              // Title (Empty cart | سلتك فاضية.. يلا نملاها حاجات حلوة؟)
              AppText.headline(
                strings.cartEmptyTitle,
                color: AppColors.deepWine,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.s12),

              // Subtitle
              AppText.body(
                strings.cartEmptySubtitle,
                color: AppColors.muted,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.s32),

              // Action CTA
              AppButton.primary(
                label: strings.continueShopping,
                height: 48,
                icon: const Icon(
                  Iconsax.shop,
                  size: 20,
                  color: AppColors.white,
                ),
                onPressed: () => context.go('/'),
              ),
              const SizedBox(height: AppSpacing.s32),

              // Quick Trust Badges
              Wrap(
                alignment: WrapAlignment.center,
                spacing: AppSpacing.s16,
                runSpacing: AppSpacing.s8,
                children: [
                  _buildMiniBadge(Iconsax.magic_star, 'صياغة يدوية بدقة'),
                  _buildMiniBadge(Iconsax.truck_fast, AppStrings.deliveryNote),
                  _buildMiniBadge(
                    Iconsax.verify,
                    AppStrings.trustEasyExchangeTitle,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMiniBadge(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: AppColors.champagne),
        const SizedBox(width: AppSpacing.s4),
        Text(
          text,
          style: GoogleFonts.cairo(
            fontSize: 11,
            color: AppColors.muted,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
