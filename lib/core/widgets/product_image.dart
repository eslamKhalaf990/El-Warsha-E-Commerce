import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import 'package:warsha_commerce/core/network/api_constants.dart';
import 'package:warsha_commerce/core/theme/app_colors.dart';
import 'package:warsha_commerce/core/theme/app_radius.dart';
import 'package:warsha_commerce/core/utils/warsha_images.dart';
import 'package:warsha_commerce/core/widgets/app_container.dart';

/// Product image widget with brand placeholder fallback (blush + champagne icon)
/// and local asset fallback from warsha-images when network images fail to load.
/// Built with [AppContainer].
class ProductImage extends StatelessWidget {
  final String? imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final double radius;
  final int? fallbackSeed;

  const ProductImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.radius = AppRadius.card,
    this.fallbackSeed,
  });

  Widget _buildPlaceholder({bool isLoading = false}) {
    return AppContainer.blush(
      width: width,
      height: height,
      radius: radius,
      padding: EdgeInsetsDirectional.zero,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Iconsax.diamonds,
              size: (height != null && height! < 60) ? 20.0 : 36.0,
              color: AppColors.champagne,
            ),
            if (isLoading) const SizedBox(height: 6),
            if (isLoading)
              const SizedBox(
                width: 14,
                height: 14,
                child: CircularProgressIndicator(
                  strokeWidth: 1.5,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.champagne,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFallbackImage() {
    final assetPath = WarshaImages.getFallbackImage(
      seed: fallbackSeed,
      key: imageUrl,
    );
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: Image.asset(
        assetPath,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final url = imageUrl;
    if (url == null || url.trim().isEmpty) {
      return Semantics(
        label: 'Product placeholder image',
        image: true,
        child: _buildFallbackImage(),
      );
    }

    if (url.startsWith('warsha-images/') || url.startsWith('assets/')) {
      return Semantics(
        label: 'Product Image',
        image: true,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(radius),
          child: Image.asset(
            url,
            width: width,
            height: height,
            fit: fit,
            errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
          ),
        ),
      );
    }

    final resolvedUrl = ApiConstants.imageUrl(url);

    return Semantics(
      label: 'Product Image',
      image: true,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: CachedNetworkImage(
          imageUrl: resolvedUrl,
          width: width,
          height: height,
          fit: fit,
          memCacheWidth: 600,
          placeholder: (context, _) => _buildPlaceholder(isLoading: true),
          errorWidget: (context, url, error) => _buildFallbackImage(),
        ),
      ),
    );
  }
}
