import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:warsha_commerce/features/shipping/presentation/cubit/shipping_cubit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

import 'package:warsha_commerce/core/l10n/app_strings.dart';
import 'package:warsha_commerce/core/theme/app_colors.dart';
import 'package:warsha_commerce/core/theme/app_spacing.dart';
import 'package:warsha_commerce/core/utils/breakpoints.dart';
import 'package:warsha_commerce/core/widgets/error_view.dart';
import 'package:warsha_commerce/core/widgets/loading_view.dart';
import 'package:warsha_commerce/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:warsha_commerce/features/cart/presentation/cubit/cart_state.dart';
import 'package:warsha_commerce/features/cart/presentation/widgets/cart_empty_view.dart';
import 'package:warsha_commerce/features/cart/presentation/widgets/cart_item_tile.dart';
import 'package:warsha_commerce/features/cart/presentation/widgets/cart_summary_card.dart';
import 'package:warsha_commerce/features/cart/presentation/widgets/promo_code_bar.dart';
import 'package:warsha_commerce/features/home/presentation/widgets/home_drawer.dart';
import 'package:warsha_commerce/features/home/presentation/widgets/home_footer.dart';
import 'package:warsha_commerce/features/home/presentation/widgets/home_header.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    // Delivery prices are edited in the ERP: show the current ones
    context.read<ShippingCubit>().refresh();
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
                    vertical: AppSpacing.s32,
                  ),
                  child: BlocBuilder<CartCubit, CartState>(
                    builder: (context, state) {
                      switch (state.status) {
                        case CartStatus.initial:
                        case CartStatus.loading:
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 80.0),
                            child: LoadingView(),
                          );
                        case CartStatus.failure:
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 60.0),
                            child: ErrorView(
                              message:
                                  state.errorMessage ?? AppStrings.loadingError,
                              onRetry: () =>
                                  context.read<CartCubit>().loadCart(),
                            ),
                          );
                        case CartStatus.success:
                          if (state.isEmpty) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 40.0),
                              child: CartEmptyView(),
                            );
                          }

                          return _buildCartContent(context, state);
                      }
                    },
                  ),
                ),
              ),
            ),
            const HomeFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildCartContent(BuildContext context, CartState state) {
    final isDesktop = MediaQuery.of(context).size.width >= 900;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Page Heading Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Text(
                  AppStrings.cartTitle,
                  style: GoogleFonts.cairo(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: AppColors.deepWine,
                  ),
                ),
                const SizedBox(width: AppSpacing.s12),
                Container(
                  padding: const EdgeInsetsDirectional.symmetric(
                    horizontal: 10,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.blush,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.line),
                  ),
                  child: Text(
                    '${state.itemCount} ${AppStrings.itemsCount}',
                    style: GoogleFonts.cairo(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.burgundy,
                    ),
                  ),
                ),
              ],
            ),
            TextButton.icon(
              onPressed: () => context.read<CartCubit>().clearCart(),
              icon: const Icon(Iconsax.trash, size: 18, color: AppColors.muted),
              label: Text(
                AppStrings.clearCart,
                style: GoogleFonts.cairo(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.muted,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.s24),

        // Layout: 2 Columns for Desktop, 1 Column for Mobile
        if (isDesktop)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Items List & Promo Code (Flexible 6)
              Expanded(
                flex: 6,
                child: Column(
                  children: [
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: state.items.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: AppSpacing.s16),
                      itemBuilder: (context, index) {
                        return CartItemTile(item: state.items[index]);
                      },
                    ),
                    const SizedBox(height: AppSpacing.s24),
                    const PromoCodeBar(),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.s32),

              // Order Summary Sticky Card (Flexible 4)
              const Expanded(flex: 4, child: CartSummaryCard()),
            ],
          )
        else
          Column(
            children: [
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: state.items.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: AppSpacing.s12),
                itemBuilder: (context, index) {
                  return CartItemTile(item: state.items[index]);
                },
              ),
              const SizedBox(height: AppSpacing.s16),
              const PromoCodeBar(),
              const SizedBox(height: AppSpacing.s24),
              const CartSummaryCard(),
            ],
          ),
      ],
    );
  }
}
