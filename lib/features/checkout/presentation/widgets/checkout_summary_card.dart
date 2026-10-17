import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
import 'package:warsha_commerce/features/checkout/presentation/cubit/checkout_state.dart';

class CheckoutSummaryCard extends StatelessWidget {
  final CheckoutState state;
  final int subtotal;
  final int discount;
  final VoidCallback onSubmit;

  const CheckoutSummaryCard({
    super.key,
    required this.state,
    required this.subtotal,
    required this.discount,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final finalTotal = (subtotal + state.deliveryFee - discount).clamp(
      0,
      999999999,
    );
    final isSubmitting = state.status == CheckoutStatus.submitting;
    final authState = context.watch<AuthCubit>().state;
    final isAuthenticated = authState.isAuthenticated;

    return AppContainer.surface(
      radius: AppRadius.card,
      padding: const EdgeInsetsDirectional.all(AppSpacing.s24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const AppText.title(
            AppStrings.orderSummary,
            weight: FontWeight.w700,
            color: AppColors.deepWine,
          ),
          const SizedBox(height: AppSpacing.s16),

          _buildRow(AppStrings.subtotal, MoneyUtils.formatMinor(subtotal)),
          const SizedBox(height: 10),

          _buildRow(
            AppStrings.shippingFee,
            state.deliveryFee == 0
                ? AppStrings.freeShipping
                : MoneyUtils.formatMinor(state.deliveryFee),
            valueColor: state.deliveryFee == 0
                ? AppStatusColors.successText
                : AppColors.ink,
          ),

          if (discount > 0) ...[
            const SizedBox(height: 10),
            _buildRow(
              AppStrings.discount,
              '- ${MoneyUtils.formatMinor(discount)}',
              valueColor: AppColors.burgundy,
            ),
          ],

          const Padding(
            padding: EdgeInsets.symmetric(vertical: AppSpacing.s16),
            child: Divider(color: AppColors.line),
          ),

          // Grand Total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppStrings.total,
                style: GoogleFonts.cairo(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppColors.deepWine,
                ),
              ),
              Text(
                MoneyUtils.formatMinor(finalTotal),
                style: GoogleFonts.cairo(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: AppColors.burgundy,
                ),
              ),
            ],
          ),

          if (state.downPayment > 0) ...[
            const SizedBox(height: 10),
            _buildRow(
              AppStrings.downPayment,
              '- ${MoneyUtils.formatMinor(state.downPayment)}',
              valueColor: AppColors.burgundy,
            ),
            const SizedBox(height: 10),
            _buildRow(
              AppStrings.remainingAmount,
              MoneyUtils.formatMinor(
                (finalTotal - state.downPayment).clamp(0, 999999999),
              ),
              valueColor: AppColors.deepWine,
            ),
          ],
          const SizedBox(height: 20),

          // Error banner if any
          if (state.errorMessage != null) ...[
            Container(
              padding: const EdgeInsetsDirectional.all(12),
              decoration: BoxDecoration(
                color: AppStatusColors.errorBackground,
                borderRadius: BorderRadius.circular(AppRadius.card),
              ),
              child: Row(
                children: [
                  const Icon(
                    Iconsax.danger,
                    color: AppStatusColors.errorText,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      state.errorMessage!,
                      style: GoogleFonts.cairo(
                        fontSize: 12,
                        color: AppStatusColors.errorText,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Confirmation CTA Button
          if (!isAuthenticated) ...[
            AppButton.secondary(
              label: 'سجّل دخولك أولاً لمتابعة الطلب',
              height: 52,
              icon: const Icon(
                Iconsax.lock,
                size: 18,
                color: AppColors.burgundy,
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'يرجى تسجيل الدخول أو إنشاء حساب بالنموذج أعلاه لإتمام الطلب',
                    ),
                  ),
                );
              },
            ),
          ] else ...[
            AppButton.primary(
              label: AppStrings.confirmOrder,
              height: 52,
              isLoading: isSubmitting,
              icon: const Icon(
                Iconsax.tick_circle,
                size: 20,
                color: AppColors.white,
              ),
              onPressed: isSubmitting ? null : onSubmit,
            ),
          ],
          const SizedBox(height: 16),

          // Security Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Iconsax.shield_tick, size: 16, color: AppColors.muted),
              const SizedBox(width: 6),
              Text(
                AppStrings.trustSecureCheckoutDesc,
                style: GoogleFonts.cairo(
                  fontSize: 11.5,
                  color: AppColors.muted,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value, {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppText.body(label, color: AppColors.muted),
        Text(
          value,
          style: GoogleFonts.cairo(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: valueColor ?? AppColors.ink,
          ),
        ),
      ],
    );
  }
}
