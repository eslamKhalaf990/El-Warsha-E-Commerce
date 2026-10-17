import 'package:flutter/material.dart';
import 'package:warsha_commerce/core/theme/app_colors.dart';
import 'package:warsha_commerce/core/theme/app_spacing.dart';
import 'package:warsha_commerce/core/widgets/app_text.dart';

/// Read-only star rating display
class RatingStars extends StatelessWidget {
  final double rating;
  final double size;
  final Color filledColor;
  final Color emptyColor;
  final bool showRatingNumber;
  final Color? textColor;

  const RatingStars({
    super.key,
    required this.rating,
    this.size = 16,
    this.filledColor = const Color(0xFFFFB800),
    this.emptyColor = const Color(0xFFE0D5D8),
    this.showRatingNumber = false,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(5, (index) {
            final starNumber = index + 1;
            IconData icon;
            Color color;

            if (rating >= starNumber) {
              icon = Icons.star_rounded;
              color = filledColor;
            } else if (rating >= starNumber - 0.5) {
              icon = Icons.star_half_rounded;
              color = filledColor;
            } else {
              icon = Icons.star_rounded;
              color = emptyColor;
            }

            return Icon(icon, size: size, color: color);
          }),
        ),
        if (showRatingNumber) ...[
          const SizedBox(width: AppSpacing.s8),
          AppText.bodySmall(
            rating.toStringAsFixed(1),
            color: textColor ?? AppColors.deepWine,
            weight: FontWeight.w700,
          ),
        ],
      ],
    );
  }
}

/// Interactive 1 to 5 star rating picker with Arabic descriptor labels
class InteractiveRatingPicker extends StatefulWidget {
  final int initialRating;
  final ValueChanged<int> onRatingChanged;
  final double starSize;

  const InteractiveRatingPicker({
    super.key,
    this.initialRating = 5,
    required this.onRatingChanged,
    this.starSize = 36,
  });

  @override
  State<InteractiveRatingPicker> createState() =>
      _InteractiveRatingPickerState();
}

class _InteractiveRatingPickerState extends State<InteractiveRatingPicker> {
  late int _currentRating;
  int? _hoveredRating;

  @override
  void initState() {
    super.initState();
    _currentRating = widget.initialRating;
  }

  String _getRatingLabel(int rating) {
    switch (rating) {
      case 5:
        return 'ممتاز — فاق التوقعات!';
      case 4:
        return 'جيد جداً — منتج رائع';
      case 3:
        return 'جيد — تجربة مقبولة';
      case 2:
        return 'مقبول — يحتاج إلى تحسين';
      case 1:
        return 'ضعيف — تجربة غير مرضية';
      default:
        return 'اختر التقييم من 1 إلى 5 نجوم';
    }
  }

  @override
  Widget build(BuildContext context) {
    final activeRating = _hoveredRating ?? _currentRating;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) {
            final starValue = index + 1;
            final isFilled = starValue <= activeRating;

            return MouseRegion(
              onEnter: (_) => setState(() => _hoveredRating = starValue),
              onExit: (_) => setState(() => _hoveredRating = null),
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {
                  setState(() => _currentRating = starValue);
                  widget.onRatingChanged(starValue);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: AnimatedScale(
                    scale: starValue <= activeRating ? 1.15 : 1.0,
                    duration: const Duration(milliseconds: 150),
                    child: Icon(
                      Icons.star_rounded,
                      size: widget.starSize,
                      color: isFilled
                          ? const Color(0xFFFFB800)
                          : const Color(0xFFDED2D5),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: AppSpacing.s8),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 180),
          child: AppText.caption(
            _getRatingLabel(activeRating),
            key: ValueKey(activeRating),
            color: AppColors.burgundy,
            weight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
