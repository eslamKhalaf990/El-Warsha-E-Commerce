import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import 'package:warsha_commerce/core/l10n/app_strings.dart';
import 'package:warsha_commerce/core/theme/app_colors.dart';
import 'package:warsha_commerce/core/theme/app_radius.dart';
import 'package:warsha_commerce/core/theme/app_spacing.dart';
import 'package:warsha_commerce/core/utils/breakpoints.dart';
import 'package:warsha_commerce/core/widgets/app_container.dart';
import 'package:warsha_commerce/core/widgets/app_text.dart';
import 'package:warsha_commerce/features/catalog/domain/entities/product.dart';
import 'package:warsha_commerce/features/home/presentation/widgets/product_card.dart';

class RelatedProductsSection extends StatefulWidget {
  final List<Product> products;

  const RelatedProductsSection({super.key, required this.products});

  @override
  State<RelatedProductsSection> createState() => _RelatedProductsSectionState();
}

class _RelatedProductsSectionState extends State<RelatedProductsSection> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scroll(double offset) {
    if (!_scrollController.hasClients) return;
    _scrollController.animateTo(
      (_scrollController.offset + offset).clamp(
        0.0,
        _scrollController.position.maxScrollExtent,
      ),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.products.isEmpty) {
      return const SizedBox.shrink();
    }

    final isDesktop = context.isDesktop;
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText.headline(
                  AppStrings.relatedProducts,
                  color: AppColors.deepWine,
                ),
                SizedBox(height: AppSpacing.s4),
                AppText.caption(
                  AppStrings.relatedProductsSubtitle,
                  color: AppColors.muted,
                ),
              ],
            ),
            if (isDesktop)
              Row(
                children: [
                  Semantics(
                    label: 'Previous related products',
                    button: true,
                    child: AppContainer(
                      radius: AppRadius.pill,
                      width: 40,
                      height: 40,
                      padding: EdgeInsetsDirectional.zero,
                      color: AppColors.blush,
                      onTap: () => _scroll(-260),
                      child: Center(
                        child: Icon(
                          isRtl ? Iconsax.arrow_right_3 : Iconsax.arrow_left_2,
                          color: AppColors.burgundy,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.s8),
                  Semantics(
                    label: 'Next related products',
                    button: true,
                    child: AppContainer(
                      radius: AppRadius.pill,
                      width: 40,
                      height: 40,
                      padding: EdgeInsetsDirectional.zero,
                      color: AppColors.blush,
                      onTap: () => _scroll(260),
                      child: Center(
                        child: Icon(
                          isRtl ? Iconsax.arrow_left_2 : Iconsax.arrow_right_3,
                          color: AppColors.burgundy,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),

        const SizedBox(height: AppSpacing.s16),

        // Horizontal Product List
        SizedBox(
          height: 390,
          child: ListView.separated(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            itemCount: widget.products.length,
            separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.s16),
            itemBuilder: (context, index) {
              return SizedBox(
                width: 240,
                child: ProductCard(product: widget.products[index]),
              );
            },
          ),
        ),
      ],
    );
  }
}
