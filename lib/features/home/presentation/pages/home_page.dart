import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:warsha_commerce/core/di/di.dart';
import 'package:warsha_commerce/core/theme/app_colors.dart';
import 'package:warsha_commerce/core/theme/app_spacing.dart';
import 'package:warsha_commerce/core/utils/breakpoints.dart';
import 'package:warsha_commerce/features/catalog/domain/entities/category.dart';
import 'package:warsha_commerce/features/feedback/presentation/cubit/testimonials_cubit.dart';
import 'package:warsha_commerce/features/feedback/presentation/widgets/home_testimonials_section.dart';
import 'package:warsha_commerce/features/home/domain/entities/home_banner.dart';
import 'package:warsha_commerce/features/home/presentation/cubit/home_cubit.dart';
import 'package:warsha_commerce/features/home/presentation/cubit/home_state.dart';
import 'package:warsha_commerce/features/home/presentation/widgets/best_sellers_shelf.dart';
import 'package:warsha_commerce/features/home/presentation/widgets/category_chips_bar.dart';
import 'package:warsha_commerce/features/home/presentation/widgets/gift_edit_promo_band.dart';
import 'package:warsha_commerce/features/home/presentation/widgets/hero_banner_carousel.dart';
import 'package:warsha_commerce/features/home/presentation/widgets/home_drawer.dart';
import 'package:warsha_commerce/features/home/presentation/widgets/home_footer.dart';
import 'package:warsha_commerce/features/home/presentation/widgets/home_header.dart';
import 'package:warsha_commerce/features/home/presentation/widgets/new_arrivals_shelf.dart';
import 'package:warsha_commerce/features/home/presentation/widgets/shelf_states.dart';
import 'package:warsha_commerce/features/home/presentation/widgets/shop_by_category_section.dart';
import 'package:warsha_commerce/features/home/presentation/widgets/trust_row.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<HomeCubit>(
          create: (_) => sl<HomeCubit>()..loadAll(),
        ),
        BlocProvider<TestimonialsCubit>(
          create: (_) => sl<TestimonialsCubit>()..loadFeaturedTestimonials(),
        ),
      ],
      child: const _HomePageContent(),
    );
  }
}

class _HomePageContent extends StatefulWidget {
  const _HomePageContent();

  @override
  State<_HomePageContent> createState() => _HomePageContentState();
}

class _HomePageContentState extends State<_HomePageContent> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.ivory,
      drawer: const HomeDrawer(),
      appBar: HomeHeader(
        onOpenDrawer: () => _scaffoldKey.currentState?.openDrawer(),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: Breakpoints.maxContentWidth,
                ),
                child: Padding(
                  padding: const EdgeInsetsDirectional.symmetric(
                    horizontal: AppSpacing.s24,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: AppSpacing.s24),

                      // 1. Hero banner carousel
                      BlocSelector<
                        HomeCubit,
                        HomeState,
                        (ShelfStatus, List<HomeBanner>, String?)
                      >(
                        selector: (state) => (
                          state.bannersStatus,
                          state.banners,
                          state.bannersError,
                        ),
                        builder: (context, data) {
                          final (status, banners, error) = data;
                          switch (status) {
                            case ShelfStatus.initial:
                            case ShelfStatus.loading:
                              return const ShelfSkeleton(
                                height: 380,
                                itemCount: 1,
                              );
                            case ShelfStatus.failure:
                              return ShelfErrorView(
                                message: error ?? 'Failed to load banners',
                                onRetry: () =>
                                    context.read<HomeCubit>().loadBanners(),
                              );
                            case ShelfStatus.success:
                              return HeroBannerCarousel(banners: banners);
                          }
                        },
                      ),

                      const SizedBox(height: AppSpacing.s32),

                      // 2. Category filter chips
                      BlocSelector<
                        HomeCubit,
                        HomeState,
                        (List<Category>, int?)
                      >(
                        selector: (state) =>
                            (state.categories, state.selectedCategoryId),
                        builder: (context, data) {
                          final (categories, selectedId) = data;
                          if (categories.isEmpty) {
                            return const SizedBox.shrink();
                          }
                          return CategoryChipsBar(
                            categories: categories,
                            selectedCategoryId: selectedId,
                          );
                        },
                      ),

                      const SizedBox(height: AppSpacing.s32),

                      // 3. New arrivals shelf
                      const NewArrivalsShelf(),

                      const SizedBox(height: AppSpacing.s48),

                      // 4. Best sellers shelf
                      const BestSellersShelf(),

                      const SizedBox(height: AppSpacing.s48),

                      // 5. Shop by category tiles
                      const ShopByCategorySection(),

                      const SizedBox(height: AppSpacing.s48),

                      // 6. The gift edit promo band
                      const GiftEditPromoBand(),

                      const SizedBox(height: AppSpacing.s48),

                      // 7. Customer Feedbacks & Testimonials (To build trust with store visitors)
                      const HomeTestimonialsSection(),

                      const SizedBox(height: AppSpacing.s48),

                      // 8. Trust row
                      const TrustRow(),

                      const SizedBox(height: AppSpacing.s48),
                    ],
                  ),
                ),
              ),
            ),

            // 9. Footer
            const HomeFooter(),
          ],
        ),
      ),
    );
  }
}
