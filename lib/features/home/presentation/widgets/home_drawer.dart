import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

import 'package:warsha_commerce/core/config/app_assets.dart';
import 'package:warsha_commerce/core/config/app_config.dart';
import 'package:warsha_commerce/core/localization/app_strings.dart';
import 'package:warsha_commerce/core/theme/app_colors.dart';
import 'package:warsha_commerce/core/theme/app_spacing.dart';
import 'package:warsha_commerce/core/widgets/app_text.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);

    return Drawer(
      backgroundColor: AppColors.ivory,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drawer Header
            Padding(
              padding: const EdgeInsetsDirectional.all(AppSpacing.s24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            AppAssets.logoBurgundy,
                            height: 32,
                            width: 32,
                            fit: BoxFit.contain,
                            errorBuilder: (_, _, _) => const Icon(
                              Iconsax.diamonds,
                              color: AppColors.burgundy,
                              size: 24,
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.s8),
                        const Expanded(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: AlignmentDirectional.centerStart,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                AppText.headline(
                                  AppConfig.brandNameAr,
                                  color: AppColors.deepWine,
                                ),
                                SizedBox(width: AppSpacing.s4),
                                AppText.caption(
                                  AppConfig.brandName,
                                  color: AppColors.burgundy,
                                  weight: FontWeight.w700,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Iconsax.close_circle,
                      color: AppColors.ink,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            const Divider(color: AppColors.line),

            // Links List
            Expanded(
              child: ListView(
                padding: const EdgeInsetsDirectional.symmetric(
                  vertical: AppSpacing.s8,
                ),
                children: [
                  _buildDrawerItem(
                    context,
                    title: strings.shop,
                    icon: Iconsax.shop,
                    onTap: () {
                      Navigator.of(context).pop();
                      context.push('/shop');
                    },
                  ),
                  _buildDrawerItem(
                    context,
                    title: strings.rings,
                    icon: Iconsax.record_circle,
                    onTap: () {
                      Navigator.of(context).pop();
                      context.push('/shop?category=1');
                    },
                  ),
                  _buildDrawerItem(
                    context,
                    title: strings.bracelets,
                    icon: Iconsax.watch,
                    onTap: () {
                      Navigator.of(context).pop();
                      context.push('/shop?category=2');
                    },
                  ),
                  _buildDrawerItem(
                    context,
                    title: strings.necklaces,
                    icon: Iconsax.gemini,
                    onTap: () {
                      Navigator.of(context).pop();
                      context.push('/shop?category=3');
                    },
                  ),
                  _buildDrawerItem(
                    context,
                    title: strings.earrings,
                    icon: Iconsax.magic_star,
                    onTap: () {
                      Navigator.of(context).pop();
                      context.push('/shop?category=4');
                    },
                  ),
                  _buildDrawerItem(
                    context,
                    title: strings.gifts,
                    icon: Iconsax.gift,
                    onTap: () {
                      Navigator.of(context).pop();
                      context.push('/shop?gift=true');
                    },
                  ),
                  const Divider(color: AppColors.line),
                  _buildDrawerItem(
                    context,
                    title: strings.wishlist,
                    icon: Iconsax.heart,
                    onTap: () {
                      Navigator.of(context).pop();
                      context.push('/wishlist');
                    },
                  ),
                  _buildDrawerItem(
                    context,
                    title: strings.account,
                    icon: Iconsax.user,
                    onTap: () {
                      Navigator.of(context).pop();
                      context.push('/account');
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return ListTile(
      leading: Icon(icon, color: AppColors.deepWine, size: 22),
      title: AppText.body(title),
      trailing: Icon(
        isRtl ? Iconsax.arrow_left_2 : Iconsax.arrow_right_3,
        color: AppColors.muted,
        size: 18,
      ),
      onTap: onTap,
    );
  }
}
