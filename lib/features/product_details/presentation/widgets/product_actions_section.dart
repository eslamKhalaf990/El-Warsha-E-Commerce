import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

import 'package:warsha_commerce/core/l10n/app_strings.dart';
import 'package:warsha_commerce/core/l10n/product_text.dart';
import 'package:warsha_commerce/core/utils/money.dart';
import 'package:warsha_commerce/core/theme/app_colors.dart';
import 'package:warsha_commerce/core/theme/app_spacing.dart';
import 'package:warsha_commerce/core/widgets/app_button.dart';
import 'package:warsha_commerce/core/widgets/app_text.dart';
import 'package:warsha_commerce/core/widgets/quantity_stepper.dart';
import 'package:warsha_commerce/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:warsha_commerce/features/catalog/domain/entities/product.dart';
import 'package:warsha_commerce/features/catalog/domain/entities/product_variant.dart';

class ProductActionsSection extends StatefulWidget {
  final Product product;

  const ProductActionsSection({super.key, required this.product});

  @override
  State<ProductActionsSection> createState() => _ProductActionsSectionState();
}

class _ProductActionsSectionState extends State<ProductActionsSection> {
  int _selectedQuantity = 1;
  ProductVariant? _selectedVariant;
  bool _showVariantError = false;

  void _onAddToCart(BuildContext context) {
    if (widget.product.isOutOfStock) return;
    if (widget.product.hasVariants && _selectedVariant == null) {
      setState(() => _showVariantError = true);
      return;
    }

    context.read<CartCubit>().addToCart(widget.product, _selectedQuantity, _selectedVariant);

    final variantLabel = _selectedVariant == null ? '' : ' - ${_selectedVariant!.localizedLabel(context)}';
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${widget.product.localizedName(context)}$variantLabel (×$_selectedQuantity) - ${AppStrings.addedToCart}',
        ),
        duration: const Duration(seconds: 4),
        action: SnackBarAction(
          label: AppStrings.viewCart,
          textColor: AppColors.champagne,
          onPressed: () => context.push('/cart'),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final variant = _selectedVariant;
    final isOutOfStock = variant?.isOutOfStock ?? product.isOutOfStock;
    final maxAvailable = (variant?.quantity ?? product.quantity).clamp(1, 99);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (product.hasVariants) ...[
          const AppText.titleSmall(
            '${AppStrings.chooseVariant}:',
            weight: FontWeight.w700,
            color: AppColors.deepWine,
          ),
          const SizedBox(height: AppSpacing.s8),
          Wrap(
            spacing: AppSpacing.s8,
            runSpacing: AppSpacing.s8,
            children: [
              for (final v in product.variants)
                ChoiceChip(
                  avatar: _swatch(v.colorHex),
                  label: Text(v.isOutOfStock
                      ? '${v.localizedLabel(context)} · ${AppStrings.soldOut}'
                      : v.localizedLabel(context)),
                  selected: v.id == variant?.id,
                  onSelected: v.isOutOfStock
                      ? null
                      : (_) => setState(() {
                            _selectedVariant = v;
                            _showVariantError = false;
                            _selectedQuantity = _selectedQuantity.clamp(1, v.quantity.clamp(1, 99));
                          }),
                ),
            ],
          ),
          if (variant != null) ...[
            const SizedBox(height: AppSpacing.s8),
            AppText.titleSmall(
              MoneyUtils.formatMinor(variant.totalPrice),
              weight: FontWeight.w800,
              color: AppColors.burgundy,
            ),
          ],
          if (_showVariantError) ...[
            const SizedBox(height: AppSpacing.s8),
            const AppText.caption(AppStrings.chooseVariantFirst, color: AppColors.burgundy),
          ],
          const SizedBox(height: AppSpacing.s16),
        ],
        if (!isOutOfStock) ...[
          Row(
            children: [
              const AppText.titleSmall(
                '${AppStrings.quantity}:',
                weight: FontWeight.w700,
                color: AppColors.deepWine,
              ),
              const SizedBox(width: AppSpacing.s16),
              QuantityStepper(
                quantity: _selectedQuantity,
                minQuantity: 1,
                maxQuantity: maxAvailable,
                onChanged: (newQty) {
                  setState(() {
                    _selectedQuantity = newQty;
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.s16),
        ],

        // Big Main CTA Button
        AppButton.primary(
          label: isOutOfStock ? AppStrings.soldOut : AppStrings.addToCart,
          icon: Icon(
            isOutOfStock ? Iconsax.close_circle : Iconsax.shopping_cart,
            size: 20,
            color: AppColors.white,
          ),
          height: 52,
          onPressed: isOutOfStock ? null : () => _onAddToCart(context),
        ),
      ],
    );
  }

  /// Small color dot for chips whose variant has a color code.
  Widget? _swatch(String? hex) {
    final value = hex == null ? null : int.tryParse(hex.replaceFirst('#', ''), radix: 16);
    if (value == null) return null;
    return CircleAvatar(
      radius: 8,
      backgroundColor: Color(hex!.length == 7 ? 0xFF000000 | value : value),
    );
  }
}
