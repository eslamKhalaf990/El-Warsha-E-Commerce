import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import 'package:warsha_commerce/core/l10n/app_strings.dart';
import 'package:warsha_commerce/core/theme/app_colors.dart';
import 'package:warsha_commerce/core/theme/app_radius.dart';
import 'package:warsha_commerce/core/theme/app_spacing.dart';
import 'package:warsha_commerce/core/utils/money.dart';
import 'package:warsha_commerce/core/widgets/app_container.dart';
import 'package:warsha_commerce/core/widgets/app_text.dart';
import 'package:warsha_commerce/core/widgets/product_image.dart';
import 'package:warsha_commerce/core/widgets/status_pill.dart';
import 'package:warsha_commerce/features/catalog/domain/entities/product.dart';

class ProductGalleryView extends StatefulWidget {
  final Product product;

  const ProductGalleryView({super.key, required this.product});

  @override
  State<ProductGalleryView> createState() => _ProductGalleryViewState();
}

class _ProductGalleryViewState extends State<ProductGalleryView>
    with SingleTickerProviderStateMixin {
  bool _isWishlisted = false;
  late final AnimationController _heartAnimController;
  late final Animation<double> _heartScale;

  @override
  void initState() {
    super.initState();
    _heartAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _heartScale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.3), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.3, end: 1.0), weight: 50),
    ]).animate(_heartAnimController);
  }

  @override
  void dispose() {
    _heartAnimController.dispose();
    super.dispose();
  }

  void _toggleWishlist() {
    setState(() {
      _isWishlisted = !_isWishlisted;
    });
    _heartAnimController.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final isOutOfStock = product.isOutOfStock;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Main Image Display Container
        AppContainer.surface(
          padding: EdgeInsetsDirectional.zero,
          radius: AppRadius.card,
          child: AspectRatio(
            aspectRatio: 1.0,
            child: Stack(
              fit: StackFit.expand,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.card),
                  child: ProductImage(
                    imageUrl: product.imageUrl,
                    fallbackSeed: product.id,
                    radius: AppRadius.card,
                    fit: BoxFit.cover,
                  ),
                ),

                // Top-Start: Status / Discount Badge
                PositionedDirectional(
                  top: AppSpacing.s16,
                  start: AppSpacing.s16,
                  child: _buildBadge(product),
                ),

                // Top-End: Wishlist Button
                PositionedDirectional(
                  top: AppSpacing.s12,
                  end: AppSpacing.s12,
                  child: _buildWishlistButton(),
                ),

                // Subtle out of stock overlay
                if (isOutOfStock)
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.ink.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(AppRadius.card),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBadge(Product product) {
    if (product.isOutOfStock) {
      return const StatusPill.neutral(label: AppStrings.outOfStock);
    }
    if (product.discount > 0) {
      return Container(
        padding: const EdgeInsetsDirectional.symmetric(
          horizontal: AppSpacing.s12,
          vertical: AppSpacing.s4,
        ),
        decoration: BoxDecoration(
          color: AppColors.champagne,
          borderRadius: BorderRadius.circular(AppRadius.pill),
          boxShadow: [
            BoxShadow(
              color: AppColors.champagne.withValues(alpha: 0.4),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: AppText.caption(
          AppStrings.saveAmount(MoneyUtils.formatMinor(product.discount)),
          color: AppColors.ink,
          weight: FontWeight.w700,
        ),
      );
    }
    return Container(
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: AppSpacing.s12,
        vertical: AppSpacing.s4,
      ),
      decoration: BoxDecoration(
        color: AppColors.blush,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: const AppText.caption(
        AppStrings.newBadge,
        color: AppColors.burgundy,
        weight: FontWeight.w700,
      ),
    );
  }

  Widget _buildWishlistButton() {
    return ScaleTransition(
      scale: _heartScale,
      child: Semantics(
        label: _isWishlisted ? 'Remove from wishlist' : 'Add to wishlist',
        button: true,
        child: AppContainer(
          radius: AppRadius.pill,
          color: AppColors.white.withValues(alpha: 0.9),
          padding: EdgeInsetsDirectional.zero,
          width: 44,
          height: 44,
          onTap: _toggleWishlist,
          child: Center(
            child: Icon(
              _isWishlisted ? Iconsax.heart5 : Iconsax.heart,
              color: _isWishlisted ? AppColors.burgundy : AppColors.deepWine,
              size: 22,
            ),
          ),
        ),
      ),
    );
  }
}
