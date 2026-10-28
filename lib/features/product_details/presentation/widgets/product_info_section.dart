import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

import 'package:warsha_commerce/core/l10n/product_text.dart';
import 'package:warsha_commerce/core/l10n/app_strings.dart';
import 'package:warsha_commerce/core/theme/app_colors.dart';
import 'package:warsha_commerce/core/theme/app_radius.dart';
import 'package:warsha_commerce/core/theme/app_spacing.dart';
import 'package:warsha_commerce/core/utils/money.dart';
import 'package:warsha_commerce/core/widgets/app_container.dart';
import 'package:warsha_commerce/core/widgets/app_text.dart';
import 'package:warsha_commerce/core/widgets/status_pill.dart';
import 'package:warsha_commerce/features/catalog/domain/entities/product.dart';

class ProductInfoSection extends StatelessWidget {
  final Product product;

  const ProductInfoSection({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final bool hasLowStock = product.quantity > 0 && product.quantity <= 5;
    final bool isOutOfStock = product.isOutOfStock;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Category chip & SKU tag
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppContainer(
              radius: AppRadius.pill,
              color: AppColors.blush,
              padding: const EdgeInsetsDirectional.symmetric(
                horizontal: AppSpacing.s12,
                vertical: AppSpacing.s4,
              ),
              child: AppText.caption(
                product.categoryName,
                color: AppColors.burgundy,
                weight: FontWeight.w700,
              ),
            ),
            AppText.caption(
              '${AppStrings.sku}: ${product.sku}',
              color: AppColors.muted,
              weight: FontWeight.w500,
            ),
          ],
        ),

        const SizedBox(height: AppSpacing.s12),

        // Product Name
        Text(
          product.localizedName(context),
          style: GoogleFonts.cairo(
            fontSize: 26,
            fontWeight: FontWeight.w800,
            color: AppColors.deepWine,
            height: 1.3,
          ),
        ),

        const SizedBox(height: AppSpacing.s16),

        // Pricing Block
        AppContainer.surface(
          padding: const EdgeInsetsDirectional.all(AppSpacing.s16),
          radius: AppRadius.card,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: AppSpacing.s12,
                  runSpacing: AppSpacing.s4,
                  children: [
                    Text(
                      MoneyUtils.formatMinor(product.totalPrice),
                      style: GoogleFonts.cairo(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: AppColors.burgundy,
                      ),
                    ),
                    if (product.hasDiscount) ...[
                      Text(
                        MoneyUtils.formatMinor(product.sellingPrice),
                        style: GoogleFonts.cairo(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.lineThrough,
                          color: AppColors.muted,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsetsDirectional.symmetric(
                          horizontal: AppSpacing.s8,
                          vertical: AppSpacing.s4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.champagne,
                          borderRadius: BorderRadius.circular(AppRadius.pill),
                        ),
                        child: AppText.caption(
                          AppStrings.saveAmount(
                            MoneyUtils.formatMinor(product.discount),
                          ),
                          color: AppColors.ink,
                          weight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              // Stock Urgency Badge
              if (isOutOfStock)
                const StatusPill.neutral(label: AppStrings.outOfStock)
              else if (hasLowStock)
                Container(
                  padding: const EdgeInsetsDirectional.symmetric(
                    horizontal: AppSpacing.s8,
                    vertical: AppSpacing.s4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.blush,
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                    border: Border.all(
                      color: AppColors.burgundy.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Iconsax.timer_1,
                        size: 14,
                        color: AppColors.burgundy,
                      ),
                      const SizedBox(width: AppSpacing.s4),
                      AppText.caption(
                        AppStrings.lowStock(product.quantity),
                        color: AppColors.burgundy,
                        weight: FontWeight.w700,
                      ),
                    ],
                  ),
                )
              else
                Container(
                  padding: const EdgeInsetsDirectional.symmetric(
                    horizontal: AppSpacing.s8,
                    vertical: AppSpacing.s4,
                  ),
                  decoration: BoxDecoration(
                    color: AppStatusColors.successBackground,
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Iconsax.tick_circle,
                        size: 14,
                        color: AppStatusColors.successText,
                      ),
                      SizedBox(width: AppSpacing.s4),
                      AppText.caption(
                        AppStrings.inStock,
                        color: AppStatusColors.successText,
                        weight: FontWeight.w600,
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),

        const SizedBox(height: AppSpacing.s16),

        // Short Description Paragraph
        AppText.body(
          product.localizedDescription(context),
          color: AppColors.deepWine.withValues(alpha: 0.85),
        ),
      ],
    );
  }
}
