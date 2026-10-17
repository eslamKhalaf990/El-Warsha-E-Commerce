import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

import 'package:warsha_commerce/core/di/di.dart';
import 'package:warsha_commerce/core/l10n/app_strings.dart';
import 'package:warsha_commerce/core/theme/app_colors.dart';
import 'package:warsha_commerce/core/theme/app_radius.dart';
import 'package:warsha_commerce/core/theme/app_spacing.dart';
import 'package:warsha_commerce/core/utils/breakpoints.dart';
import 'package:warsha_commerce/core/widgets/app_chip.dart';
import 'package:warsha_commerce/core/widgets/app_container.dart';
import 'package:warsha_commerce/core/widgets/app_text.dart';
import 'package:warsha_commerce/core/widgets/empty_view.dart';
import 'package:warsha_commerce/core/widgets/error_view.dart';
import 'package:warsha_commerce/features/catalog/domain/entities/category.dart';
import 'package:warsha_commerce/features/catalog/presentation/cubit/catalog_cubit.dart';
import 'package:warsha_commerce/features/catalog/presentation/cubit/catalog_state.dart';
import 'package:warsha_commerce/features/home/presentation/widgets/home_drawer.dart';
import 'package:warsha_commerce/features/home/presentation/widgets/home_footer.dart';
import 'package:warsha_commerce/features/home/presentation/widgets/home_header.dart';
import 'package:warsha_commerce/features/home/presentation/widgets/product_card.dart';
import 'package:warsha_commerce/features/home/presentation/widgets/shelf_states.dart';

class CatalogPage extends StatelessWidget {
  final int? initialCategoryId;
  final String? initialQuery;

  const CatalogPage({super.key, this.initialCategoryId, this.initialQuery});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CatalogCubit>(
      key: ValueKey('catalog_${initialCategoryId}_$initialQuery'),
      create: (_) => sl<CatalogCubit>()
        ..loadCatalog(
          initialCategoryId: initialCategoryId,
          initialQuery: initialQuery,
        ),
      child: _CatalogContent(
        initialCategoryId: initialCategoryId,
        initialQuery: initialQuery,
      ),
    );
  }
}

class _CatalogContent extends StatefulWidget {
  final int? initialCategoryId;
  final String? initialQuery;

  const _CatalogContent({this.initialCategoryId, this.initialQuery});

  @override
  State<_CatalogContent> createState() => _CatalogContentState();
}

class _CatalogContentState extends State<_CatalogContent> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.initialQuery ?? '');
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  int _getCrossAxisCount(double width) {
    if (width >= Breakpoints.desktop) return 4;
    if (width >= Breakpoints.mobile) return 3;
    return 2;
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
                      const SizedBox(height: AppSpacing.s16),

                      // 1. Breadcrumbs
                      _buildBreadcrumbs(context),

                      const SizedBox(height: AppSpacing.s24),

                      // 2. Banner Header
                      _buildHeaderBanner(context),

                      const SizedBox(height: AppSpacing.s24),

                      // 3. Search Bar
                      _buildSearchBar(context),

                      const SizedBox(height: AppSpacing.s16),

                      // 4. Category Filter Chips & Sort Controls
                      _buildFilterAndSortRow(context),

                      const SizedBox(height: AppSpacing.s24),

                      // 5. Products Grid or State View
                      _buildGridSection(context),

                      const SizedBox(height: AppSpacing.s48),
                    ],
                  ),
                ),
              ),
            ),

            // Footer
            const HomeFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildBreadcrumbs(BuildContext context) {
    return BlocBuilder<CatalogCubit, CatalogState>(
      buildWhen: (prev, curr) =>
          prev.selectedCategoryId != curr.selectedCategoryId ||
          prev.categories != curr.categories,
      builder: (context, state) {
        Category? selectedCat;
        if (state.selectedCategoryId != null) {
          try {
            selectedCat = state.categories.firstWhere(
              (c) => c.id == state.selectedCategoryId,
            );
          } catch (_) {}
        }

        return Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: AppSpacing.s8,
          children: [
            InkWell(
              onTap: () => context.go('/'),
              borderRadius: BorderRadius.circular(AppRadius.pill),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                child: AppText.caption(
                  AppStrings.home,
                  color: AppColors.muted,
                  weight: FontWeight.w600,
                ),
              ),
            ),
            const AppText.caption('/', color: AppColors.line),
            InkWell(
              onTap: () => context.read<CatalogCubit>().selectCategory(null),
              borderRadius: BorderRadius.circular(AppRadius.pill),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                child: AppText.caption(
                  AppStrings.shop,
                  color: selectedCat == null
                      ? AppColors.deepWine
                      : AppColors.muted,
                  weight: selectedCat == null
                      ? FontWeight.w700
                      : FontWeight.w600,
                ),
              ),
            ),
            if (selectedCat != null) ...[
              const AppText.caption('/', color: AppColors.line),
              AppText.caption(
                selectedCat.name,
                color: AppColors.deepWine,
                weight: FontWeight.w700,
              ),
            ],
          ],
        );
      },
    );
  }

  Widget _buildHeaderBanner(BuildContext context) {
    return BlocBuilder<CatalogCubit, CatalogState>(
      buildWhen: (prev, curr) =>
          prev.selectedCategoryId != curr.selectedCategoryId ||
          prev.categories != curr.categories,
      builder: (context, state) {
        String title = 'تشكيلة الإكسسوارات الفاخرة';
        String subtitle =
            'مصوغات يدوية استثنائية صُممت بعناية لتناسب ذوقك الرفيع في كل إطلالة';

        if (state.selectedCategoryId != null) {
          try {
            final cat = state.categories.firstWhere(
              (c) => c.id == state.selectedCategoryId,
            );
            title = cat.name;
            if (cat.description != null && cat.description!.isNotEmpty) {
              subtitle = cat.description!;
            }
          } catch (_) {}
        }

        return AppContainer.blush(
          padding: const EdgeInsetsDirectional.all(AppSpacing.s32),
          radius: AppRadius.card,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText.display(title, color: AppColors.deepWine),
              const SizedBox(height: AppSpacing.s8),
              AppText.body(
                subtitle,
                color: AppColors.ink.withValues(alpha: 0.8),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(color: AppColors.line, width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColors.deepWine.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (val) {
          context.read<CatalogCubit>().onSearchChanged(val);
          setState(() {});
        },
        decoration: InputDecoration(
          hintText: AppStrings.searchPlaceholder,
          hintStyle: const TextStyle(
            fontFamily: 'Cairo',
            fontSize: 14,
            color: AppColors.muted,
          ),
          prefixIcon: const Icon(
            Iconsax.search_normal_1,
            color: AppColors.burgundy,
            size: 20,
          ),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(
                    Iconsax.close_circle,
                    color: AppColors.muted,
                    size: 18,
                  ),
                  onPressed: () {
                    _searchController.clear();
                    context.read<CatalogCubit>().onSearchChanged('');
                    setState(() {});
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsetsDirectional.symmetric(
            horizontal: AppSpacing.s16,
            vertical: AppSpacing.s12,
          ),
        ),
      ),
    );
  }

  Widget _buildFilterAndSortRow(BuildContext context) {
    final isDesktop = context.isDesktop;

    return BlocBuilder<CatalogCubit, CatalogState>(
      buildWhen: (prev, curr) =>
          prev.categories != curr.categories ||
          prev.selectedCategoryId != curr.selectedCategoryId ||
          prev.sortOption != curr.sortOption ||
          prev.displayedProducts.length != curr.displayedProducts.length,
      builder: (context, state) {
        final categoryChips = SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              AppChip(
                label: AppStrings.allCategories,
                isSelected: state.selectedCategoryId == null,
                onTap: () => context.read<CatalogCubit>().selectCategory(null),
              ),
              const SizedBox(width: AppSpacing.s8),
              ...state.categories.map((cat) {
                final isSelected = state.selectedCategoryId == cat.id;
                return Padding(
                  padding: const EdgeInsetsDirectional.only(end: AppSpacing.s8),
                  child: AppChip(
                    label: cat.name,
                    isSelected: isSelected,
                    onTap: () =>
                        context.read<CatalogCubit>().selectCategory(cat.id),
                  ),
                );
              }),
            ],
          ),
        );

        final sortDropdown = Container(
          padding: const EdgeInsetsDirectional.symmetric(
            horizontal: AppSpacing.s12,
            vertical: AppSpacing.s4,
          ),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppRadius.pill),
            border: Border.all(color: AppColors.line),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<CatalogSortOption>(
              value: state.sortOption,
              icon: const Icon(
                Iconsax.arrow_down_1,
                size: 16,
                color: AppColors.burgundy,
              ),
              dropdownColor: AppColors.white,
              borderRadius: BorderRadius.circular(AppRadius.card),
              items: const [
                DropdownMenuItem(
                  value: CatalogSortOption.newest,
                  child: AppText.caption(
                    'الأحدث أولاً',
                    weight: FontWeight.w600,
                  ),
                ),
                DropdownMenuItem(
                  value: CatalogSortOption.priceLowToHigh,
                  child: AppText.caption(
                    'السعر: الأقل للأعلى',
                    weight: FontWeight.w600,
                  ),
                ),
                DropdownMenuItem(
                  value: CatalogSortOption.priceHighToLow,
                  child: AppText.caption(
                    'السعر: الأعلى للأقل',
                    weight: FontWeight.w600,
                  ),
                ),
                DropdownMenuItem(
                  value: CatalogSortOption.discount,
                  child: AppText.caption('أكبر خصم', weight: FontWeight.w600),
                ),
              ],
              onChanged: (newOption) {
                if (newOption != null) {
                  context.read<CatalogCubit>().setSortOption(newOption);
                }
              },
            ),
          ),
        );

        if (isDesktop) {
          return Row(
            children: [
              Expanded(child: categoryChips),
              const SizedBox(width: AppSpacing.s16),
              sortDropdown,
            ],
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            categoryChips,
            const SizedBox(height: AppSpacing.s12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppText.caption(
                  '${state.displayedProducts.length} قطعة',
                  color: AppColors.muted,
                  weight: FontWeight.w600,
                ),
                sortDropdown,
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildGridSection(BuildContext context) {
    return BlocBuilder<CatalogCubit, CatalogState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const ShelfSkeleton(
            height: 320,
            itemCount: 8,
            isHorizontal: false,
          );
        }

        if (state.isFailure) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.s48),
            child: ErrorView(
              message: state.errorMessage ?? AppStrings.loadingError,
              onRetry: () => context.read<CatalogCubit>().loadCatalog(
                initialCategoryId: state.selectedCategoryId,
                initialQuery: state.searchQuery,
              ),
            ),
          );
        }

        if (state.displayedProducts.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.s48),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                EmptyView(
                  icon: Iconsax.search_status,
                  message: state.searchQuery.isNotEmpty
                      ? AppStrings.emptySearch(state.searchQuery)
                      : 'مفيش منتجات متوفرة حالياً في الفئة دي',
                ),
                const SizedBox(height: AppSpacing.s16),
                OutlinedButton(
                  onPressed: () {
                    _searchController.clear();
                    context.read<CatalogCubit>().clearFilters();
                    setState(() {});
                  },
                  child: const Text('إعادة ضبط التصفية'),
                ),
              ],
            ),
          );
        }

        final width = MediaQuery.of(context).size.width;
        final crossAxisCount = _getCrossAxisCount(width);
        final double childAspectRatio = width >= Breakpoints.desktop
            ? 0.65
            : (width >= Breakpoints.mobile ? 0.60 : 0.54);

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: state.displayedProducts.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: AppSpacing.s16,
            mainAxisSpacing: AppSpacing.s16,
            childAspectRatio: childAspectRatio,
          ),
          itemBuilder: (context, index) {
            final product = state.displayedProducts[index];
            return ProductCard(product: product);
          },
        );
      },
    );
  }
}
