import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

import 'package:warsha_commerce/core/l10n/app_strings.dart';
import 'package:warsha_commerce/core/l10n/product_text.dart';
import 'package:warsha_commerce/core/theme/app_colors.dart';
import 'package:warsha_commerce/core/theme/app_radius.dart';
import 'package:warsha_commerce/core/theme/app_spacing.dart';
import 'package:warsha_commerce/core/utils/money.dart';
import 'package:warsha_commerce/core/widgets/app_container.dart';
import 'package:warsha_commerce/core/widgets/app_text.dart';
import 'package:warsha_commerce/core/widgets/product_image.dart';
import 'package:warsha_commerce/core/widgets/quantity_stepper.dart';
import 'package:warsha_commerce/features/cart/domain/entities/cart_item.dart';
import 'package:warsha_commerce/features/cart/presentation/cubit/cart_cubit.dart';

class CartItemTile extends StatelessWidget {
  final CartItem item;

  const CartItemTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final product = item.product;

    return AppContainer.surface(
      radius: AppRadius.card,
      padding: const EdgeInsetsDirectional.all(AppSpacing.s16),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isCompact = constraints.maxWidth < 450;

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image
              ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.card),
                child: SizedBox(
                  width: isCompact ? 76 : 96,
                  height: isCompact ? 76 : 96,
                  child: ProductImage(
                    imageUrl: product.imageUrl,
                    fallbackSeed: product.id,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.s16),

              // Product Info & Controls
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title and Delete Action Row
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (product.categoryName.isNotEmpty) ...[
                                Text(
                                  product.categoryName,
                                  style: GoogleFonts.cairo(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.muted,
                                  ),
                                ),
                                const SizedBox(height: 2),
                              ],
                              Text(
                                product.localizedName(context),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.cairo(
                                  fontSize: isCompact ? 14 : 15,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.ink,
                                  height: 1.25,
                                ),
                              ),
                              if (item.variant != null)
                                Text(
                                  item.variant!.localizedLabel(context),
                                  style: GoogleFonts.cairo(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.muted,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        // Remove item button
                        IconButton(
                          icon: const Icon(
                            Iconsax.trash,
                            size: 20,
                            color: AppColors.muted,
                          ),
                          tooltip: AppStrings.remove,
                          splashRadius: 20,
                          onPressed: () {
                            context.read<CartCubit>().removeFromCart(
                              product.id,
                              variantId: item.variantId,
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.s8),

                    // Unit Price
                    Row(
                      children: [
                        Text(
                          MoneyUtils.formatMinor(item.unitPrice),
                          style: GoogleFonts.cairo(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w600,
                            color: AppColors.deepWine,
                          ),
                        ),
                        if (product.hasDiscount) ...[
                          const SizedBox(width: AppSpacing.s8),
                          Text(
                            MoneyUtils.formatMinor(item.variant?.price ?? product.sellingPrice),
                            style: GoogleFonts.cairo(
                              fontSize: 11.5,
                              color: AppColors.muted,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: AppSpacing.s12),

                    // Bottom Row: Stepper and Row Subtotal
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Quantity Stepper
                        QuantityStepper(
                          quantity: item.quantity,
                          maxQuantity: item.availableStock > 0
                              ? item.availableStock
                              : 99,
                          onChanged: (newQty) {
                            if (newQty <= 0) {
                              context.read<CartCubit>().removeFromCart(
                                product.id,
                                variantId: item.variantId,
                              );
                            } else {
                              context.read<CartCubit>().updateQuantity(
                                product.id,
                                newQty,
                                variantId: item.variantId,
                              );
                            }
                          },
                        ),

                        // Line Total Price
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const AppText.caption(
                              AppStrings.total,
                              color: AppColors.muted,
                            ),
                            Text(
                              MoneyUtils.formatMinor(item.totalPrice),
                              style: GoogleFonts.cairo(
                                fontSize: isCompact ? 14 : 16,
                                fontWeight: FontWeight.w800,
                                color: AppColors.burgundy,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
