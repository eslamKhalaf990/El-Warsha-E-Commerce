import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

import 'package:warsha_commerce/core/l10n/app_strings.dart';
import 'package:warsha_commerce/core/theme/app_colors.dart';
import 'package:warsha_commerce/core/theme/app_spacing.dart';
import 'package:warsha_commerce/core/widgets/app_button.dart';
import 'package:warsha_commerce/core/widgets/app_text.dart';
import 'package:warsha_commerce/core/widgets/quantity_stepper.dart';
import 'package:warsha_commerce/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:warsha_commerce/features/catalog/domain/entities/product.dart';

class ProductActionsSection extends StatefulWidget {
  final Product product;

  const ProductActionsSection({super.key, required this.product});

  @override
  State<ProductActionsSection> createState() => _ProductActionsSectionState();
}

class _ProductActionsSectionState extends State<ProductActionsSection> {
  int _selectedQuantity = 1;

  void _onAddToCart(BuildContext context) {
    if (widget.product.isOutOfStock) return;

    context.read<CartCubit>().addToCart(widget.product, _selectedQuantity);

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${widget.product.name} (×$_selectedQuantity) - ${AppStrings.addedToCart}',
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
    final isOutOfStock = product.isOutOfStock;
    final maxAvailable = product.quantity.clamp(1, 99);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
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
}
