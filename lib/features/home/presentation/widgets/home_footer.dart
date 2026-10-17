import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:warsha_commerce/core/config/app_assets.dart';
import 'package:warsha_commerce/core/config/app_config.dart';
import 'package:warsha_commerce/core/l10n/app_strings.dart';
import 'package:warsha_commerce/core/theme/app_colors.dart';
import 'package:warsha_commerce/core/theme/app_radius.dart';
import 'package:warsha_commerce/core/theme/app_spacing.dart';
import 'package:warsha_commerce/core/utils/breakpoints.dart';
import 'package:warsha_commerce/core/widgets/app_text.dart';

class HomeFooter extends StatelessWidget {
  const HomeFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = context.isDesktop;

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.ivory,
        border: Border(top: BorderSide(color: AppColors.line, width: 1)),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: Breakpoints.maxContentWidth,
          ),
          child: Padding(
            padding: const EdgeInsetsDirectional.symmetric(
              horizontal: AppSpacing.s24,
              vertical: AppSpacing.s48,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isDesktop)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Brand & About
                      Expanded(flex: 4, child: _buildBrandCol()),
                      const SizedBox(width: AppSpacing.s48),
                      // Quick Links
                      Expanded(flex: 3, child: _buildQuickLinks(context)),
                      // Customer Care
                      Expanded(flex: 3, child: _buildContactCol()),
                    ],
                  )
                else
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildBrandCol(),
                      const SizedBox(height: AppSpacing.s32),
                      _buildQuickLinks(context),
                      const SizedBox(height: AppSpacing.s32),
                      _buildContactCol(),
                    ],
                  ),
                const SizedBox(height: AppSpacing.s48),
                const Divider(color: AppColors.line),
                const SizedBox(height: AppSpacing.s24),
                const Center(
                  child: AppText.caption(
                    AppStrings.copyright,
                    color: AppColors.muted,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static Widget _buildBrandCol() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                AppAssets.logoBurgundy,
                height: 32,
                width: 32,
                fit: BoxFit.contain,
                errorBuilder: (_, _, _) => const SizedBox.shrink(),
              ),
            ),
            const SizedBox(width: AppSpacing.s8),
            const AppText.headline(
              AppConfig.brandNameAr,
              color: AppColors.deepWine,
            ),
            const SizedBox(width: AppSpacing.s4),
            const AppText.caption(
              AppConfig.brandName,
              color: AppColors.burgundy,
              weight: FontWeight.w700,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.s12),
        const AppText.bodySmall(AppStrings.footerAbout, color: AppColors.muted),
      ],
    );
  }

  static Widget _buildQuickLinks(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppText.label(AppStrings.quickLinks, color: AppColors.deepWine),
        const SizedBox(height: AppSpacing.s12),
        _buildFooterLink(context, AppStrings.shop, '/shop'),
        _buildFooterLink(context, AppStrings.rings, '/shop?category=1'),
        _buildFooterLink(context, AppStrings.bracelets, '/shop?category=2'),
        _buildFooterLink(context, AppStrings.necklaces, '/shop?category=3'),
        _buildFooterLink(context, AppStrings.gifts, '/shop?gift=true'),
      ],
    );
  }

  static Widget _buildContactCol() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText.label(AppStrings.customerCare, color: AppColors.deepWine),
        SizedBox(height: AppSpacing.s12),
        AppText.bodySmall(AppStrings.contactPhone, color: AppColors.ink),
        SizedBox(height: AppSpacing.s4),
        AppText.bodySmall(AppStrings.contactEmail, color: AppColors.ink),
        SizedBox(height: AppSpacing.s8),
        AppText.caption(
          AppStrings.trustEasyExchangeDesc,
          color: AppColors.muted,
        ),
      ],
    );
  }

  static Widget _buildFooterLink(
    BuildContext context,
    String label,
    String route,
  ) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(bottom: AppSpacing.s8),
      child: InkWell(
        onTap: () => context.push(route),
        borderRadius: BorderRadius.circular(AppRadius.small),
        child: AppText.bodySmall(label, color: AppColors.muted),
      ),
    );
  }
}
