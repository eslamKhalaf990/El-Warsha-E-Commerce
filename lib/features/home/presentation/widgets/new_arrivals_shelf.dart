import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:warsha_commerce/core/localization/app_strings.dart';
import 'package:warsha_commerce/core/theme/app_colors.dart';
import 'package:warsha_commerce/core/theme/app_spacing.dart';
import 'package:warsha_commerce/core/utils/breakpoints.dart';
import 'package:warsha_commerce/core/widgets/app_text.dart';
import 'package:warsha_commerce/features/catalog/domain/entities/product.dart';
import 'package:warsha_commerce/features/home/presentation/cubit/home_cubit.dart';
import 'package:warsha_commerce/features/home/presentation/cubit/home_state.dart';
import 'package:warsha_commerce/features/home/presentation/widgets/product_card.dart';
import 'package:warsha_commerce/features/home/presentation/widgets/shelf_states.dart';

class NewArrivalsShelf extends StatelessWidget {
  const NewArrivalsShelf({super.key});

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    final width = MediaQuery.of(context).size.width;

    // Responsive columns: 4 desktop (>=1024), 3 tablet (<1024), 2 mobile (<680)
    final int crossAxisCount = width >= Breakpoints.desktop
        ? 4
        : (width >= Breakpoints.mobile ? 3 : 2);

    final double childAspectRatio = width >= Breakpoints.desktop
        ? 0.65
        : (width >= Breakpoints.mobile ? 0.60 : 0.54);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Shelf Header: Title & "View all →"
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            AppText.headline(strings.newArrivals, color: AppColors.deepWine),
            InkWell(
              onTap: () => context.push('/shop?sort=newest'),
              child: AppText.label(strings.viewAll, color: AppColors.burgundy),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.s24),

        // Shelf Content with AnimatedSwitcher
        BlocSelector<
          HomeCubit,
          HomeState,
          (ShelfStatus, List<Product>, String?)
        >(
          selector: (state) => (
            state.newArrivalsStatus,
            state.newArrivals,
            state.newArrivalsError,
          ),
          builder: (context, data) {
            final (status, products, error) = data;

            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: _buildBody(
                context,
                status,
                products,
                error,
                crossAxisCount,
                childAspectRatio,
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildBody(
    BuildContext context,
    ShelfStatus status,
    List<Product> products,
    String? error,
    int crossAxisCount,
    double childAspectRatio,
  ) {
    switch (status) {
      case ShelfStatus.initial:
      case ShelfStatus.loading:
        return ShelfSkeleton(itemCount: crossAxisCount * 2);

      case ShelfStatus.failure:
        return ShelfErrorView(
          message: error ?? 'Failed to load new arrivals',
          onRetry: () => context.read<HomeCubit>().loadNewArrivals(),
        );

      case ShelfStatus.success:
        if (products.isEmpty) {
          return const ShelfEmptyView();
        }

        return GridView.builder(
          key: ValueKey(products.map((p) => p.id).join(',')),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: products.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: AppSpacing.s16,
            mainAxisSpacing: AppSpacing.s16,
            childAspectRatio: childAspectRatio,
          ),
          itemBuilder: (context, index) {
            final product = products[index];
            return ProductCard(product: product);
          },
        );
    }
  }
}
