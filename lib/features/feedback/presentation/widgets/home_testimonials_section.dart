import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';

import 'package:warsha_commerce/core/theme/app_colors.dart';
import 'package:warsha_commerce/core/theme/app_radius.dart';
import 'package:warsha_commerce/core/theme/app_spacing.dart';
import 'package:warsha_commerce/core/utils/breakpoints.dart';
import 'package:warsha_commerce/core/widgets/app_button.dart';
import 'package:warsha_commerce/core/widgets/app_container.dart';
import 'package:warsha_commerce/core/widgets/app_text.dart';
import 'package:warsha_commerce/features/feedback/presentation/cubit/testimonials_cubit.dart';
import 'package:warsha_commerce/features/feedback/presentation/cubit/testimonials_state.dart';
import 'package:warsha_commerce/features/feedback/presentation/widgets/feedback_card.dart';
import 'package:warsha_commerce/features/feedback/presentation/widgets/feedback_submission_modal.dart';

class HomeTestimonialsSection extends StatefulWidget {
  const HomeTestimonialsSection({super.key});

  @override
  State<HomeTestimonialsSection> createState() =>
      _HomeTestimonialsSectionState();
}

class _HomeTestimonialsSectionState extends State<HomeTestimonialsSection> {
  late final PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.92);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = context.isDesktop;

    return BlocBuilder<TestimonialsCubit, TestimonialsState>(
      builder: (context, state) {
        if (state.status == TestimonialsStatus.loading &&
            state.testimonials.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(AppSpacing.s32),
              child: CircularProgressIndicator(color: AppColors.burgundy),
            ),
          );
        }

        final testimonials = state.testimonials;
        if (testimonials.isEmpty && state.status == TestimonialsStatus.success) {
          return const SizedBox.shrink();
        }

        return AppContainer.surface(
          padding: EdgeInsetsDirectional.all(
            isDesktop ? AppSpacing.s32 : AppSpacing.s16,
          ),
          radius: AppRadius.card,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Trust Header & Eyebrow Badge
              Center(
                child: Container(
                  padding: const EdgeInsetsDirectional.symmetric(
                    horizontal: AppSpacing.s12,
                    vertical: AppSpacing.s8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.blush,
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Iconsax.shield_tick,
                        size: 16,
                        color: AppColors.burgundy,
                      ),
                      SizedBox(width: AppSpacing.s8),
                      AppText.caption(
                        'ثقة عملائنا سر تميزنا',
                        color: AppColors.burgundy,
                        weight: FontWeight.w700,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.s12),

              // Section Title
              const Center(
                child: AppText.headline(
                  'آراء وتجارب عملاء الورشة',
                  color: AppColors.deepWine,
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: AppSpacing.s8),

              // Subtitle
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 620),
                  child: const AppText.body(
                    'نفتخر بثقة أكثر من 15,000 عميل في صياغتنا اليدوية الفاخرة وخاماتنا المطلية بعناية لتدوم.',
                    color: AppColors.muted,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.s24),

              // Trust Metrics Bar
              _buildTrustMetricsBar(context),

              const SizedBox(height: AppSpacing.s32),

              // 2. Reviews Display (Desktop Grid vs Mobile Carousel)
              if (isDesktop)
                _buildDesktopGrid(context, testimonials)
              else
                _buildMobileCarousel(context, testimonials),

              const SizedBox(height: AppSpacing.s32),

              // 3. Bottom CTA: "أضف تجربتك ورأيك"
              Center(
                child: AppButton.primary(
                  label: 'أضف تجربتك ورأيك في الورشة',
                  onPressed: () {
                    FeedbackSubmissionModal.show(
                      context,
                      onSuccess: () {
                        context
                            .read<TestimonialsCubit>()
                            .loadFeaturedTestimonials();
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTrustMetricsBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s16,
        vertical: AppSpacing.s16,
      ),
      decoration: BoxDecoration(
        color: AppColors.ivory,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColors.line),
      ),
      child: Wrap(
        alignment: WrapAlignment.spaceAround,
        runAlignment: WrapAlignment.center,
        spacing: AppSpacing.s24,
        runSpacing: AppSpacing.s16,
        children: [
          _buildMetricItem(
            icon: Iconsax.star5,
            iconColor: const Color(0xFFFFB800),
            title: '4.9 من 5.0',
            subtitle: 'متوسط تقييم العملاء العام',
          ),
          _buildMetricItem(
            icon: Iconsax.like_1,
            iconColor: const Color(0xFF166534),
            title: '99.4%',
            subtitle: 'نسبة رضا وتوصية المشترين',
          ),
          _buildMetricItem(
            icon: Iconsax.medal_star,
            iconColor: AppColors.burgundy,
            title: '100% صياغة أصلية',
            subtitle: 'ضمان استبدال وتغليف هدية فاخر',
          ),
        ],
      ),
    );
  }

  Widget _buildMetricItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(AppSpacing.s8),
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: iconColor, size: 22),
        ),
        const SizedBox(width: AppSpacing.s12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            AppText.label(
              title,
              color: AppColors.deepWine,
              weight: FontWeight.w800,
            ),
            const SizedBox(height: 2),
            AppText.caption(subtitle, color: AppColors.muted),
          ],
        ),
      ],
    );
  }

  Widget _buildDesktopGrid(BuildContext context, List testimonials) {
    // Show top 3 or 4 testimonials in a responsive layout
    final displayItems = testimonials.take(3).toList();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: displayItems.map((item) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsetsDirectional.symmetric(
              horizontal: AppSpacing.s8,
            ),
            child: FeedbackCard(
              feedback: item,
              showComments: false, // compact for home showcase
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildMobileCarousel(BuildContext context, List testimonials) {
    final displayItems = testimonials.take(6).toList();

    return Column(
      children: [
        SizedBox(
          height: 310,
          child: PageView.builder(
            controller: _pageController,
            itemCount: displayItems.length,
            onPageChanged: (idx) => setState(() => _currentPage = idx),
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsetsDirectional.only(end: AppSpacing.s12),
                child: FeedbackCard(
                  feedback: displayItems[index],
                  showComments: false,
                ),
              );
            },
          ),
        ),
        const SizedBox(height: AppSpacing.s16),
        // Dots indicator
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(displayItems.length, (index) {
            final isSelected = index == _currentPage;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: isSelected ? 24 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.burgundy : AppColors.line,
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
            );
          }),
        ),
      ],
    );
  }
}
