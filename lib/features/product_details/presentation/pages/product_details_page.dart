import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

import 'package:warsha_commerce/core/l10n/product_text.dart';
import 'package:warsha_commerce/core/di/di.dart';
import 'package:warsha_commerce/core/l10n/app_strings.dart';
import 'package:warsha_commerce/core/theme/app_colors.dart';
import 'package:warsha_commerce/core/theme/app_spacing.dart';
import 'package:warsha_commerce/core/utils/breakpoints.dart';
import 'package:warsha_commerce/core/widgets/app_text.dart';
import 'package:warsha_commerce/core/widgets/error_view.dart';
import 'package:warsha_commerce/core/widgets/loading_view.dart';
import 'package:warsha_commerce/features/catalog/domain/entities/product.dart';
import 'package:warsha_commerce/features/home/presentation/widgets/home_drawer.dart';
import 'package:warsha_commerce/features/home/presentation/widgets/home_footer.dart';
import 'package:warsha_commerce/features/home/presentation/widgets/home_header.dart';
import 'package:warsha_commerce/features/product_details/presentation/cubit/product_details_cubit.dart';
import 'package:warsha_commerce/features/product_details/presentation/cubit/product_details_state.dart';
import 'package:warsha_commerce/features/product_details/presentation/widgets/product_actions_section.dart';
import 'package:warsha_commerce/features/product_details/presentation/widgets/product_details_tabs.dart';
import 'package:warsha_commerce/features/product_details/presentation/widgets/product_gallery_view.dart';
import 'package:warsha_commerce/features/product_details/presentation/widgets/product_info_section.dart';
import 'package:warsha_commerce/features/product_details/presentation/widgets/product_trust_card.dart';
import 'package:warsha_commerce/features/product_details/presentation/widgets/related_products_section.dart';

class ProductDetailsPage extends StatelessWidget {
  final int productId;

  const ProductDetailsPage({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProductDetailsCubit>(
      key: ValueKey('product_details_$productId'),
      create: (_) => sl<ProductDetailsCubit>()..loadProduct(productId),
      child: _ProductDetailsContent(productId: productId),
    );
  }
}

class _ProductDetailsContent extends StatefulWidget {
  final int productId;

  const _ProductDetailsContent({required this.productId});

  @override
  State<_ProductDetailsContent> createState() => _ProductDetailsContentState();
}

class _ProductDetailsContentState extends State<_ProductDetailsContent> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void didUpdateWidget(covariant _ProductDetailsContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.productId != widget.productId) {
      context.read<ProductDetailsCubit>().loadProduct(widget.productId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.ivory,
      drawer: const HomeDrawer(),
      appBar: HomeHeader(
        onOpenDrawer: () => _scaffoldKey.currentState?.openDrawer(),
      ),
      body: BlocBuilder<ProductDetailsCubit, ProductDetailsState>(
        builder: (context, state) {
          switch (state.status) {
            case ProductDetailsStatus.initial:
            case ProductDetailsStatus.loading:
              return const Center(child: LoadingView());

            case ProductDetailsStatus.failure:
              return Center(
                child: Padding(
                  padding: const EdgeInsetsDirectional.all(AppSpacing.s24),
                  child: ErrorView(
                    message: state.errorMessage ?? AppStrings.productNotFound,
                    onRetry: () => context
                        .read<ProductDetailsCubit>()
                        .loadProduct(widget.productId),
                  ),
                ),
              );

            case ProductDetailsStatus.success:
              final product = state.product;
              if (product == null) {
                return Center(
                  child: ErrorView(
                    message: AppStrings.productNotFound,
                    onRetry: () => context
                        .read<ProductDetailsCubit>()
                        .loadProduct(widget.productId),
                  ),
                );
              }

              return SingleChildScrollView(
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
                              const SizedBox(height: AppSpacing.s16),

                              // Breadcrumb navigation
                              _buildBreadcrumbs(context, product),

                              const SizedBox(height: AppSpacing.s16),

                              // Responsive Layout (Desktop 2-column, Mobile 1-column)
                              LayoutBuilder(
                                builder: (context, constraints) {
                                  final isDesktop = constraints.maxWidth >= 840;
                                  if (isDesktop) {
                                    return _buildDesktopLayout(product);
                                  } else {
                                    return _buildMobileLayout(product);
                                  }
                                },
                              ),

                              const SizedBox(height: AppSpacing.s48),

                              // Related products shelf
                              RelatedProductsSection(
                                products: state.relatedProducts,
                              ),

                              const SizedBox(height: AppSpacing.s48),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Store Footer
                    const HomeFooter(),
                  ],
                ),
              );
          }
        },
      ),
    );
  }

  Widget _buildBreadcrumbs(BuildContext context, Product product) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: AppSpacing.s8,
      children: [
        IconButton(
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/');
            }
          },
          tooltip: AppStrings.back,
          icon: Icon(
            isRtl ? Iconsax.arrow_right_3 : Iconsax.arrow_left_2,
            size: 20,
            color: AppColors.burgundy,
          ),
          padding: EdgeInsetsDirectional.zero,
          constraints: const BoxConstraints(),
        ),
        const SizedBox(width: AppSpacing.s4),
        InkWell(
          onTap: () => context.go('/'),
          borderRadius: BorderRadius.circular(4),
          child: const Padding(
            padding: EdgeInsetsDirectional.symmetric(
              horizontal: 4,
              vertical: 2,
            ),
            child: AppText.caption(
              AppStrings.home,
              color: AppColors.muted,
              weight: FontWeight.w600,
            ),
          ),
        ),
        const AppText.caption('/', color: AppColors.line),
        AppText.caption(
          product.categoryName,
          color: AppColors.muted,
          weight: FontWeight.w600,
        ),
        const AppText.caption('/', color: AppColors.line),
        AppText.caption(
          product.localizedName(context),
          color: AppColors.deepWine,
          weight: FontWeight.w700,
          maxLines: 1,
        ),
      ],
    );
  }

  Widget _buildDesktopLayout(Product product) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left Column (Gallery & Trust Card)
        Expanded(
          flex: 5,
          child: Column(
            children: [
              ProductGalleryView(product: product),
              const SizedBox(height: AppSpacing.s24),
              const ProductTrustCard(),
            ],
          ),
        ),

        const SizedBox(width: AppSpacing.s32),

        // Right Column (Info, Stepper, Add to Cart, Tabs)
        Expanded(
          flex: 6,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProductInfoSection(product: product),
              const SizedBox(height: AppSpacing.s24),
              ProductActionsSection(product: product),
              const SizedBox(height: AppSpacing.s24),
              ProductDetailsTabs(product: product),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(Product product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ProductGalleryView(product: product),
        const SizedBox(height: AppSpacing.s16),
        ProductInfoSection(product: product),
        const SizedBox(height: AppSpacing.s16),
        ProductActionsSection(product: product),
        const SizedBox(height: AppSpacing.s16),
        const ProductTrustCard(),
        const SizedBox(height: AppSpacing.s16),
        ProductDetailsTabs(product: product),
      ],
    );
  }
}
