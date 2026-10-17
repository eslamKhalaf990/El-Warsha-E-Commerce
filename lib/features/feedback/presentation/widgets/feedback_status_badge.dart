import 'package:flutter/material.dart';
import 'package:warsha_commerce/core/theme/app_radius.dart';
import 'package:warsha_commerce/core/theme/app_spacing.dart';
import 'package:warsha_commerce/core/widgets/app_container.dart';
import 'package:warsha_commerce/core/widgets/app_text.dart';
import 'package:warsha_commerce/features/feedback/domain/entities/feedback_status.dart';

class FeedbackStatusBadge extends StatelessWidget {
  final FeedbackStatus status;

  const FeedbackStatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color textColor;
    Color bgColor;

    switch (status) {
      case FeedbackStatus.pending:
        textColor = const Color(0xFF925700); // Amber/Yellow
        bgColor = const Color(0xFFFEF3C7);
        break;
      case FeedbackStatus.approved:
        textColor = const Color(0xFF166534); // Green
        bgColor = const Color(0xFFDCFCE7);
        break;
      case FeedbackStatus.resolved:
        textColor = const Color(0xFF1E40AF); // Blue
        bgColor = const Color(0xFFDBEAFE);
        break;
      case FeedbackStatus.rejected:
        textColor = const Color(0xFF991B1B); // Red
        bgColor = const Color(0xFFFEE2E2);
        break;
    }

    return AppContainer(
      color: bgColor,
      radius: AppRadius.pill,
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: AppSpacing.s12,
        vertical: AppSpacing.s4,
      ),
      child: AppText.caption(
        status.labelAr,
        color: textColor,
        weight: FontWeight.w700,
      ),
    );
  }
}
