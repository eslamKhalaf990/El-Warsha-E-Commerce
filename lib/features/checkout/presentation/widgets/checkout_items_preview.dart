import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

import 'package:warsha_commerce/core/l10n/product_text.dart';
import 'package:warsha_commerce/core/theme/app_colors.dart';
import 'package:warsha_commerce/core/theme/app_radius.dart';
import 'package:warsha_commerce/core/theme/app_spacing.dart';
import 'package:warsha_commerce/core/utils/money.dart';
import 'package:warsha_commerce/core/widgets/app_container.dart';
import 'package:warsha_commerce/core/widgets/app_text.dart';
import 'package:warsha_commerce/core/widgets/product_image.dart';
import 'package:warsha_commerce/features/cart/domain/entities/cart_item.dart';

class CheckoutItemsPreview extends StatelessWidget {
  final List<CartItem> items;

  const CheckoutItemsPreview({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return AppContainer.surface(
      radius: AppRadius.card,
      padding: const EdgeInsetsDirectional.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(
                    Iconsax.shopping_bag,
                    size: 20,
                    color: AppColors.burgundy,
                  ),
                  SizedBox(width: AppSpacing.s8),
                  AppText.titleSmall(
                    'المنتجات في الطلب',
                    weight: FontWeight.w700,
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsetsDirectional.symmetric(
                  horizontal: AppSpacing.s8,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: AppColors.blush,
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                ),
                child: Text(
                  '${items.length} منتجات',
                  style: GoogleFonts.cairo(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.burgundy,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.s16),

          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            separatorBuilder: (context, index) => const Padding(
              padding: EdgeInsets.symmetric(vertical: AppSpacing.s8),
              child: Divider(color: AppColors.line, height: 1),
            ),
            itemBuilder: (context, index) {
              final item = items[index];
              return Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppRadius.card),
                    child: SizedBox(
                      width: 50,
                      height: 50,
                      child: ProductImage(
                        imageUrl: item.product.imageUrl,
                        fallbackSeed: item.product.id,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.s12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.variant == null
                              ? item.product.localizedName(context)
                              : '${item.product.localizedName(context)} (${item.variant!.localizedLabel(context)})',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.cairo(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.ink,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${item.quantity} × ${MoneyUtils.formatMinor(item.unitPrice)}',
                          style: GoogleFonts.cairo(
                            fontSize: 11.5,
                            color: AppColors.muted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    MoneyUtils.formatMinor(item.totalPrice),
                    style: GoogleFonts.cairo(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.deepWine,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
