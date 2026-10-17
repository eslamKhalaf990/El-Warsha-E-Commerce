import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

import 'package:warsha_commerce/core/l10n/app_strings.dart';
import 'package:warsha_commerce/core/theme/app_colors.dart';
import 'package:warsha_commerce/core/theme/app_radius.dart';
import 'package:warsha_commerce/core/theme/app_spacing.dart';
import 'package:warsha_commerce/core/utils/breakpoints.dart';
import 'package:warsha_commerce/core/utils/money.dart';
import 'package:warsha_commerce/core/widgets/app_button.dart';
import 'package:warsha_commerce/core/widgets/app_container.dart';
import 'package:warsha_commerce/core/widgets/app_text.dart';
import 'package:warsha_commerce/core/widgets/product_image.dart';
import 'package:warsha_commerce/core/widgets/status_pill.dart';
import 'package:warsha_commerce/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:warsha_commerce/features/catalog/domain/entities/product.dart';

class ProductCard extends StatefulWidget {
  final Product product;
  final double? width;

  const ProductCard({super.key, required this.product, this.width});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
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

  void _onAddToCart(BuildContext context) {
    if (widget.product.isOutOfStock) return;
    context.read<CartCubit>().addToCart(widget.product);

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${widget.product.name} - ${AppStrings.addedToCart}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final isDesktop = context.isDesktop;
    final isOutOfStock = product.isOutOfStock;

    // RepaintBoundary isolates card repaints from scroll viewport
    return RepaintBoundary(
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          transform: Matrix4.translationValues(
            0,
            (_isHovered && isDesktop) ? -4 : 0,
            0,
          ),
          width: widget.width,
          child: Opacity(
            opacity: isOutOfStock ? 0.65 : 1.0,
            child: AppContainer(
              color: AppColors.white,
              radius: AppRadius.card,
              padding: EdgeInsetsDirectional.zero,
              // Zero box-shadow for 120 FPS scrolling performance & pure boutique minimal aesthetic
              onTap: () => context.push('/product/${product.id}'),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final bool hasBoundedHeight = constraints.hasBoundedHeight;
                  if (hasBoundedHeight) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _buildImageStack(
                            product,
                            isDesktop,
                            isExpanded: true,
                          ),
                        ),
                        _buildDetails(product, isDesktop),
                      ],
                    );
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildImageStack(
                        product,
                        isDesktop,
                        isExpanded: false,
                      ),
                      _buildDetails(product, isDesktop),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageStack(
    Product product,
    bool isDesktop, {
    bool isExpanded = false,
  }) {
    final imageStack = ClipRRect(
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(AppRadius.card),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Smooth boutique image zoom on desktop hover
          AnimatedScale(
            scale: (_isHovered && isDesktop) ? 1.05 : 1.0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            child: Container(
              color: AppColors.blush.withValues(alpha: 0.2),
              child: ProductImage(
                imageUrl: product.imageUrl,
                fallbackSeed: product.id,
                radius: 0,
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Top-start: Discount or Sold-out or New badge
          PositionedDirectional(
            top: AppSpacing.s8,
            start: AppSpacing.s8,
            child: _buildBadge(product),
          ),
          // Top-end: Wishlist Heart
          PositionedDirectional(
            top: AppSpacing.s8,
            end: AppSpacing.s8,
            child: _buildWishlistButton(),
          ),
          // Desktop hover: quick Add to Cart slide-up overlay
          if (isDesktop && !product.isOutOfStock)
            PositionedDirectional(
              bottom: AppSpacing.s12,
              start: AppSpacing.s12,
              end: AppSpacing.s12,
              child: IgnorePointer(
                ignoring: !_isHovered,
                child: AnimatedSlide(
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOutCubic,
                  offset: _isHovered ? Offset.zero : const Offset(0, 0.25),
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 200),
                    opacity: _isHovered ? 1.0 : 0.0,
                    child: AppButton.primary(
                      label: AppStrings.addToCart,
                      icon: const Icon(
                        Iconsax.bag_2,
                        size: 16,
                        color: AppColors.white,
                      ),
                      height: 40,
                      onPressed: () => _onAddToCart(context),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );

    if (isExpanded) {
      return SizedBox.expand(child: imageStack);
    }

    return AspectRatio(
      aspectRatio: 1.0,
      child: imageStack,
    );
  }

  Widget _buildBadge(Product product) {
    if (product.isOutOfStock) {
      return const StatusPill.neutral(label: AppStrings.outOfStock);
    }
    // Genuine urgency: Show discount copy only when discount > 0
    if (product.discount > 0) {
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
          AppStrings.saveAmount(MoneyUtils.formatMinor(product.discount)),
          color: AppColors.ink,
          weight: FontWeight.w700,
        ),
      );
    }
    return Container(
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: AppSpacing.s8,
        vertical: AppSpacing.s4,
      ),
      decoration: BoxDecoration(
        color: AppColors.blush,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(
          color: AppColors.burgundy.withValues(alpha: 0.15),
          width: 0.5,
        ),
      ),
      child: const AppText.caption(
        AppStrings.newBadge,
        color: AppColors.burgundy,
        weight: FontWeight.w600,
      ),
    );
  }

  Widget _buildWishlistButton() {
    return ScaleTransition(
      scale: _heartScale,
      child: Semantics(
        label: _isWishlisted ? 'Remove from wishlist' : 'Add to wishlist',
        button: true,
        child: Material(
          color: AppColors.white.withValues(alpha: 0.92),
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: _toggleWishlist,
            child: SizedBox(
              width: 36,
              height: 36,
              child: Center(
                child: Icon(
                  _isWishlisted ? Iconsax.heart5 : Iconsax.heart,
                  size: 18,
                  color: _isWishlisted
                      ? AppColors.burgundy
                      : AppColors.deepWine,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetails(Product product, bool isDesktop) {
    final bool hasLowStock = product.quantity > 0 && product.quantity <= 5;

    return Padding(
      padding: const EdgeInsetsDirectional.all(AppSpacing.s12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          AppText.caption(
            product.categoryName,
            color: AppColors.muted,
            maxLines: 1,
          ),
          const SizedBox(height: AppSpacing.s4),
          AppText.titleSmall(
            product.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          // Genuine urgency: Show scarcity copy only when quantity <= 5
          if (hasLowStock) ...[
            const SizedBox(height: AppSpacing.s4),
            AppText.caption(
              AppStrings.lowStock(product.quantity),
              color: AppColors.burgundy,
              weight: FontWeight.w700,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          const SizedBox(height: AppSpacing.s8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: AppSpacing.s8,
                  children: [
                    AppText.price(
                      MoneyUtils.formatMinor(product.totalPrice),
                      color: AppColors.burgundy,
                    ),
                    if (product.totalPrice < product.sellingPrice)
                      AppText.caption(
                        MoneyUtils.formatMinor(product.sellingPrice),
                        decoration: TextDecoration.lineThrough,
                        color: AppColors.muted,
                      ),
                  ],
                ),
              ),
              // Mobile / Tablet quick "+" add button
              if (!isDesktop && !product.isOutOfStock)
                Semantics(
                  label: AppStrings.addToCart,
                  button: true,
                  child: AppContainer(
                    radius: AppRadius.pill,
                    color: AppColors.burgundy,
                    width: 36,
                    height: 36,
                    padding: EdgeInsetsDirectional.zero,
                    onTap: () => _onAddToCart(context),
                    child: const Center(
                      child: Icon(
                        Iconsax.add,
                        color: AppColors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
