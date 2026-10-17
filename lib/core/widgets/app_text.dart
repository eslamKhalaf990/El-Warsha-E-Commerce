import 'package:flutter/material.dart';

enum _AppTextStyleVariant {
  display,
  headline,
  title,
  titleSmall,
  body,
  bodySmall,
  caption,
  label,
  price,
}

/// Unified text widget for the application.
/// Feature code must use [AppText] instead of raw [Text] or inline [TextStyle].
class AppText extends StatelessWidget {
  final String text;
  final _AppTextStyleVariant _variant;
  final Color? color;
  final FontWeight? weight;
  final int? maxLines;
  final TextOverflow? overflow;
  final TextAlign? textAlign;
  final TextDecoration? decoration;
  final bool? softWrap;

  const AppText.display(
    this.text, {
    super.key,
    this.color,
    this.weight,
    this.maxLines,
    this.overflow,
    this.textAlign,
    this.decoration,
    this.softWrap,
  }) : _variant = _AppTextStyleVariant.display;

  const AppText.headline(
    this.text, {
    super.key,
    this.color,
    this.weight,
    this.maxLines,
    this.overflow,
    this.textAlign,
    this.decoration,
    this.softWrap,
  }) : _variant = _AppTextStyleVariant.headline;

  const AppText.title(
    this.text, {
    super.key,
    this.color,
    this.weight,
    this.maxLines,
    this.overflow,
    this.textAlign,
    this.decoration,
    this.softWrap,
  }) : _variant = _AppTextStyleVariant.title;

  const AppText.titleSmall(
    this.text, {
    super.key,
    this.color,
    this.weight,
    this.maxLines,
    this.overflow,
    this.textAlign,
    this.decoration,
    this.softWrap,
  }) : _variant = _AppTextStyleVariant.titleSmall;

  const AppText.body(
    this.text, {
    super.key,
    this.color,
    this.weight,
    this.maxLines,
    this.overflow,
    this.textAlign,
    this.decoration,
    this.softWrap,
  }) : _variant = _AppTextStyleVariant.body;

  const AppText.bodySmall(
    this.text, {
    super.key,
    this.color,
    this.weight,
    this.maxLines,
    this.overflow,
    this.textAlign,
    this.decoration,
    this.softWrap,
  }) : _variant = _AppTextStyleVariant.bodySmall;

  const AppText.caption(
    this.text, {
    super.key,
    this.color,
    this.weight,
    this.maxLines,
    this.overflow,
    this.textAlign,
    this.decoration,
    this.softWrap,
  }) : _variant = _AppTextStyleVariant.caption;

  const AppText.label(
    this.text, {
    super.key,
    this.color,
    this.weight,
    this.maxLines,
    this.overflow,
    this.textAlign,
    this.decoration,
    this.softWrap,
  }) : _variant = _AppTextStyleVariant.label;

  const AppText.price(
    this.text, {
    super.key,
    this.color,
    this.weight,
    this.maxLines,
    this.overflow,
    this.textAlign,
    this.decoration,
    this.softWrap,
  }) : _variant = _AppTextStyleVariant.price;

  TextStyle? _resolveBaseStyle(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return switch (_variant) {
      _AppTextStyleVariant.display => textTheme.displayLarge,
      _AppTextStyleVariant.headline => textTheme.headlineMedium,
      _AppTextStyleVariant.title => textTheme.titleLarge,
      _AppTextStyleVariant.titleSmall => textTheme.titleSmall,
      _AppTextStyleVariant.body => textTheme.bodyLarge,
      _AppTextStyleVariant.bodySmall => textTheme.bodySmall,
      _AppTextStyleVariant.caption => textTheme.labelSmall,
      _AppTextStyleVariant.label => textTheme.labelLarge,
      _AppTextStyleVariant.price => textTheme.titleMedium,
    };
  }

  @override
  Widget build(BuildContext context) {
    final baseStyle = _resolveBaseStyle(context);
    final effectiveStyle = baseStyle?.copyWith(
      color: color,
      fontWeight: weight,
      decoration: decoration,
    );

    return Text(
      text,
      style: effectiveStyle,
      maxLines: maxLines,
      overflow: overflow,
      textAlign: textAlign,
      softWrap: softWrap,
    );
  }
}
