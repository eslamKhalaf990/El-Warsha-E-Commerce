import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

import 'package:warsha_commerce/core/theme/app_colors.dart';
import 'package:warsha_commerce/core/theme/app_radius.dart';
import 'package:warsha_commerce/core/theme/app_spacing.dart';
import 'package:warsha_commerce/core/widgets/app_button.dart';
import 'package:warsha_commerce/core/widgets/app_container.dart';
import 'package:warsha_commerce/core/widgets/app_text.dart';
import 'package:warsha_commerce/features/feedback/domain/entities/feedback_comment.dart';
import 'package:warsha_commerce/features/feedback/domain/entities/feedback_item.dart';
import 'package:warsha_commerce/features/feedback/presentation/widgets/feedback_status_badge.dart';
import 'package:warsha_commerce/features/feedback/presentation/widgets/rating_stars.dart';

class FeedbackCard extends StatefulWidget {
  final FeedbackItem feedback;
  final bool showStatus;
  final bool showComments;
  final Future<bool> Function(int feedbackId, String text, String? author)?
      onAddComment;

  const FeedbackCard({
    super.key,
    required this.feedback,
    this.showStatus = false,
    this.showComments = true,
    this.onAddComment,
  });

  @override
  State<FeedbackCard> createState() => _FeedbackCardState();
}

class _FeedbackCardState extends State<FeedbackCard> {
  bool _isCommentsExpanded = false;
  bool _isReplying = false;
  bool _isSubmittingReply = false;

  final TextEditingController _commentController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    _authorController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);

    if (diff.inDays == 0) {
      if (diff.inHours == 0) {
        return 'منذ لحظات';
      }
      return 'منذ ${diff.inHours} ساعة';
    } else if (diff.inDays == 1) {
      return 'أمس';
    } else if (diff.inDays < 7) {
      return 'منذ ${diff.inDays} أيام';
    }
    return DateFormat('d MMMM yyyy', 'ar').format(dt);
  }

  Future<void> _submitReply() async {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;

    setState(() => _isSubmittingReply = true);
    final author = _authorController.text.trim().isNotEmpty
        ? _authorController.text.trim()
        : null;

    final success = await widget.onAddComment?.call(
          widget.feedback.id,
          text,
          author,
        ) ??
        false;

    if (mounted) {
      setState(() => _isSubmittingReply = false);
      if (success) {
        _commentController.clear();
        _authorController.clear();
        setState(() {
          _isReplying = false;
          _isCommentsExpanded = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final feedback = widget.feedback;
    final initials = feedback.customerName.isNotEmpty
        ? feedback.customerName.trim().substring(0, 1)
        : 'ع';

    return AppContainer.surface(
      padding: const EdgeInsetsDirectional.all(AppSpacing.s16),
      radius: AppRadius.card,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Avatar, Name, Verified badge, Date, Status
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Avatar circle
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.burgundy, AppColors.deepWine],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                ),
                child: Center(
                  child: AppText.label(
                    initials,
                    color: AppColors.white,
                    weight: FontWeight.w700,
                  ),
                ),
              ),

              const SizedBox(width: AppSpacing.s12),

              // Name, verified badge and date
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: AppText.label(
                            feedback.customerName,
                            color: AppColors.deepWine,
                            weight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.s8),
                        Container(
                          padding: const EdgeInsetsDirectional.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFDCFCE7),
                            borderRadius: BorderRadius.circular(AppRadius.pill),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.check_circle_rounded,
                                size: 12,
                                color: Color(0xFF166534),
                              ),
                              SizedBox(width: 3),
                              AppText.caption(
                                'مشترٍ موثق',
                                color: Color(0xFF166534),
                                weight: FontWeight.w600,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    AppText.caption(
                      _formatDate(feedback.createdAt),
                      color: AppColors.muted,
                    ),
                  ],
                ),
              ),

              // Status badge (if showing in customer dashboard)
              if (widget.showStatus) FeedbackStatusBadge(status: feedback.status),
            ],
          ),

          const SizedBox(height: AppSpacing.s12),

          // Rating stars + Feedback type chip
          Row(
            children: [
              RatingStars(
                rating: feedback.rating.toDouble(),
                size: 18,
                showRatingNumber: true,
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsetsDirectional.symmetric(
                  horizontal: 8,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: AppColors.blush,
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                ),
                child: AppText.caption(
                  feedback.feedbackType.labelAr,
                  color: AppColors.burgundy,
                  weight: FontWeight.w600,
                ),
              ),
            ],
          ),

          // Subject (if present)
          if (feedback.subject != null &&
              feedback.subject!.trim().isNotEmpty) ...[
            const SizedBox(height: AppSpacing.s12),
            AppText.body(
              feedback.subject!,
              color: AppColors.deepWine,
              weight: FontWeight.w700,
            ),
          ],

          // Comment body
          const SizedBox(height: AppSpacing.s8),
          AppText.body(
            feedback.comment,
            color: AppColors.deepWine.withValues(alpha: 0.9),
          ),

          // Admin Reply Badge & Message (if present)
          if (feedback.hasAdminReply) ...[
            const SizedBox(height: AppSpacing.s16),
            Container(
              padding: const EdgeInsetsDirectional.all(AppSpacing.s16),
              decoration: BoxDecoration(
                color: AppColors.blush.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(AppRadius.card),
                border: const Border(
                  right: BorderSide(color: AppColors.burgundy, width: 4),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Iconsax.verify5,
                        size: 16,
                        color: AppColors.burgundy,
                      ),
                      const SizedBox(width: AppSpacing.s8),
                      AppText.label(
                        feedback.repliedBy ?? 'رد إدارة متجر الورشة',
                        color: AppColors.burgundy,
                        weight: FontWeight.w700,
                      ),
                      const Spacer(),
                      if (feedback.repliedAt != null)
                        AppText.caption(
                          _formatDate(feedback.repliedAt!),
                          color: AppColors.muted,
                        ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.s8),
                  AppText.bodySmall(
                    feedback.adminReply!,
                    color: AppColors.deepWine,
                  ),
                ],
              ),
            ),
          ],

          // Comments / Inquiries Thread Section
          if (widget.showComments) ...[
            const SizedBox(height: AppSpacing.s16),
            const Divider(color: AppColors.line, height: 1),
            const SizedBox(height: AppSpacing.s12),

            // Actions bar: Toggle comments / Reply button
            Row(
              children: [
                if (feedback.comments.isNotEmpty)
                  InkWell(
                    onTap: () => setState(
                      () => _isCommentsExpanded = !_isCommentsExpanded,
                    ),
                    borderRadius: BorderRadius.circular(AppRadius.small),
                    child: Padding(
                      padding: const EdgeInsetsDirectional.symmetric(
                        horizontal: AppSpacing.s8,
                        vertical: AppSpacing.s4,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Iconsax.message_text,
                            size: 16,
                            color: AppColors.burgundy,
                          ),
                          const SizedBox(width: AppSpacing.s8),
                          AppText.caption(
                            _isCommentsExpanded
                                ? 'إخفاء الردود (${feedback.comments.length})'
                                : 'عرض الردود (${feedback.comments.length})',
                            color: AppColors.burgundy,
                            weight: FontWeight.w700,
                          ),
                          const SizedBox(width: AppSpacing.s4),
                          Icon(
                            _isCommentsExpanded
                                ? Icons.keyboard_arrow_up_rounded
                                : Icons.keyboard_arrow_down_rounded,
                            size: 18,
                            color: AppColors.burgundy,
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  const AppText.caption(
                    'لا توجد تعليقات إضافية بعد',
                    color: AppColors.muted,
                  ),

                const Spacer(),

                if (widget.onAddComment != null)
                  TextButton.icon(
                    onPressed: () => setState(() => _isReplying = !_isReplying),
                    icon: Icon(
                      _isReplying ? Iconsax.close_circle : Iconsax.message_add,
                      size: 16,
                      color: AppColors.burgundy,
                    ),
                    label: AppText.caption(
                      _isReplying ? 'إلغاء' : 'إضافة استفسار أو رد',
                      color: AppColors.burgundy,
                      weight: FontWeight.w700,
                    ),
                  ),
              ],
            ),

            // Discussion Thread List
            if (_isCommentsExpanded && feedback.comments.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.s12),
              Column(
                children: feedback.comments.map(_buildCommentItem).toList(),
              ),
            ],

            // Add Reply Form
            if (_isReplying) ...[
              const SizedBox(height: AppSpacing.s12),
              Container(
                padding: const EdgeInsetsDirectional.all(AppSpacing.s12),
                decoration: BoxDecoration(
                  color: AppColors.ivory,
                  borderRadius: BorderRadius.circular(AppRadius.card),
                  border: Border.all(color: AppColors.line),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      controller: _authorController,
                      decoration: const InputDecoration(
                        labelText: 'اسمك (اختياري للزوار)',
                        contentPadding: EdgeInsetsDirectional.symmetric(
                          horizontal: AppSpacing.s12,
                          vertical: AppSpacing.s8,
                        ),
                        isDense: true,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.s8),
                    TextField(
                      controller: _commentController,
                      maxLines: 2,
                      decoration: const InputDecoration(
                        hintText: 'اكتب استفسارك أو ردك هنا...',
                        contentPadding: EdgeInsetsDirectional.symmetric(
                          horizontal: AppSpacing.s12,
                          vertical: AppSpacing.s8,
                        ),
                        isDense: true,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.s8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        AppButton.secondary(
                          label: 'إلغاء',
                          onPressed: () => setState(() => _isReplying = false),
                        ),
                        const SizedBox(width: AppSpacing.s8),
                        AppButton.primary(
                          label: _isSubmittingReply ? 'جاري الإرسال...' : 'إرسال الرد',
                          isLoading: _isSubmittingReply,
                          onPressed: _submitReply,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildCommentItem(FeedbackComment comment) {
    return Container(
      margin: const EdgeInsetsDirectional.only(bottom: AppSpacing.s8),
      padding: const EdgeInsetsDirectional.all(AppSpacing.s12),
      decoration: BoxDecoration(
        color: comment.isAdmin
            ? AppColors.blush.withValues(alpha: 0.5)
            : AppColors.ivory,
        borderRadius: BorderRadius.circular(AppRadius.small),
        border: Border.all(
          color: comment.isAdmin
              ? AppColors.burgundy.withValues(alpha: 0.3)
              : AppColors.line,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                comment.isAdmin ? Iconsax.verify5 : Iconsax.user,
                size: 14,
                color: comment.isAdmin ? AppColors.burgundy : AppColors.muted,
              ),
              const SizedBox(width: AppSpacing.s8),
              AppText.label(
                comment.authorName,
                color: comment.isAdmin ? AppColors.burgundy : AppColors.deepWine,
                weight: FontWeight.w700,
              ),
              if (comment.isAdmin) ...[
                const SizedBox(width: AppSpacing.s8),
                Container(
                  padding: const EdgeInsetsDirectional.symmetric(
                    horizontal: 6,
                    vertical: 1,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.burgundy,
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                  child: const AppText.caption(
                    'إدارة الورشة',
                    color: AppColors.white,
                    weight: FontWeight.w700,
                  ),
                ),
              ],
              const Spacer(),
              AppText.caption(
                _formatDate(comment.createdAt),
                color: AppColors.muted,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.s8),
          AppText.bodySmall(
            comment.commentText,
            color: AppColors.deepWine.withValues(alpha: 0.9),
          ),
        ],
      ),
    );
  }
}
