import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

import 'package:warsha_commerce/core/l10n/app_strings.dart';
import 'package:warsha_commerce/core/theme/app_colors.dart';
import 'package:warsha_commerce/core/theme/app_radius.dart';
import 'package:warsha_commerce/core/theme/app_spacing.dart';
import 'package:warsha_commerce/core/utils/breakpoints.dart';
import 'package:warsha_commerce/core/utils/money.dart';
import 'package:warsha_commerce/core/widgets/app_button.dart';
import 'package:warsha_commerce/core/widgets/app_container.dart';
import 'package:warsha_commerce/core/widgets/app_text.dart';
import 'package:warsha_commerce/core/widgets/product_image.dart';
import 'package:warsha_commerce/features/home/presentation/widgets/home_drawer.dart';
import 'package:warsha_commerce/features/home/presentation/widgets/home_footer.dart';
import 'package:warsha_commerce/features/home/presentation/widgets/home_header.dart';
import 'package:warsha_commerce/features/orders/domain/entities/order.dart';

class OrderConfirmationPage extends StatefulWidget {
  final Order? order;

  const OrderConfirmationPage({super.key, this.order});

  @override
  State<OrderConfirmationPage> createState() => _OrderConfirmationPageState();
}

class _OrderConfirmationPageState extends State<OrderConfirmationPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    final order = widget.order;

    if (order == null) {
      return Scaffold(
        key: _scaffoldKey,
        backgroundColor: AppColors.ivory,
        appBar: const HomeHeader(),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const AppText.headline(
                AppStrings.emptyShelf,
                color: AppColors.deepWine,
              ),
              const SizedBox(height: AppSpacing.s16),
              AppButton.primary(
                label: strings.continueShopping,
                onPressed: () => context.go('/'),
              ),
            ],
          ),
        ),
      );
    }

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
                  child: Column(
                    children: [
                      // Success Celebration Card
                      AppContainer.surface(
                        radius: AppRadius.card,
                        padding: const EdgeInsetsDirectional.all(
                          AppSpacing.s32,
                        ),
                        child: Column(
                          children: [
                            // Emerald Success Icon
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: AppStatusColors.successBackground,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppStatusColors.successText.withValues(
                                    alpha: 0.3,
                                  ),
                                  width: 2,
                                ),
                              ),
                              child: const Icon(
                                Iconsax.tick_circle,
                                size: 48,
                                color: AppStatusColors.successText,
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Order Success (تمام! طلبك اتسجّل 🎉 هنواصل معاك قريب)
                            const AppText.headline(
                              AppStrings.orderSuccess,
                              color: AppColors.deepWine,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: AppSpacing.s8),

                            AppText.body(
                              strings.orderSuccessSubtitle,
                              color: AppColors.muted,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: AppSpacing.s24),

                            // Order Info Pills Row
                            Wrap(
                              alignment: WrapAlignment.center,
                              spacing: AppSpacing.s16,
                              runSpacing: AppSpacing.s12,
                              children: [
                                _buildInfoBadge(
                                  label: strings.orderNumber,
                                  value: order.orderNumber,
                                  icon: Iconsax.hashtag,
                                ),
                                _buildInfoBadge(
                                  label: strings.paymentMethod,
                                  value: order.paymentMethod,
                                  icon: Iconsax.wallet_2,
                                ),
                                _buildInfoBadge(
                                  label: strings.estimatedDelivery,
                                  value: AppStrings.estimatedDeliveryVal,
                                  icon: Iconsax.truck_fast,
                                ),
                              ],
                            ),
                            const SizedBox(height: AppSpacing.s16),

                            // Friendly deposit receipt review note
                            Container(
                              padding: const EdgeInsetsDirectional.symmetric(
                                horizontal: AppSpacing.s16,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.blush.withValues(alpha: 0.6),
                                borderRadius: BorderRadius.circular(
                                  AppRadius.card,
                                ),
                                border: Border.all(
                                  color: AppColors.burgundy.withValues(
                                    alpha: 0.2,
                                  ),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Iconsax.receipt_2,
                                    size: 16,
                                    color: AppColors.burgundy,
                                  ),
                                  const SizedBox(width: 8),
                                  Flexible(
                                    child: Text(
                                      AppStrings.depositReceiptReceived,
                                      style: GoogleFonts.cairo(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.deepWine,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.s24),

                      // Order Details and Address in 2 columns or stacked
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final isDesktop = constraints.maxWidth >= 850;

                          final itemsSection = AppContainer.surface(
                            radius: AppRadius.card,
                            padding: const EdgeInsetsDirectional.all(
                              AppSpacing.s24,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppText.title(
                                  '${AppStrings.itemsInOrder} (${order.items.length})',
                                  weight: FontWeight.w700,
                                  color: AppColors.deepWine,
                                ),
                                const SizedBox(height: AppSpacing.s16),
                                ListView.separated(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: order.items.length,
                                  separatorBuilder: (context, index) =>
                                      const Padding(
                                        padding: EdgeInsets.symmetric(
                                          vertical: AppSpacing.s8,
                                        ),
                                        child: Divider(color: AppColors.line),
                                      ),
                                  itemBuilder: (context, index) {
                                    final item = order.items[index];
                                    return Row(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            AppRadius.card,
                                          ),
                                          child: SizedBox(
                                            width: 56,
                                            height: 56,
                                            child: ProductImage(
                                              imageUrl: item.imageUrl,
                                              fallbackSeed: item.productId,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: AppSpacing.s12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                item.productName,
                                                style: GoogleFonts.cairo(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w700,
                                                  color: AppColors.ink,
                                                ),
                                              ),
                                              Text(
                                                'العدد: ${item.quantity}',
                                                style: GoogleFonts.cairo(
                                                  fontSize: 12,
                                                  color: AppColors.muted,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Text(
                                          MoneyUtils.formatMinor(
                                            item.totalPrice,
                                          ),
                                          style: GoogleFonts.cairo(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.burgundy,
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ],
                            ),
                          );

                          final summarySection = AppContainer.surface(
                            radius: AppRadius.card,
                            padding: const EdgeInsetsDirectional.all(
                              AppSpacing.s24,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const AppText.title(
                                  AppStrings.deliveryAddressReview,
                                  weight: FontWeight.w700,
                                  color: AppColors.deepWine,
                                ),
                                const SizedBox(height: AppSpacing.s16),
                                if (order.shippingAddress != null) ...[
                                  _buildAddressRow(
                                    Iconsax.user,
                                    order.shippingAddress!.fullName,
                                  ),
                                  const SizedBox(height: AppSpacing.s8),
                                  _buildAddressRow(
                                    Iconsax.call,
                                    order.shippingAddress!.phone,
                                  ),
                                  const SizedBox(height: AppSpacing.s8),
                                  _buildAddressRow(
                                    Iconsax.location,
                                    order.shippingAddress!.formattedAddress,
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: AppSpacing.s12,
                                    ),
                                    child: Divider(color: AppColors.line),
                                  ),
                                ],
                                _buildSummaryPriceRow(
                                  strings.subtotal,
                                  MoneyUtils.formatMinor(order.subtotal),
                                ),
                                const SizedBox(height: AppSpacing.s8),
                                _buildSummaryPriceRow(
                                  strings.shippingFee,
                                  order.deliveryFee == 0
                                      ? strings.freeShipping
                                      : MoneyUtils.formatMinor(
                                          order.deliveryFee,
                                        ),
                                ),
                                if (order.discount > 0) ...[
                                  const SizedBox(height: AppSpacing.s8),
                                  _buildSummaryPriceRow(
                                    strings.discount,
                                    '- ${MoneyUtils.formatMinor(order.discount)}',
                                    isDiscount: true,
                                  ),
                                ],
                                const Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: AppSpacing.s12,
                                  ),
                                  child: Divider(color: AppColors.line),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                      MoneyUtils.formatMinor(order.totalPrice),
                                      style: GoogleFonts.cairo(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w900,
                                        color: AppColors.burgundy,
                                      ),
                                    ),
                                  ],
                                ),
                                if (order.downPayment > 0) ...[
                                  const SizedBox(height: AppSpacing.s8),
                                  _buildSummaryPriceRow(
                                    AppStrings.downPayment,
                                    '- ${MoneyUtils.formatMinor(order.downPayment)}',
                                    isDiscount: true,
                                  ),
                                  const SizedBox(height: AppSpacing.s8),
                                  _buildSummaryPriceRow(
                                    AppStrings.remainingAmount,
                                    MoneyUtils.formatMinor(
                                      (order.totalPrice - order.downPayment).clamp(0, 999999999),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          );

                          if (isDesktop) {
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(flex: 6, child: itemsSection),
                                const SizedBox(width: AppSpacing.s24),
                                Expanded(flex: 4, child: summarySection),
                              ],
                            );
                          } else {
                            return Column(
                              children: [
                                itemsSection,
                                const SizedBox(height: 20),
                                summarySection,
                              ],
                            );
                          }
                        },
                      ),
                      const SizedBox(height: AppSpacing.s32),

                      // Navigation Actions
                      Wrap(
                        spacing: AppSpacing.s16,
                        runSpacing: AppSpacing.s12,
                        alignment: WrapAlignment.center,
                        children: [
                          AppButton.primary(
                            label: strings.continueShopping,
                            height: 48,
                            icon: const Icon(
                              Iconsax.shop,
                              size: 18,
                              color: AppColors.white,
                            ),
                            onPressed: () => context.go('/'),
                          ),
                          AppButton.secondary(
                            label: strings.viewMyOrders,
                            height: 48,
                            icon: const Icon(
                              Iconsax.receipt,
                              size: 18,
                              color: AppColors.burgundy,
                            ),
                            onPressed: () => context.push('/orders'),
                          ),
                        ],
                      ),
                    ],
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

  Widget _buildInfoBadge({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: AppSpacing.s16,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: AppColors.blush,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColors.line),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.burgundy),
          const SizedBox(width: AppSpacing.s8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: GoogleFonts.cairo(
                  fontSize: 10.5,
                  color: AppColors.muted,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                value,
                style: GoogleFonts.cairo(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  color: AppColors.deepWine,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAddressRow(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: AppColors.muted),
        const SizedBox(width: AppSpacing.s8),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.cairo(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: AppColors.ink,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryPriceRow(
    String label,
    String value, {
    bool isDiscount = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppText.body(label, color: AppColors.muted),
        Text(
          value,
          style: GoogleFonts.cairo(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isDiscount ? AppColors.burgundy : AppColors.ink,
          ),
        ),
      ],
    );
  }
}
