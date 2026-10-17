import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

import 'package:warsha_commerce/core/localization/app_strings.dart';
import 'package:warsha_commerce/core/theme/app_colors.dart';
import 'package:warsha_commerce/core/theme/app_radius.dart';
import 'package:warsha_commerce/core/theme/app_spacing.dart';
import 'package:warsha_commerce/core/utils/breakpoints.dart';
import 'package:warsha_commerce/core/widgets/app_container.dart';
import 'package:warsha_commerce/core/widgets/app_text.dart';
import 'package:warsha_commerce/features/catalog/domain/entities/category.dart';
import 'package:warsha_commerce/features/home/presentation/cubit/home_cubit.dart';
import 'package:warsha_commerce/features/home/presentation/cubit/home_state.dart';
import 'package:warsha_commerce/features/home/presentation/widgets/shelf_states.dart';

class ShopByCategorySection extends StatelessWidget {
  const ShopByCategorySection({super.key});

  IconData _getCategoryIcon(String name) {
    if (name.contains('خواتم') || name.toLowerCase().contains('ring')) {
      return Iconsax.record_circle;
    } else if (name.contains('أساور') ||
        name.toLowerCase().contains('bracelet')) {
      return Iconsax.watch;
    } else if (name.contains('قلائد') ||
        name.toLowerCase().contains('necklace')) {
      return Iconsax.gemini;
    } else if (name.contains('أقراط') ||
        name.toLowerCase().contains('earring')) {
      return Iconsax.magic_star;
    }
    return Iconsax.diamonds;
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    final width = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText.headline(strings.shopByCategory, color: AppColors.deepWine),
        const SizedBox(height: AppSpacing.s24),
        BlocSelector<
          HomeCubit,
          HomeState,
          (ShelfStatus, List<Category>, String?)
        >(
          selector: (state) =>
              (state.categoriesStatus, state.categories, state.categoriesError),
          builder: (context, data) {
            final (status, categories, error) = data;

            switch (status) {
              case ShelfStatus.initial:
              case ShelfStatus.loading:
                return const ShelfSkeleton(
                  height: 140,
                  itemCount: 5,
                  isHorizontal: true,
                );

              case ShelfStatus.failure:
                return ShelfErrorView(
                  message: error ?? 'Failed to load categories',
                  onRetry: () => context.read<HomeCubit>().loadCategories(),
                );

              case ShelfStatus.success:
                if (categories.isEmpty) {
                  return const ShelfEmptyView();
                }

                final int crossCount = width >= Breakpoints.desktop
                    ? categories.length.clamp(2, 5)
                    : (width >= Breakpoints.mobile ? 3 : 2);

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: categories.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossCount,
                    crossAxisSpacing: AppSpacing.s16,
                    mainAxisSpacing: AppSpacing.s16,
                    childAspectRatio: 1.3,
                  ),
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    return _CategoryTile(
                      category: category,
                      icon: _getCategoryIcon(category.name),
                    );
                  },
                );
            }
          },
        ),
      ],
    );
  }
}

class _CategoryTile extends StatefulWidget {
  final Category category;
  final IconData icon;

  const _CategoryTile({required this.category, required this.icon});

  @override
  State<_CategoryTile> createState() => _CategoryTileState();
}

class _CategoryTileState extends State<_CategoryTile> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedScale(
        scale: _isHovered ? 1.03 : 1.0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        child: AppContainer.blush(
          padding: const EdgeInsetsDirectional.all(AppSpacing.s16),
          radius: AppRadius.card,
          onTap: () => context.push('/shop?category=${widget.category.id}'),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(widget.icon, color: AppColors.burgundy, size: 36),
              const SizedBox(height: AppSpacing.s12),
              AppText.titleSmall(
                widget.category.name,
                color: AppColors.deepWine,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
