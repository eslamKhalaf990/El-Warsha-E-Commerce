import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import 'package:warsha_commerce/core/localization/app_strings.dart';
import 'package:warsha_commerce/core/theme/app_colors.dart';
import 'package:warsha_commerce/core/theme/app_radius.dart';
import 'package:warsha_commerce/core/theme/app_spacing.dart';
import 'package:warsha_commerce/core/widgets/app_button.dart';
import 'package:warsha_commerce/core/widgets/app_container.dart';
import 'package:warsha_commerce/core/widgets/app_text.dart';

class ShelfSkeleton extends StatefulWidget {
  final int itemCount;
  final double height;
  final bool isHorizontal;

  const ShelfSkeleton({
    super.key,
    this.itemCount = 4,
    this.height = 260,
    this.isHorizontal = false,
  });

  @override
  State<ShelfSkeleton> createState() => _ShelfSkeletonState();
}

class _ShelfSkeletonState extends State<ShelfSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacityAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _opacityAnim = Tween<double>(begin: 0.4, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacityAnim,
      child: widget.isHorizontal
          ? SizedBox(
              height: widget.height,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.itemCount,
                separatorBuilder: (_, _) =>
                    const SizedBox(width: AppSpacing.s16),
                itemBuilder: (_, _) => const AppContainer.blush(
                  width: 220,
                  radius: AppRadius.card,
                  child: SizedBox.expand(),
                ),
              ),
            )
          : GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.itemCount,
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 280,
                crossAxisSpacing: AppSpacing.s16,
                mainAxisSpacing: AppSpacing.s16,
                childAspectRatio: 0.72,
              ),
              itemBuilder: (_, _) => const AppContainer.blush(
                radius: AppRadius.card,
                child: SizedBox.expand(),
              ),
            ),
    );
  }
}

class ShelfErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const ShelfErrorView({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);

    return AppContainer.blush(
      padding: const EdgeInsetsDirectional.all(AppSpacing.s24),
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Iconsax.info_circle, color: AppColors.burgundy, size: 32),
          const SizedBox(height: AppSpacing.s8),
          AppText.body(message, textAlign: TextAlign.center),
          const SizedBox(height: AppSpacing.s16),
          AppButton.secondary(
            label: strings.retry,
            height: 38,
            onPressed: onRetry,
          ),
        ],
      ),
    );
  }
}

class ShelfEmptyView extends StatelessWidget {
  final String? message;

  const ShelfEmptyView({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);

    return AppContainer.blush(
      padding: const EdgeInsetsDirectional.all(AppSpacing.s32),
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Iconsax.box, color: AppColors.muted, size: 36),
          const SizedBox(height: AppSpacing.s12),
          AppText.body(
            message ?? strings.emptyShelf,
            color: AppColors.muted,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
