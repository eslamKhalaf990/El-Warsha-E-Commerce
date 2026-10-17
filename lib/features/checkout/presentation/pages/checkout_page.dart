import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

import 'package:warsha_commerce/core/di/di.dart';
import 'package:warsha_commerce/core/l10n/app_strings.dart';
import 'package:warsha_commerce/core/theme/app_colors.dart';
import 'package:warsha_commerce/core/theme/app_spacing.dart';
import 'package:warsha_commerce/core/utils/breakpoints.dart';
import 'package:warsha_commerce/core/widgets/app_button.dart';
import 'package:warsha_commerce/core/widgets/app_text.dart';
import 'package:warsha_commerce/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:warsha_commerce/features/cart/presentation/cubit/cart_state.dart';
import 'package:warsha_commerce/features/checkout/presentation/cubit/checkout_cubit.dart';
import 'package:warsha_commerce/features/checkout/presentation/cubit/checkout_state.dart';
import 'package:warsha_commerce/features/checkout/presentation/widgets/checkout_items_preview.dart';
import 'package:warsha_commerce/features/checkout/presentation/widgets/checkout_payment_selector.dart';
import 'package:warsha_commerce/features/checkout/presentation/widgets/checkout_shipping_form.dart';
import 'package:warsha_commerce/features/checkout/presentation/widgets/checkout_summary_card.dart';
import 'package:warsha_commerce/features/home/presentation/widgets/home_drawer.dart';
import 'package:warsha_commerce/features/home/presentation/widgets/home_footer.dart';
import 'package:warsha_commerce/features/home/presentation/widgets/home_header.dart';

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CheckoutCubit>(
      create: (_) => sl<CheckoutCubit>()..initCheckout(),
      child: const _CheckoutPageContent(),
    );
  }
}

class _CheckoutPageContent extends StatefulWidget {
  const _CheckoutPageContent();

  @override
  State<_CheckoutPageContent> createState() => _CheckoutPageContentState();
}

class _CheckoutPageContentState extends State<_CheckoutPageContent> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return BlocListener<CheckoutCubit, CheckoutState>(
      listenWhen: (previous, current) =>
          previous.status != current.status &&
          current.status == CheckoutStatus.success &&
          current.placedOrder != null,
      listener: (context, state) {
        // Clear global cart after placing order
        context.read<CartCubit>().clearCart();

        // Navigate to confirmation page
        context.go('/order-confirmation', extra: state.placedOrder);
      },
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: AppColors.ivory,
        drawer: const HomeDrawer(),
        appBar: HomeHeader(
          onOpenDrawer: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        body: BlocBuilder<CartCubit, CartState>(
          builder: (context, cartState) {
            if (cartState.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.s32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Iconsax.shopping_bag,
                        size: 56,
                        color: AppColors.muted,
                      ),
                      const SizedBox(height: AppSpacing.s16),
                      const AppText.title(
                        AppStrings.cartEmptyError,
                        color: AppColors.deepWine,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      AppButton.primary(
                        label: AppStrings.continueShopping,
                        onPressed: () => context.go('/'),
                      ),
                    ],
                  ),
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
                          vertical: AppSpacing.s32,
                        ),
                        child: BlocBuilder<CheckoutCubit, CheckoutState>(
                          builder: (context, checkoutState) {
                            return _buildCheckoutContent(
                              context,
                              checkoutState,
                              cartState,
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  const HomeFooter(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCheckoutContent(
    BuildContext context,
    CheckoutState checkoutState,
    CartState cartState,
  ) {
    final cubit = context.read<CheckoutCubit>();
    final isDesktop = MediaQuery.of(context).size.width >= 900;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Stepper / Breadcrumbs
        _buildBreadcrumbs(context),
        const SizedBox(height: AppSpacing.s24),

        // Page Title
        Text(
          AppStrings.checkoutTitle,
          style: GoogleFonts.cairo(
            fontSize: 26,
            fontWeight: FontWeight.w800,
            color: AppColors.deepWine,
          ),
        ),
        const SizedBox(height: AppSpacing.s24),

        // Layout
        if (isDesktop)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left: Forms & Preview (60%)
              Expanded(
                flex: 6,
                child: Column(
                  children: [
                    CheckoutShippingForm(state: checkoutState, cubit: cubit),
                    const SizedBox(height: AppSpacing.s24),
                    CheckoutPaymentSelector(state: checkoutState, cubit: cubit),
                    const SizedBox(height: AppSpacing.s24),
                    CheckoutItemsPreview(items: cartState.items),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.s32),

              // Right: Summary & Confirmation (40%)
              Expanded(
                flex: 4,
                child: CheckoutSummaryCard(
                  state: checkoutState,
                  subtotal: cartState.subtotal,
                  discount: cartState.discount,
                  onSubmit: () => cubit.submitOrder(
                    cartItems: cartState.items,
                    subtotal: cartState.subtotal,
                    discount: cartState.discount,
                  ),
                ),
              ),
            ],
          )
        else
          Column(
            children: [
              CheckoutItemsPreview(items: cartState.items),
              const SizedBox(height: AppSpacing.s16),
              CheckoutShippingForm(state: checkoutState, cubit: cubit),
              const SizedBox(height: AppSpacing.s16),
              CheckoutPaymentSelector(state: checkoutState, cubit: cubit),
              const SizedBox(height: AppSpacing.s24),
              CheckoutSummaryCard(
                state: checkoutState,
                subtotal: cartState.subtotal,
                discount: cartState.discount,
                onSubmit: () => cubit.submitOrder(
                  cartItems: cartState.items,
                  subtotal: cartState.subtotal,
                  discount: cartState.discount,
                ),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildBreadcrumbs(BuildContext context) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return Row(
      children: [
        InkWell(
          onTap: () => context.push('/cart'),
          child: Row(
            children: [
              const Icon(
                Iconsax.shopping_bag,
                size: 16,
                color: AppColors.burgundy,
              ),
              const SizedBox(width: 4),
              Text(
                AppStrings.cartTitle,
                style: GoogleFonts.cairo(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.burgundy,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Icon(
          isRtl ? Iconsax.arrow_left_2 : Iconsax.arrow_right_3,
          size: 12,
          color: AppColors.muted,
        ),
        const SizedBox(width: 8),
        Text(
          AppStrings.checkoutTitle,
          style: GoogleFonts.cairo(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: AppColors.deepWine,
          ),
        ),
      ],
    );
  }
}
