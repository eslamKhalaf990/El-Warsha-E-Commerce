import 'package:flutter/material.dart';

import 'package:warsha_commerce/core/theme/app_colors.dart';
import 'package:warsha_commerce/core/theme/app_radius.dart';
import 'package:warsha_commerce/core/theme/app_spacing.dart';

enum _AppContainerVariant { surface, blush, filled, outlined, ivory, custom }

/// Unified container / surface widget for card-like surfaces and panels.
/// Supports 5 main variants: surface, blush, filled, outlined, ivory.
class AppContainer extends StatefulWidget {
  final Widget? child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final double radius;
  final Color? color;
  final BoxBorder? border;
  final double? width;
  final double? height;
  final List<BoxShadow>? shadow;
  final Clip clipBehavior;
  final VoidCallback? onTap;
  final _AppContainerVariant _variant;

  const AppContainer({
    super.key,
    this.child,
    this.padding = const EdgeInsetsDirectional.all(AppSpacing.s16),
    this.margin,
    this.radius = AppRadius.card,
    this.color,
    this.border,
    this.width,
    this.height,
    this.shadow,
    this.clipBehavior = Clip.antiAlias,
    this.onTap,
  }) : _variant = _AppContainerVariant.custom;

  /// Surface variant: white fill + line border (default card look)
  const AppContainer.surface({
    super.key,
    this.child,
    this.padding = const EdgeInsetsDirectional.all(AppSpacing.s16),
    this.margin,
    this.radius = AppRadius.card,
    this.color,
    this.border,
    this.width,
    this.height,
    this.shadow,
    this.clipBehavior = Clip.antiAlias,
    this.onTap,
  }) : _variant = _AppContainerVariant.surface;

  /// Blush variant: blush fill, no border
  const AppContainer.blush({
    super.key,
    this.child,
    this.padding = const EdgeInsetsDirectional.all(AppSpacing.s16),
    this.margin,
    this.radius = AppRadius.card,
    this.color,
    this.border,
    this.width,
    this.height,
    this.shadow,
    this.clipBehavior = Clip.antiAlias,
    this.onTap,
  }) : _variant = _AppContainerVariant.blush;

  /// Filled variant: burgundy fill, no border
  const AppContainer.filled({
    super.key,
    this.child,
    this.padding = const EdgeInsetsDirectional.all(AppSpacing.s16),
    this.margin,
    this.radius = AppRadius.card,
    this.color,
    this.border,
    this.width,
    this.height,
    this.shadow,
    this.clipBehavior = Clip.antiAlias,
    this.onTap,
  }) : _variant = _AppContainerVariant.filled;

  /// Outlined variant: transparent fill + 1px line border
  const AppContainer.outlined({
    super.key,
    this.child,
    this.padding = const EdgeInsetsDirectional.all(AppSpacing.s16),
    this.margin,
    this.radius = AppRadius.card,
    this.color,
    this.border,
    this.width,
    this.height,
    this.shadow,
    this.clipBehavior = Clip.antiAlias,
    this.onTap,
  }) : _variant = _AppContainerVariant.outlined;

  /// Ivory variant: ivory fill, no border
  const AppContainer.ivory({
    super.key,
    this.child,
    this.padding = const EdgeInsetsDirectional.all(AppSpacing.s16),
    this.margin,
    this.radius = AppRadius.card,
    this.color,
    this.border,
    this.width,
    this.height,
    this.shadow,
    this.clipBehavior = Clip.antiAlias,
    this.onTap,
  }) : _variant = _AppContainerVariant.ivory;

  @override
  State<AppContainer> createState() => _AppContainerState();
}

class _AppContainerState extends State<AppContainer> {
  bool _isFocused = false;

  Color _resolveBackgroundColor() {
    if (widget.color != null) return widget.color!;
    return switch (widget._variant) {
      _AppContainerVariant.surface => AppColors.white,
      _AppContainerVariant.blush => AppColors.blush,
      _AppContainerVariant.filled => AppColors.burgundy,
      _AppContainerVariant.outlined => AppColors.transparent,
      _AppContainerVariant.ivory => AppColors.ivory,
      _AppContainerVariant.custom => AppColors.white,
    };
  }

  BoxBorder? _resolveBorder() {
    if (_isFocused && widget.onTap != null) {
      return Border.all(color: AppColors.burgundy, width: 2.0);
    }
    if (widget.border != null) return widget.border;
    return switch (widget._variant) {
      _AppContainerVariant.surface => Border.all(
        color: AppColors.line,
        width: 1.0,
      ),
      _AppContainerVariant.blush => null,
      _AppContainerVariant.filled => null,
      _AppContainerVariant.outlined => Border.all(
        color: AppColors.line,
        width: 1.0,
      ),
      _AppContainerVariant.ivory => null,
      _AppContainerVariant.custom => null,
    };
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = _resolveBackgroundColor();
    final border = _resolveBorder();
    final borderRadius = BorderRadius.circular(widget.radius);

    final isTappable = widget.onTap != null;

    if (!isTappable) {
      return Container(
        width: widget.width,
        height: widget.height,
        margin: widget.margin,
        decoration: BoxDecoration(
          color: bgColor,
          border: border,
          borderRadius: borderRadius,
          boxShadow: widget.shadow,
        ),
        clipBehavior: widget.clipBehavior,
        child: Padding(padding: widget.padding, child: widget.child),
      );
    }

    final isDarkBackground =
        widget._variant == _AppContainerVariant.filled ||
        bgColor == AppColors.burgundy ||
        bgColor == AppColors.deepWine;

    final hoverColor = isDarkBackground
        ? AppColors.white.withValues(alpha: 0.08)
        : AppColors.burgundy.withValues(alpha: 0.04);
    final splashColor = isDarkBackground
        ? AppColors.white.withValues(alpha: 0.16)
        : AppColors.burgundy.withValues(alpha: 0.10);

    return Container(
      width: widget.width,
      height: widget.height,
      margin: widget.margin,
      decoration: BoxDecoration(
        color: bgColor,
        border: border,
        borderRadius: borderRadius,
        boxShadow: widget.shadow,
      ),
      clipBehavior: widget.clipBehavior,
      child: Material(
        color: AppColors.transparent,
        child: InkWell(
          borderRadius: borderRadius,
          mouseCursor: SystemMouseCursors.click,
          hoverColor: hoverColor,
          splashColor: splashColor,
          onFocusChange: (focused) => setState(() => _isFocused = focused),
          onTap: widget.onTap,
          child: Padding(padding: widget.padding, child: widget.child),
        ),
      ),
    );
  }
}
