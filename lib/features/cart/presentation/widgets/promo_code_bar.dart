import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

import 'package:warsha_commerce/core/localization/app_strings.dart';
import 'package:warsha_commerce/core/theme/app_colors.dart';
import 'package:warsha_commerce/core/theme/app_radius.dart';
import 'package:warsha_commerce/core/theme/app_spacing.dart';
import 'package:warsha_commerce/core/widgets/app_button.dart';
import 'package:warsha_commerce/core/widgets/app_container.dart';
import 'package:warsha_commerce/core/widgets/app_text.dart';
import 'package:warsha_commerce/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:warsha_commerce/features/cart/presentation/cubit/cart_state.dart';

class PromoCodeBar extends StatefulWidget {
  const PromoCodeBar({super.key});

  @override
  State<PromoCodeBar> createState() => _PromoCodeBarState();
}

class _PromoCodeBarState extends State<PromoCodeBar> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onApply() {
    final code = _controller.text.trim();
    if (code.isNotEmpty) {
      context.read<CartCubit>().applyPromoCode(code);
    }
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);

    return BlocBuilder<CartCubit, CartState>(
      builder: (context, state) {
        final hasPromo = state.appliedPromoCode != null;

        return AppContainer.surface(
          radius: AppRadius.card,
          padding: const EdgeInsetsDirectional.all(AppSpacing.s16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Iconsax.ticket_discount,
                    size: 18,
                    color: AppColors.burgundy,
                  ),
                  const SizedBox(width: AppSpacing.s8),
                  AppText.titleSmall(
                    strings.promoCode,
                    weight: FontWeight.w700,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.s12),

              if (hasPromo) ...[
                // Applied promo badge
                Container(
                  padding: const EdgeInsetsDirectional.symmetric(
                    horizontal: AppSpacing.s12,
                    vertical: AppSpacing.s8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.blush,
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                    border: Border.all(color: AppColors.champagne),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Iconsax.tick_circle,
                            size: 18,
                            color: AppColors.burgundy,
                          ),
                          const SizedBox(width: AppSpacing.s8),
                          Text(
                            state.appliedPromoCode!,
                            style: GoogleFonts.cairo(
                              fontWeight: FontWeight.w700,
                              color: AppColors.deepWine,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '(خصم 10%)',
                            style: GoogleFonts.cairo(
                              fontWeight: FontWeight.w600,
                              color: AppColors.burgundy,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Iconsax.close_circle, size: 16),
                        color: AppColors.muted,
                        padding: EdgeInsetsDirectional.zero,
                        constraints: const BoxConstraints(),
                        tooltip: strings.remove,
                        onPressed: () {
                          _controller.clear();
                          context.read<CartCubit>().removePromoCode();
                        },
                      ),
                    ],
                  ),
                ),
              ] else ...[
                // Promo Code Input Row
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 42,
                        decoration: BoxDecoration(
                          color: AppColors.ivory,
                          borderRadius: BorderRadius.circular(AppRadius.pill),
                          border: Border.all(
                            color: state.promoErrorMessage != null
                                ? AppColors.burgundy
                                : AppColors.line,
                          ),
                        ),
                        padding: const EdgeInsetsDirectional.symmetric(
                          horizontal: AppSpacing.s16,
                        ),
                        alignment: Alignment.center,
                        child: TextField(
                          controller: _controller,
                          textCapitalization: TextCapitalization.characters,
                          style: GoogleFonts.cairo(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.ink,
                          ),
                          decoration: InputDecoration(
                            hintText: strings.promoCodePlaceholder,
                            hintStyle: GoogleFonts.cairo(
                              fontSize: 12,
                              color: AppColors.muted,
                            ),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsetsDirectional.zero,
                          ),
                          onSubmitted: (_) => _onApply(),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.s8),
                    AppButton.primary(
                      label: strings.apply,
                      height: 42,
                      isLoading: state.isApplyingPromo,
                      onPressed: _onApply,
                    ),
                  ],
                ),
                if (state.promoErrorMessage != null) ...[
                  const SizedBox(height: AppSpacing.s8),
                  Text(
                    state.promoErrorMessage!,
                    style: GoogleFonts.cairo(
                      fontSize: 12,
                      color: AppStatusColors.errorText,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ],
            ],
          ),
        );
      },
    );
  }
}
