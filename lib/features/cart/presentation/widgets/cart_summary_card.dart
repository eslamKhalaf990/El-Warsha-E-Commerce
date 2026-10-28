import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

import 'package:warsha_commerce/core/l10n/app_strings.dart';
import 'package:warsha_commerce/core/theme/app_colors.dart';
import 'package:warsha_commerce/core/theme/app_radius.dart';
import 'package:warsha_commerce/core/theme/app_spacing.dart';
import 'package:warsha_commerce/core/utils/money.dart';
import 'package:warsha_commerce/core/widgets/app_button.dart';
import 'package:warsha_commerce/core/widgets/app_container.dart';
import 'package:warsha_commerce/core/widgets/app_text.dart';
import 'package:warsha_commerce/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:warsha_commerce/features/auth/presentation/cubit/auth_state.dart';
import 'package:warsha_commerce/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:warsha_commerce/features/cart/presentation/cubit/cart_state.dart';
import 'package:warsha_commerce/features/shipping/presentation/cubit/shipping_cubit.dart';
import 'package:warsha_commerce/features/shipping/presentation/cubit/shipping_state.dart';

class CartSummaryCard extends StatelessWidget {
  const CartSummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, authState) {
        final customerGov = authState.customer?.governorate ?? '';


        return BlocBuilder<ShippingCubit, ShippingState>(
          builder: (context, shippingState) {
            return BlocBuilder<CartCubit, CartState>(
              builder: (context, cartState) {
                final isShippingLoading = shippingState.isLoading;
                // Until the customer has a governorate, show the first one in the live list
                final govName = customerGov.isNotEmpty
                    ? customerGov
                    : (shippingState.governorateNames.firstOrNull ?? '');
                final knownFeeMinor = cartState.isEmpty
                    ? 0
                    : shippingState.getMinorPriceFor(govName);
                final deliveryFeeMinor = knownFeeMinor ?? 0;
                final isFreeShipping = knownFeeMinor == 0;
                const freeShippingGoal = 100000; // 1,000 EGP
                final remainingForFreeShipping =
                    freeShippingGoal - cartState.subtotal;

                final totalAmount = cartState.isEmpty
                    ? 0
                    : (cartState.subtotal - cartState.discount + deliveryFeeMinor)
                        .clamp(0, 999999999);

                return AppContainer.surface(
                  radius: AppRadius.card,
                  padding: const EdgeInsetsDirectional.all(AppSpacing.s24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Header
                      AppText.title(
                        strings.orderSummary,
                        weight: FontWeight.w700,
                        color: AppColors.deepWine,
                      ),
                      const SizedBox(height: AppSpacing.s16),

                      // Free shipping progress indicator
                      if (remainingForFreeShipping > 0) ...[
                        Container(
                          padding: const EdgeInsetsDirectional.all(
                            AppSpacing.s12,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.blush,
                            borderRadius: BorderRadius.circular(
                              AppRadius.card,
                            ),
                            border: Border.all(color: AppColors.line),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Iconsax.truck_fast,
                                    size: 16,
                                    color: AppColors.burgundy,
                                  ),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      AppStrings.freeShippingRemaining(
                                        MoneyUtils.formatMinor(
                                          remainingForFreeShipping,
                                        ),
                                      ),
                                      style: GoogleFonts.cairo(
                                        fontSize: 11.5,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.burgundy,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: AppSpacing.s8),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(
                                  AppRadius.pill,
                                ),
                                child: LinearProgressIndicator(
                                  value: (cartState.subtotal / freeShippingGoal)
                                      .clamp(0.0, 1.0),
                                  backgroundColor: AppColors.white,
                                  valueColor:
                                      const AlwaysStoppedAnimation<Color>(
                                        AppColors.burgundy,
                                      ),
                                  minHeight: 6,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppSpacing.s16),
                      ] else ...[
                        Container(
                          padding: const EdgeInsetsDirectional.all(10.0),
                          decoration: BoxDecoration(
                            color: AppStatusColors.successBackground,
                            borderRadius: BorderRadius.circular(
                              AppRadius.card,
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Iconsax.magic_star,
                                size: 16,
                                color: AppStatusColors.successText,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                AppStrings.freeShippingEligible,
                                style: GoogleFonts.cairo(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w700,
                                  color: AppStatusColors.successText,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppSpacing.s16),
                      ],

                      // Breakdown rows
                      _buildPriceRow(
                        label: strings.subtotal,
                        value: MoneyUtils.formatMinor(cartState.subtotal),
                      ),
                      const SizedBox(height: AppSpacing.s12),

                      _buildPriceRow(
                        label: govName.isEmpty
                            ? strings.shippingFee
                            : '${strings.shippingFee} ($govName)',
                        valueWidget: isShippingLoading
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.burgundy,
                                ),
                              )
                            : knownFeeMinor == null
                            ? Text(
                                '—',
                                style: GoogleFonts.cairo(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.muted,
                                ),
                              )
                            : isFreeShipping
                            ? Container(
                                padding: const EdgeInsetsDirectional.symmetric(
                                  horizontal: AppSpacing.s8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: AppStatusColors.successBackground,
                                  borderRadius: BorderRadius.circular(
                                    AppRadius.pill,
                                  ),
                                ),
                                child: Text(
                                  strings.freeShipping,
                                  style: GoogleFonts.cairo(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w700,
                                    color: AppStatusColors.successText,
                                  ),
                                ),
                              )
                            : Text(
                                MoneyUtils.formatMinor(deliveryFeeMinor),
                                style: GoogleFonts.cairo(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.ink,
                                ),
                              ),
                      ),

                      if (cartState.discount > 0) ...[
                        const SizedBox(height: AppSpacing.s12),
                        _buildPriceRow(
                          label: strings.discount,
                          value:
                              '- ${MoneyUtils.formatMinor(cartState.discount)}',
                          valueColor: AppColors.burgundy,
                        ),
                      ],

                      const Padding(
                        padding: EdgeInsetsDirectional.symmetric(
                          vertical: AppSpacing.s16,
                        ),
                        child: Divider(color: AppColors.line),
                      ),

                      // Total Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            strings.total,
                            style: GoogleFonts.cairo(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: AppColors.deepWine,
                            ),
                          ),
                          Text(
                            MoneyUtils.formatMinor(totalAmount),
                            style: GoogleFonts.cairo(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              color: AppColors.burgundy,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.s24),

                      // Checkout CTA Button (Continue to checkout | كمّل طلبك)
                      AppButton.primary(
                        label: AppStrings.continueToCheckout,
                        height: 52,
                        trailingIcon: Icon(
                          isRtl ? Iconsax.arrow_left_2 : Iconsax.arrow_right_3,
                          size: 20,
                          color: AppColors.white,
                        ),
                        onPressed: cartState.isEmpty
                            ? null
                            : () => context.push('/checkout'),
                      ),
                      const SizedBox(height: AppSpacing.s16),

                      // Trust badges
                      _buildTrustPill(
                        icon: Iconsax.shield_tick,
                        text: AppStrings.trustSecureCheckoutDesc,
                      ),
                      const SizedBox(height: AppSpacing.s8),
                      _buildTrustPill(
                        icon: Iconsax.refresh_2,
                        text: AppStrings.trustEasyExchangeDesc,
                      ),
                      const SizedBox(height: AppSpacing.s8),
                      _buildTrustPill(
                        icon: Iconsax.gift,
                        text: AppStrings.trustFreeWrappingTitle,
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildPriceRow({
    required String label,
    String? value,
    Widget? valueWidget,
    Color? valueColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppText.body(label, color: AppColors.muted),
        if (valueWidget != null)
          valueWidget
        else
          Text(
            value ?? '',
            style: GoogleFonts.cairo(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: valueColor ?? AppColors.ink,
            ),
          ),
      ],
    );
  }

  Widget _buildTrustPill({required IconData icon, required String text}) {
    return Row(
      children: [
        Icon(icon, size: 15, color: AppColors.muted),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.cairo(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: AppColors.muted,
            ),
          ),
        ),
      ],
    );
  }
}
