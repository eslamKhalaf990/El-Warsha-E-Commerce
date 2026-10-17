import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';

import 'package:warsha_commerce/core/localization/app_strings.dart';
import 'package:warsha_commerce/core/theme/app_colors.dart';
import 'package:warsha_commerce/core/theme/app_radius.dart';
import 'package:warsha_commerce/core/theme/app_spacing.dart';
import 'package:warsha_commerce/core/utils/breakpoints.dart';
import 'package:warsha_commerce/core/widgets/app_container.dart';
import 'package:warsha_commerce/core/widgets/app_text.dart';
import 'package:warsha_commerce/features/catalog/domain/entities/product.dart';
import 'package:warsha_commerce/features/home/presentation/cubit/home_cubit.dart';
import 'package:warsha_commerce/features/home/presentation/cubit/home_state.dart';
import 'package:warsha_commerce/features/home/presentation/widgets/product_card.dart';
import 'package:warsha_commerce/features/home/presentation/widgets/shelf_states.dart';

class BestSellersShelf extends StatefulWidget {
  const BestSellersShelf({super.key});

  @override
  State<BestSellersShelf> createState() => _BestSellersShelfState();
}

class _BestSellersShelfState extends State<BestSellersShelf> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scroll(double offset) {
    _scrollController.animateTo(
      (_scrollController.offset + offset).clamp(
        0.0,
        _scrollController.position.maxScrollExtent,
      ),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    final isDesktop = context.isDesktop;
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Shelf Header: Title & Desktop Prev/Next Arrows
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppText.headline(strings.bestSellers, color: AppColors.deepWine),
            if (isDesktop)
              Row(
                children: [
                  Semantics(
                    label: 'Previous best sellers',
                    button: true,
                    child: AppContainer(
                      radius: AppRadius.pill,
                      width: 40,
                      height: 40,
                      padding: EdgeInsetsDirectional.zero,
                      color: AppColors.blush,
                      onTap: () => _scroll(-260),
                      child: Center(
                        child: Icon(
                          isRtl ? Iconsax.arrow_right_3 : Iconsax.arrow_left_2,
                          color: AppColors.burgundy,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.s8),
                  Semantics(
                    label: 'Next best sellers',
                    button: true,
                    child: AppContainer(
                      radius: AppRadius.pill,
                      width: 40,
                      height: 40,
                      padding: EdgeInsetsDirectional.zero,
                      color: AppColors.blush,
                      onTap: () => _scroll(260),
                      child: Center(
                        child: Icon(
                          isRtl ? Iconsax.arrow_left_2 : Iconsax.arrow_right_3,
                          color: AppColors.burgundy,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.s24),

        // Shelf Content
        BlocSelector<
          HomeCubit,
          HomeState,
          (ShelfStatus, List<Product>, String?)
        >(
          selector: (state) => (
            state.bestSellersStatus,
            state.bestSellers,
            state.bestSellersError,
          ),
          builder: (context, data) {
            final (status, products, error) = data;

            switch (status) {
              case ShelfStatus.initial:
              case ShelfStatus.loading:
                return const ShelfSkeleton(
                  isHorizontal: true,
                  height: 390,
                  itemCount: 5,
                );

              case ShelfStatus.failure:
                return ShelfErrorView(
                  message: error ?? 'Failed to load best sellers',
                  onRetry: () => context.read<HomeCubit>().loadBestSellers(),
                );

              case ShelfStatus.success:
                if (products.isEmpty) {
                  return const ShelfEmptyView();
                }

                return SizedBox(
                  height: 390,
                  child: ListView.separated(
                    controller: _scrollController,
                    scrollDirection: Axis.horizontal,
                    itemCount: products.length,
                    separatorBuilder: (_, _) =>
                        const SizedBox(width: AppSpacing.s16),
                    itemBuilder: (context, index) {
                      return SizedBox(
                        width: 240,
                        child: ProductCard(product: products[index]),
                      );
                    },
                  ),
                );
            }
          },
        ),
      ],
    );
  }
}
