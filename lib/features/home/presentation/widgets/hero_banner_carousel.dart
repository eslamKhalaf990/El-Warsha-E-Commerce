import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:warsha_commerce/core/localization/app_strings.dart';
import 'package:warsha_commerce/core/theme/app_colors.dart';
import 'package:warsha_commerce/core/theme/app_radius.dart';
import 'package:warsha_commerce/core/theme/app_spacing.dart';
import 'package:warsha_commerce/core/utils/breakpoints.dart';
import 'package:warsha_commerce/core/widgets/app_container.dart';
import 'package:warsha_commerce/core/widgets/app_text.dart';
import 'package:warsha_commerce/core/widgets/product_image.dart';
import 'package:warsha_commerce/features/home/domain/entities/home_banner.dart';

class HeroBannerCarousel extends StatefulWidget {
  final List<HomeBanner> banners;

  const HeroBannerCarousel({super.key, required this.banners});

  @override
  State<HeroBannerCarousel> createState() => _HeroBannerCarouselState();
}

class _HeroBannerCarouselState extends State<HeroBannerCarousel> {
  late final PageController _pageController;
  int _currentIndex = 0;
  Timer? _timer;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 6), (_) {
      if (!mounted || _isHovered || widget.banners.isEmpty) return;
      final nextIndex = (_currentIndex + 1) % widget.banners.length;
      _pageController.animateToPage(
        nextIndex,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOutCubic,
      );
    });
  }

  void _onHover(bool isHovered) {
    setState(() => _isHovered = isHovered);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.banners.isEmpty) {
      return const SizedBox.shrink();
    }

    final isDesktop = context.isDesktop;
    final strings = AppStrings.of(context);
    final disableAnimations = MediaQuery.of(context).disableAnimations;

    return FocusableActionDetector(
      onShowFocusHighlight: _onHover,
      child: MouseRegion(
        onEnter: (_) => _onHover(true),
        onExit: (_) => _onHover(false),
        child: Column(
          children: [
            SizedBox(
              height: isDesktop ? 440 : 540,
              child: PageView.builder(
                physics: const NeverScrollableScrollPhysics(),
                controller: _pageController,
                itemCount: widget.banners.length,
                onPageChanged: (index) {
                  setState(() => _currentIndex = index);
                },
                itemBuilder: (context, index) {
                  final banner = widget.banners[index];
                  return AnimatedOpacity(
                    duration: disableAnimations
                        ? Duration.zero
                        : const Duration(milliseconds: 300),
                    opacity: 1.0,
                    child: _buildBannerSlide(
                      banner,
                      strings.isArabic,
                      isDesktop,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: AppSpacing.s16),
            _buildDots(),
          ],
        ),
      ),
    );
  }

  Widget _buildBannerSlide(HomeBanner banner, bool isArabic, bool isDesktop) {
    if (isDesktop) {
      return AppContainer(
        padding: EdgeInsetsDirectional.zero,
        radius: AppRadius.card,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Left Text Panel: Burgundy
            Expanded(
              flex: 5,
              child: Container(
                decoration: const BoxDecoration(
                  color: AppColors.burgundy,
                  borderRadius: BorderRadiusDirectional.horizontal(
                    start: Radius.circular(AppRadius.card),
                  ),
                ),
                padding: const EdgeInsetsDirectional.all(AppSpacing.s48),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildEyebrow(banner.getEyebrow(isArabic)),
                    const SizedBox(height: AppSpacing.s12),
                    AppText.display(
                      banner.getTitle(isArabic),
                      color: AppColors.white,
                    ),
                    const SizedBox(height: AppSpacing.s16),
                    AppText.body(
                      banner.getSubtitle(isArabic),
                      color: AppColors.blush,
                    ),
                    const SizedBox(height: AppSpacing.s32),
                    _buildCtaButton(banner, isArabic),
                  ],
                ),
              ),
            ),
            // Right Art Panel: Blush
            Expanded(
              flex: 6,
              child: Container(
                decoration: const BoxDecoration(
                  color: AppColors.blush,
                  borderRadius: BorderRadiusDirectional.horizontal(
                    end: Radius.circular(AppRadius.card),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadiusDirectional.horizontal(
                    end: Radius.circular(AppRadius.card),
                  ).resolve(Directionality.of(context)),
                  child: ProductImage(
                    imageUrl: banner.imageUrl,
                    fallbackSeed: banner.id.hashCode,
                    radius: 0,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    // Mobile / Tablet stacked banner
    return AppContainer(
      padding: EdgeInsetsDirectional.zero,
      radius: AppRadius.card,
      child: Column(
        children: [
          // Art panel top
          Expanded(
            flex: 5,
            child: Container(
              color: AppColors.blush,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(AppRadius.card),
                ),
                child: ProductImage(
                  imageUrl: banner.imageUrl,
                  fallbackSeed: banner.id.hashCode,
                  radius: 0,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            ),
          ),
          // Text panel bottom
          Expanded(
            flex: 6,
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: AppColors.burgundy,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(AppRadius.card),
                ),
              ),
              padding: const EdgeInsetsDirectional.all(AppSpacing.s24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildEyebrow(banner.getEyebrow(isArabic)),
                  const SizedBox(height: AppSpacing.s8),
                  AppText.headline(
                    banner.getTitle(isArabic),
                    color: AppColors.white,
                  ),
                  const SizedBox(height: AppSpacing.s8),
                  AppText.bodySmall(
                    banner.getSubtitle(isArabic),
                    color: AppColors.blush,
                    maxLines: 2,
                  ),
                  const SizedBox(height: AppSpacing.s16),
                  _buildCtaButton(banner, isArabic),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEyebrow(String text) {
    return Container(
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: AppSpacing.s8,
        vertical: AppSpacing.s4,
      ),
      decoration: BoxDecoration(
        color: AppColors.deepWine,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(color: AppColors.champagne, width: 0.8),
      ),
      child: AppText.caption(
        text,
        color: AppColors.champagne,
        weight: FontWeight.w600,
      ),
    );
  }

  Widget _buildCtaButton(HomeBanner banner, bool isArabic) {
    return Semantics(
      label: banner.getButtonText(isArabic),
      button: true,
      child: InkWell(
        onTap: () => context.push(banner.buttonLink),
        borderRadius: BorderRadius.circular(AppRadius.pill),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.s24,
            vertical: AppSpacing.s12,
          ),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppRadius.pill),
            boxShadow: const [
              BoxShadow(
                color: Color(0x1A000000),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: AppText.label(
            banner.getButtonText(isArabic),
            color: AppColors.burgundy,
          ),
        ),
      ),
    );
  }

  Widget _buildDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(widget.banners.length, (index) {
        final isSelected = _currentIndex == index;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: isSelected ? 24 : 8,
            height: 8,
            decoration: BoxDecoration(
              color: isSelected ? AppColors.burgundy : AppColors.line,
              borderRadius: BorderRadius.circular(AppRadius.pill),
            ),
          ),
        );
      }),
    );
  }
}
