import 'package:flutter/material.dart';

import 'package:warsha_commerce/core/theme/app_colors.dart';
import 'package:warsha_commerce/core/theme/app_radius.dart';
import 'package:warsha_commerce/core/theme/app_spacing.dart';
import 'package:warsha_commerce/core/widgets/app_container.dart';
import 'package:warsha_commerce/core/widgets/app_text.dart';

enum AppButtonVariant { primary, secondary, text }

/// Pill-shaped button built on top of [AppContainer] and [AppText].
class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final bool isLoading;
  final Widget? icon;
  final Widget? trailingIcon;
  final double? width;
  final double height;

  const AppButton.primary({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
    this.trailingIcon,
    this.width,
    this.height = 48.0,
  }) : variant = AppButtonVariant.primary;

  const AppButton.secondary({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
    this.trailingIcon,
    this.width,
    this.height = 48.0,
  }) : variant = AppButtonVariant.secondary;

  const AppButton.text({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
    this.trailingIcon,
    this.width,
    this.height = 48.0,
  }) : variant = AppButtonVariant.text;

  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.isLoading = false,
    this.icon,
    this.trailingIcon,
    this.width,
    this.height = 48.0,
  });

  @override
  Widget build(BuildContext context) {
    final isEnabled = onPressed != null && !isLoading;

    final (bgColor, textColor, border) = switch (variant) {
      AppButtonVariant.primary => (
        isEnabled ? AppColors.burgundy : AppColors.line,
        isEnabled ? AppColors.white : AppColors.muted,
        null,
      ),
      AppButtonVariant.secondary => (
        AppColors.transparent,
        isEnabled ? AppColors.burgundy : AppColors.muted,
        Border.all(
          color: isEnabled ? AppColors.burgundy : AppColors.line,
          width: 1.0,
        ),
      ),
      AppButtonVariant.text => (
        AppColors.transparent,
        isEnabled ? AppColors.burgundy : AppColors.muted,
        null,
      ),
    };

    final content = Row(
      mainAxisSize: width == null ? MainAxisSize.min : MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isLoading)
          SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(textColor),
            ),
          )
        else ...[
          if (icon != null) ...[icon!, const SizedBox(width: AppSpacing.s8)],
          AppText.label(label, color: textColor),
          if (trailingIcon != null) ...[
            const SizedBox(width: AppSpacing.s8),
            trailingIcon!,
          ],
        ],
      ],
    );

    return AppContainer(
      width: width,
      height: height,
      color: bgColor,
      border: border,
      radius: AppRadius.pill,
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: AppSpacing.s24,
      ),
      onTap: isEnabled ? onPressed : null,
      child: Center(widthFactor: width == null ? 1.0 : null, child: content),
    );
  }
}
