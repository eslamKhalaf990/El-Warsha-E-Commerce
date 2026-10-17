import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';

import 'package:warsha_commerce/core/di/di.dart';
import 'package:warsha_commerce/core/theme/app_colors.dart';
import 'package:warsha_commerce/core/theme/app_radius.dart';
import 'package:warsha_commerce/core/theme/app_spacing.dart';
import 'package:warsha_commerce/core/widgets/app_button.dart';
import 'package:warsha_commerce/core/widgets/app_container.dart';
import 'package:warsha_commerce/core/widgets/app_text.dart';
import 'package:warsha_commerce/core/widgets/loading_view.dart';
import 'package:warsha_commerce/features/catalog/domain/entities/product.dart';
import 'package:warsha_commerce/features/feedback/domain/entities/feedback_type.dart';
import 'package:warsha_commerce/features/feedback/domain/entities/product_feedback_summary.dart';
import 'package:warsha_commerce/features/feedback/presentation/cubit/product_feedback_cubit.dart';
import 'package:warsha_commerce/features/feedback/presentation/cubit/product_feedback_state.dart';
import 'package:warsha_commerce/features/feedback/presentation/widgets/feedback_card.dart';
import 'package:warsha_commerce/features/feedback/presentation/widgets/feedback_submission_modal.dart';
import 'package:warsha_commerce/features/feedback/presentation/widgets/rating_stars.dart';

class ProductReviewsTabContent extends StatelessWidget {
  final Product product;

  const ProductReviewsTabContent({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProductFeedbackCubit>(
      create: (_) => sl<ProductFeedbackCubit>()..loadProductReviews(product.id),
      child: _ProductReviewsBody(product: product),
    );
  }
}

class _ProductReviewsBody extends StatelessWidget {
  final Product product;

  const _ProductReviewsBody({required this.product});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductFeedbackCubit, ProductFeedbackState>(
      builder: (context, state) {
        if (state.status == ProductFeedbackStatus.loading &&
            state.summary == null) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(AppSpacing.s32),
              child: LoadingView(),
            ),
          );
        }

        if (state.status == ProductFeedbackStatus.failure &&
            state.summary == null) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.s24),
              child: Column(
                children: [
                  AppText.body(
                    state.errorMessage ?? 'فشل في تحميل تقييمات المنتج',
                    color: AppColors.muted,
                  ),
                  const SizedBox(height: AppSpacing.s12),
                  AppButton.secondary(
                    label: 'إعادة المحاولة',
                    onPressed: () => context
                        .read<ProductFeedbackCubit>()
                        .loadProductReviews(product.id),
                  ),
                ],
              ),
            ),
          );
        }

        final summary =
            state.summary ?? ProductFeedbackSummary.empty(product.id);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Rating Summary Header Block
            _buildRatingSummaryBlock(context, summary),

            const SizedBox(height: AppSpacing.s24),

            // 2. Customer Reviews List
            if (summary.reviews.isEmpty)
              _buildEmptyState(context)
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Iconsax.messages_2,
                        size: 20,
                        color: AppColors.burgundy,
                      ),
                      const SizedBox(width: AppSpacing.s8),
                      AppText.title(
                        'تقييمات العملاء (${summary.totalReviews})',
                        color: AppColors.deepWine,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.s16),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: summary.reviews.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: AppSpacing.s16),
                    itemBuilder: (context, index) {
                      final item = summary.reviews[index];
                      return FeedbackCard(
                        feedback: item,
                        showComments: true,
                        onAddComment: (feedbackId, text, author) => context
                            .read<ProductFeedbackCubit>()
                            .addComment(
                              feedbackId: feedbackId,
                              commentText: text,
                              authorName: author,
                            ),
                      );
                    },
                  ),
                ],
              ),
          ],
        );
      },
    );
  }

  Widget _buildRatingSummaryBlock(
    BuildContext context,
    ProductFeedbackSummary summary,
  ) {
    return AppContainer(
      color: AppColors.ivory,
      radius: AppRadius.card,
      padding: const EdgeInsetsDirectional.all(AppSpacing.s16),
      border: Border.all(color: AppColors.line),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isNarrow = constraints.maxWidth < 480;

          return Column(
            children: [
              if (isNarrow)
                Column(
                  children: [
                    _buildAverageScore(summary),
                    const SizedBox(height: AppSpacing.s16),
                    _buildDistributionBars(summary),
                  ],
                )
              else
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(flex: 4, child: _buildAverageScore(summary)),
                    Container(
                      width: 1,
                      height: 140,
                      color: AppColors.line,
                      margin: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.s16,
                      ),
                    ),
                    Expanded(flex: 6, child: _buildDistributionBars(summary)),
                  ],
                ),

              const SizedBox(height: AppSpacing.s16),
              const Divider(color: AppColors.line, height: 1),
              const SizedBox(height: AppSpacing.s16),

              // "أضف تقييمك للمنتج" CTA Button
              Center(
                child: AppButton.primary(
                  label: 'أضف تقييمك للمنتج',
                  icon: const Icon(
                    Iconsax.edit,
                    size: 18,
                    color: AppColors.white,
                  ),
                  onPressed: () {
                    FeedbackSubmissionModal.show(
                      context,
                      productId: product.id,
                      productName: product.name,
                      defaultType: FeedbackType.product,
                      onSuccess: () {
                        context
                            .read<ProductFeedbackCubit>()
                            .loadProductReviews(product.id);
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAverageScore(ProductFeedbackSummary summary) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        AppText.display(
          summary.averageRating.toStringAsFixed(1),
          color: AppColors.deepWine,
          weight: FontWeight.w800,
        ),
        const SizedBox(height: AppSpacing.s4),
        RatingStars(
          rating: summary.averageRating,
          size: 22,
        ),
        const SizedBox(height: AppSpacing.s8),
        AppText.caption(
          summary.totalReviews > 0
              ? 'بناءً على ${summary.totalReviews} تقييماً موثقاً'
              : 'لا توجد تقييمات بعد',
          color: AppColors.muted,
          weight: FontWeight.w600,
        ),
      ],
    );
  }

  Widget _buildDistributionBars(ProductFeedbackSummary summary) {
    final total = summary.totalReviews > 0 ? summary.totalReviews : 1;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [5, 4, 3, 2, 1].map((star) {
        final count = summary.ratingDistribution[star] ?? 0;
        final percentage = summary.totalReviews > 0 ? (count / total) : 0.0;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 2.0),
          child: Row(
            children: [
              SizedBox(
                width: 48,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppText.caption(
                      '$star',
                      color: AppColors.deepWine,
                      weight: FontWeight.w700,
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.star_rounded,
                      size: 14,
                      color: Color(0xFFFFB800),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.s8),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                  child: LinearProgressIndicator(
                    value: percentage,
                    minHeight: 8,
                    backgroundColor: AppColors.line.withValues(alpha: 0.6),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Color(0xFFFFB800),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.s12),
              SizedBox(
                width: 32,
                child: AppText.caption(
                  '$count',
                  color: AppColors.muted,
                  weight: FontWeight.w600,
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.s32),
      decoration: BoxDecoration(
        color: AppColors.ivory,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        children: [
          const Icon(
            Iconsax.star_1,
            size: 48,
            color: AppColors.champagne,
          ),
          const SizedBox(height: AppSpacing.s16),
          const AppText.title(
            'كن أول من يشاركنا رأيه في هذا المنتج!',
            color: AppColors.deepWine,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.s8),
          const AppText.body(
            'رأيك يساعد زوار المتجر وعشاق الأناقة على اختيار القطعة المناسبة بدقة.',
            color: AppColors.muted,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.s16),
          AppButton.primary(
            label: 'اكتب تقييمك الآن',
            onPressed: () {
              FeedbackSubmissionModal.show(
                context,
                productId: product.id,
                productName: product.name,
                defaultType: FeedbackType.product,
                onSuccess: () {
                  context
                      .read<ProductFeedbackCubit>()
                      .loadProductReviews(product.id);
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
