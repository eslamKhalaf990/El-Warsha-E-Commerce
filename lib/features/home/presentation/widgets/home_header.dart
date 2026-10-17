import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

import 'package:warsha_commerce/core/config/app_assets.dart';
import 'package:warsha_commerce/core/config/app_config.dart';
import 'package:warsha_commerce/core/l10n/app_strings.dart';
import 'package:warsha_commerce/core/theme/app_colors.dart';
import 'package:warsha_commerce/core/theme/app_radius.dart';
import 'package:warsha_commerce/core/theme/app_spacing.dart';
import 'package:warsha_commerce/core/utils/breakpoints.dart';
import 'package:warsha_commerce/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:warsha_commerce/features/cart/presentation/cubit/cart_state.dart';

class HomeHeader extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onOpenDrawer;

  const HomeHeader({super.key, this.onOpenDrawer});

  /// Luxury height: 126px
  @override
  Size get preferredSize => const Size.fromHeight(126);

  @override
  Widget build(BuildContext context) {
    final isDesktop = context.isDesktop;

    return Container(
      height: 126,
      decoration: BoxDecoration(
        color: AppColors.ivory,
        border: const Border(
          bottom: BorderSide(color: AppColors.line, width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.deepWine.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // 1. Top Luxury Announcement Strip (Height 36px)
          _buildTopAnnouncement(context),

          // 2. Main Navigation Bar
          Expanded(
            child: Padding(
              padding: const EdgeInsetsDirectional.symmetric(
                horizontal: AppSpacing.s24,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: Breakpoints.maxContentWidth,
                  ),
                  child: Row(
                    children: [
                      // Mobile Menu Toggle
                      if (!isDesktop) ...[
                        Semantics(
                          label: AppStrings.menu,
                          button: true,
                          child: _ActionIconButton(
                            icon: Iconsax.menu_1,
                            onPressed: onOpenDrawer,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.s12),
                      ],

                      // Brand Logo Mark
                      _buildBrandLogo(context),

                      if (isDesktop) ...[
                        const SizedBox(width: AppSpacing.s32),

                        // Desktop Navigation Links
                        Expanded(child: _buildDesktopNav(context)),

                        // Search Pill
                        _buildSearchPill(context),
                        const SizedBox(width: AppSpacing.s16),
                      ] else
                        const Spacer(),

                      // Action Icons (Search on mobile, Wishlist, Account, Cart)
                      _buildActions(context, isDesktop),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopAnnouncement(BuildContext context) {
    return Container(
      height: 36,
      width: double.infinity,
      color: AppColors.deepWine,
      child: Center(
        child: Padding(
          padding: const EdgeInsetsDirectional.symmetric(
            horizontal: AppSpacing.s16,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Iconsax.magic_star,
                size: 14,
                color: AppColors.champagne,
              ),
              const SizedBox(width: AppSpacing.s8),
              Flexible(
                child: Text(
                  AppStrings.announcement,
                  style: GoogleFonts.cairo(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.champagne,
                    letterSpacing: 0.3,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: AppSpacing.s8),
              const Icon(
                Iconsax.magic_star,
                size: 14,
                color: AppColors.champagne,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBrandLogo(BuildContext context) {
    return InkWell(
      onTap: () => context.go('/'),
      borderRadius: BorderRadius.circular(AppRadius.card),
      child: Padding(
        padding: const EdgeInsetsDirectional.symmetric(
          horizontal: AppSpacing.s8,
          vertical: AppSpacing.s4,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Emblem Gem Badge / Logo
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                // gradient: const LinearGradient(
                //   begin: AlignmentDirectional.topStart,
                //   end: AlignmentDirectional.bottomEnd,
                //   colors: [AppColors.burgundy, AppColors.deepWine],
                // ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.burgundy, width: 1.2),
                // boxShadow: [
                //   BoxShadow(
                //     color: AppColors.burgundy.withValues(alpha: 0.3),
                //     blurRadius: 10,
                //     offset: const Offset(0, 3),
                //   ),
                // ],
              ),
              padding: const EdgeInsets.all(4),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  AppAssets.logoBurgundy,
                  fit: BoxFit.contain,
                  errorBuilder: (_, _, _) => const Center(
                    child: Icon(
                      Iconsax.diamonds,
                      color: AppColors.champagne,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.s12),

            // Typography Lockup
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      AppConfig.brandNameAr,
                      style: GoogleFonts.cairo(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: AppColors.deepWine,
                        height: 1.15,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.s8),
                    Container(
                      padding: const EdgeInsetsDirectional.symmetric(
                        horizontal: AppSpacing.s8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.blush,
                        borderRadius: BorderRadius.circular(AppRadius.pill),
                      ),
                      child: Text(
                        AppStrings.brandSubtitle,
                        style: GoogleFonts.cairo(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w700,
                          color: AppColors.burgundy,
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                  AppStrings.brandSubtitleEn,
                  style: GoogleFonts.cairo(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.5,
                    color: AppColors.muted,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopNav(BuildContext context) {
    const navItems = [
      (AppStrings.shop, '/shop', false),
      (AppStrings.rings, '/shop?category=1', false),
      (AppStrings.bracelets, '/shop?category=2', false),
      (AppStrings.necklaces, '/shop?category=3', false),
      (AppStrings.earrings, '/shop?category=4', false),
      (AppStrings.gifts, '/shop?gift=true', true),
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: navItems.map((item) {
        return _NavButton(label: item.$1, route: item.$2, isHighlight: item.$3);
      }).toList(),
    );
  }

  Widget _buildSearchPill(BuildContext context) {
    return _SearchPillButton(onTap: () => context.push('/shop'));
  }

  Widget _buildActions(BuildContext context, bool isDesktop) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (!isDesktop)
          Semantics(
            label: 'Search',
            button: true,
            child: _ActionIconButton(
              icon: Iconsax.search_normal_1,
              onPressed: () => context.push('/shop'),
            ),
          ),

        if (isDesktop) ...[
          Semantics(
            label: AppStrings.wishlist,
            button: true,
            child: _ActionIconButton(
              icon: Iconsax.heart,
              tooltip: AppStrings.wishlist,
              onPressed: () => context.push('/wishlist'),
            ),
          ),
          const SizedBox(width: AppSpacing.s8),
          Semantics(
            label: AppStrings.account,
            button: true,
            child: _ActionIconButton(
              icon: Iconsax.user,
              tooltip: AppStrings.account,
              onPressed: () => context.push('/account'),
            ),
          ),
          const SizedBox(width: AppSpacing.s8),
        ],

        // Cart Icon with Live Item-Count Badge
        BlocSelector<CartCubit, CartState, int>(
          selector: (state) => state.itemCount,
          builder: (context, itemCount) {
            return _CartButton(
              itemCount: itemCount,
              tooltip: AppStrings.cart,
              onPressed: () => context.push('/cart'),
            );
          },
        ),
      ],
    );
  }
}

class _NavButton extends StatefulWidget {
  final String label;
  final String route;
  final bool isHighlight;

  const _NavButton({
    required this.label,
    required this.route,
    this.isHighlight = false,
  });

  @override
  State<_NavButton> createState() => _NavButtonState();
}

class _NavButtonState extends State<_NavButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: InkWell(
        onTap: () => context.push(widget.route),
        borderRadius: BorderRadius.circular(AppRadius.pill),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsetsDirectional.symmetric(
            horizontal: AppSpacing.s12,
            vertical: AppSpacing.s8,
          ),
          decoration: BoxDecoration(
            color: _isHovered
                ? AppColors.blush
                : (widget.isHighlight
                      ? AppColors.blush.withValues(alpha: 0.5)
                      : Colors.transparent),
            borderRadius: BorderRadius.circular(AppRadius.pill),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.isHighlight) ...[
                const Icon(Iconsax.gift, size: 16, color: AppColors.burgundy),
                const SizedBox(width: AppSpacing.s4),
              ],
              Text(
                widget.label,
                style: GoogleFonts.cairo(
                  fontSize: 14.5,
                  fontWeight: _isHovered || widget.isHighlight
                      ? FontWeight.w700
                      : FontWeight.w600,
                  color: _isHovered ? AppColors.burgundy : AppColors.ink,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SearchPillButton extends StatefulWidget {
  final VoidCallback onTap;

  const _SearchPillButton({required this.onTap});

  @override
  State<_SearchPillButton> createState() => _SearchPillButtonState();
}

class _SearchPillButtonState extends State<_SearchPillButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: 220,
          height: 40,
          padding: const EdgeInsetsDirectional.symmetric(
            horizontal: AppSpacing.s12,
          ),
          decoration: BoxDecoration(
            color: _isHovered
                ? AppColors.white
                : AppColors.blush.withValues(alpha: 0.7),
            borderRadius: BorderRadius.circular(AppRadius.pill),
            border: Border.all(
              color: _isHovered
                  ? AppColors.burgundy.withValues(alpha: 0.4)
                  : AppColors.line,
              width: 1,
            ),
          ),
          child: const Row(
            children: [
              Icon(
                Iconsax.search_normal_1,
                size: 18,
                color: AppColors.burgundy,
              ),
              SizedBox(width: AppSpacing.s8),
              Expanded(
                child: Text(
                  AppStrings.searchPlaceholder,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 12.5,
                    color: AppColors.muted,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionIconButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;

  const _ActionIconButton({
    required this.icon,
    required this.onPressed,
    this.tooltip,
  });

  @override
  State<_ActionIconButton> createState() => _ActionIconButtonState();
}

class _ActionIconButtonState extends State<_ActionIconButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Tooltip(
        message: widget.tooltip ?? '',
        child: InkWell(
          onTap: widget.onPressed,
          borderRadius: BorderRadius.circular(AppRadius.pill),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: _isHovered ? AppColors.blush : Colors.transparent,
              borderRadius: BorderRadius.circular(AppRadius.pill),
            ),
            child: Center(
              child: Icon(
                widget.icon,
                size: 22,
                color: _isHovered ? AppColors.burgundy : AppColors.ink,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CartButton extends StatefulWidget {
  final int itemCount;
  final VoidCallback onPressed;
  final String tooltip;

  const _CartButton({
    required this.itemCount,
    required this.onPressed,
    required this.tooltip,
  });

  @override
  State<_CartButton> createState() => _CartButtonState();
}

class _CartButtonState extends State<_CartButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Tooltip(
        message: widget.tooltip,
        child: InkWell(
          onTap: widget.onPressed,
          borderRadius: BorderRadius.circular(AppRadius.pill),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsetsDirectional.symmetric(
              horizontal: AppSpacing.s8,
              vertical: AppSpacing.s4,
            ),
            decoration: BoxDecoration(
              color: _isHovered ? AppColors.blush : Colors.transparent,
              borderRadius: BorderRadius.circular(AppRadius.pill),
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 42,
                  height: 42,
                  alignment: Alignment.center,
                  child: Icon(
                    Iconsax.shopping_bag,
                    size: 23,
                    color: _isHovered ? AppColors.burgundy : AppColors.ink,
                  ),
                ),
                if (widget.itemCount > 0)
                  PositionedDirectional(
                    top: 2,
                    end: 2,
                    child: Container(
                      padding: const EdgeInsetsDirectional.all(4),
                      decoration: BoxDecoration(
                        color: AppColors.burgundy,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.ivory, width: 1.5),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 19,
                        minHeight: 19,
                      ),
                      child: Center(
                        child: Text(
                          '${widget.itemCount}',
                          style: GoogleFonts.cairo(
                            color: AppColors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            height: 1.0,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
