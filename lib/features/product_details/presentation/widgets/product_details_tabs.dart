import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import 'package:warsha_commerce/core/l10n/app_strings.dart';
import 'package:warsha_commerce/core/theme/app_colors.dart';
import 'package:warsha_commerce/core/theme/app_radius.dart';
import 'package:warsha_commerce/core/theme/app_spacing.dart';
import 'package:warsha_commerce/core/widgets/app_container.dart';
import 'package:warsha_commerce/core/widgets/app_text.dart';
import 'package:warsha_commerce/features/catalog/domain/entities/product.dart';
import 'package:warsha_commerce/features/feedback/presentation/widgets/product_reviews_tab_content.dart';

class ProductDetailsTabs extends StatefulWidget {
  final Product product;

  const ProductDetailsTabs({super.key, required this.product});

  @override
  State<ProductDetailsTabs> createState() => _ProductDetailsTabsState();
}

class _ProductDetailsTabsState extends State<ProductDetailsTabs> {
  int _activeTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return AppContainer.surface(
      padding: const EdgeInsetsDirectional.all(AppSpacing.s16),
      radius: AppRadius.card,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tab selection buttons
          Wrap(
            spacing: AppSpacing.s8,
            runSpacing: AppSpacing.s8,
            children: [
              _buildTabButton(0, AppStrings.description, Iconsax.document_text),
              _buildTabButton(
                1,
                AppStrings.specifications,
                Iconsax.info_circle,
              ),
              _buildTabButton(2, AppStrings.careTips, Iconsax.magicpen),
              _buildTabButton(3, 'التقييمات والآراء', Iconsax.star_1),
            ],
          ),

          const SizedBox(height: AppSpacing.s16),
          const Divider(color: AppColors.line, height: 1),
          const SizedBox(height: AppSpacing.s16),

          // Tab content
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: _buildContent(product),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(int index, String title, IconData icon) {
    final isSelected = _activeTabIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _activeTabIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsetsDirectional.symmetric(
          horizontal: AppSpacing.s16,
          vertical: AppSpacing.s8,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.burgundy : AppColors.white,
          borderRadius: BorderRadius.circular(AppRadius.pill),
          border: Border.all(
            color: isSelected ? AppColors.burgundy : AppColors.line,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? AppColors.white : AppColors.muted,
            ),
            const SizedBox(width: AppSpacing.s8),
            AppText.body(
              title,
              color: isSelected ? AppColors.white : AppColors.deepWine,
              weight: isSelected ? FontWeight.w700 : FontWeight.w500,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(Product product) {
    switch (_activeTabIndex) {
      case 0:
        return KeyedSubtree(
          key: const ValueKey(0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText.body(
                product.description,
                color: AppColors.deepWine.withValues(alpha: 0.9),
              ),
              const SizedBox(height: AppSpacing.s12),
              const AppText.caption(
                'تم تصميم هذه القطعة بعناية فائقة لتجمع بين أناقة التراث واللمسة العصرية الحديثة، مما يجعلها الاختيار المثالي لإطلالتك اليومية ومناسباتك الخاصة.',
                color: AppColors.muted,
              ),
            ],
          ),
        );
      case 1:
        return KeyedSubtree(
          key: const ValueKey(1),
          child: Column(
            children: [
              _buildSpecRow(AppStrings.category, product.categoryName),
              const Divider(color: AppColors.line, height: AppSpacing.s16),
              _buildSpecRow(AppStrings.sku, product.sku),
              const Divider(color: AppColors.line, height: AppSpacing.s16),
              _buildSpecRow('الخامة والطلاء', AppStrings.materialValue),
              const Divider(color: AppColors.line, height: AppSpacing.s16),
              _buildSpecRow(
                'التغليف',
                'علبة الورشة الفاخرة مبطنة بالمخمل البورجوندي',
              ),
            ],
          ),
        );
      case 2:
        return KeyedSubtree(
          key: const ValueKey(2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText.body(
                AppStrings.careTipsValue,
                color: AppColors.deepWine.withValues(alpha: 0.9),
              ),
              const SizedBox(height: AppSpacing.s12),
              _buildCareBullet(
                'امسحي القطعة بقطعة قماش ناعمة وجافة بعد الاستخدام.',
              ),
              const SizedBox(height: AppSpacing.s8),
              _buildCareBullet(
                'احفظي كل قطعة بمفردها داخل العلبة لتجنب الاحتكاك أو الخدوش.',
              ),
              const SizedBox(height: AppSpacing.s8),
              _buildCareBullet(
                'ارتدي الإكسسوار بعد الانتهاء تمامًا من وضع العطور ومستحضرات التجميل.',
              ),
            ],
          ),
        );
      case 3:
      default:
        return KeyedSubtree(
          key: const ValueKey(3),
          child: ProductReviewsTabContent(product: product),
        );
    }
  }

  Widget _buildSpecRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: AppText.body(
            label,
            color: AppColors.muted,
            weight: FontWeight.w600,
          ),
        ),
        const SizedBox(width: AppSpacing.s12),
        Expanded(
          child: AppText.body(
            value,
            color: AppColors.deepWine,
            weight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildCareBullet(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsetsDirectional.only(top: 4, end: 8),
          child: Icon(
            Iconsax.tick_circle5,
            size: 14,
            color: AppColors.burgundy,
          ),
        ),
        Expanded(
          child: AppText.caption(
            text,
            color: AppColors.deepWine.withValues(alpha: 0.85),
          ),
        ),
      ],
    );
  }
}
