import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import 'package:warsha_commerce/core/l10n/app_strings.dart';
import 'package:warsha_commerce/core/theme/app_colors.dart';
import 'package:warsha_commerce/core/theme/app_radius.dart';
import 'package:warsha_commerce/core/theme/app_spacing.dart';
import 'package:warsha_commerce/core/utils/breakpoints.dart';
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
  final PageController _pageController = PageController();
  int _page = 0;

  static const _pageDuration = Duration(milliseconds: 280);

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
  void didUpdateWidget(covariant ProductGalleryView oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Opening another product (e.g. from related products) starts at its cover
    if (oldWidget.product.id != widget.product.id &&
        _pageController.hasClients) {
      _pageController.jumpToPage(0);
      _page = 0;
    }
  }

  @override
  void dispose() {
    _heartAnimController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _goTo(int page, int count) {
    if (page < 0 || page >= count) return;
    _pageController.animateToPage(
      page,
      duration: _pageDuration,
      curve: Curves.easeOutCubic,
    );
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
    final images = product.galleryImages.isEmpty
        ? <String?>[null]
        : product.galleryImages;
    final hasMany = images.length > 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Main Image Display Container: swipe through the cover and gallery images
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
                  // Let mouse users drag too (Flutter web only allows touch by default)
                  child: ScrollConfiguration(
                    behavior: ScrollConfiguration.of(
                      context,
                    ).copyWith(dragDevices: PointerDeviceKind.values.toSet()),
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: images.length,
                      onPageChanged: (page) => setState(() => _page = page),
                      itemBuilder: (context, index) => ProductImage(
                        imageUrl: images[index],
                        fallbackSeed: product.id,
                        radius: AppRadius.card,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),

                // Desktop: previous / next arrows (mobile users swipe)
                if (hasMany && context.isDesktop) ...[
                  PositionedDirectional(
                    start: AppSpacing.s12,
                    top: 0,
                    bottom: 0,
                    child: Center(
                      child: _buildArrow(
                        forward: false,
                        onTap: _page > 0
                            ? () => _goTo(_page - 1, images.length)
                            : null,
                      ),
                    ),
                  ),
                  PositionedDirectional(
                    end: AppSpacing.s12,
                    top: 0,
                    bottom: 0,
                    child: Center(
                      child: _buildArrow(
                        forward: true,
                        onTap: _page < images.length - 1
                            ? () => _goTo(_page + 1, images.length)
                            : null,
                      ),
                    ),
                  ),
                ],

                // Bottom: page dots
                if (hasMany)
                  PositionedDirectional(
                    bottom: AppSpacing.s16,
                    start: 0,
                    end: 0,
                    child: Center(child: _buildDots(images.length)),
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

        // Thumbnail strip
        if (hasMany) ...[
          const SizedBox(height: AppSpacing.s12),
          SizedBox(
            height: 68,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: images.length,
              separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.s8),
              itemBuilder: (context, index) =>
                  _buildThumbnail(images[index], index, images.length),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildDots(int count) {
    return Container(
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: AppSpacing.s8,
        vertical: AppSpacing.s4 + 2,
      ),
      decoration: BoxDecoration(
        color: AppColors.ink.withValues(alpha: 0.28),
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < count; i++)
            AnimatedContainer(
              duration: _pageDuration,
              curve: Curves.easeOutCubic,
              margin: const EdgeInsetsDirectional.symmetric(horizontal: 3),
              width: i == _page ? 18 : 6,
              height: 6,
              decoration: BoxDecoration(
                color: i == _page
                    ? AppColors.champagne
                    : AppColors.white.withValues(alpha: 0.75),
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildArrow({required bool forward, VoidCallback? onTap}) {
    // "Forward" points to the end side, which is left in Arabic (RTL)
    final rtl = Directionality.of(context) == TextDirection.rtl;
    final pointsRight = forward != rtl;
    return AnimatedOpacity(
      duration: _pageDuration,
      opacity: onTap == null ? 0.0 : 1.0,
      child: Semantics(
        label: forward ? 'Next image' : 'Previous image',
        button: true,
        child: AppContainer(
          radius: AppRadius.pill,
          color: AppColors.white.withValues(alpha: 0.9),
          padding: EdgeInsetsDirectional.zero,
          width: 40,
          height: 40,
          onTap: onTap,
          child: Center(
            child: Icon(
              pointsRight ? Iconsax.arrow_right_3 : Iconsax.arrow_left_2,
              color: AppColors.deepWine,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildThumbnail(String? url, int index, int count) {
    final selected = index == _page;
    return Semantics(
      label: 'Image ${index + 1} of $count',
      selected: selected,
      button: true,
      child: GestureDetector(
        onTap: () => _goTo(index, count),
        child: AnimatedContainer(
          duration: _pageDuration,
          width: 68,
          padding: const EdgeInsetsDirectional.all(2),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppRadius.input + 2),
            border: Border.all(
              color: selected ? AppColors.champagne : AppColors.line,
              width: selected ? 2 : 1,
            ),
          ),
          child: Opacity(
            opacity: selected ? 1.0 : 0.7,
            child: ProductImage(
              imageUrl: url,
              fallbackSeed: widget.product.id,
              radius: AppRadius.input,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
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
