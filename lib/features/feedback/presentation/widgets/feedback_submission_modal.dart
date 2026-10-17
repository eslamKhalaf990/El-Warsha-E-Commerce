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
import 'package:warsha_commerce/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:warsha_commerce/features/feedback/data/models/create_feedback_payload.dart';
import 'package:warsha_commerce/features/feedback/domain/entities/feedback_type.dart';
import 'package:warsha_commerce/features/feedback/presentation/cubit/feedback_submission_cubit.dart';
import 'package:warsha_commerce/features/feedback/presentation/cubit/feedback_submission_state.dart';
import 'package:warsha_commerce/features/feedback/presentation/widgets/rating_stars.dart';

class FeedbackSubmissionModal extends StatefulWidget {
  final int? productId;
  final String? productName;
  final int? orderId;
  final FeedbackType? defaultType;
  final VoidCallback? onSuccess;

  const FeedbackSubmissionModal({
    super.key,
    this.productId,
    this.productName,
    this.orderId,
    this.defaultType,
    this.onSuccess,
  });

  static Future<void> show(
    BuildContext context, {
    int? productId,
    String? productName,
    int? orderId,
    FeedbackType? defaultType,
    VoidCallback? onSuccess,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) {
        return BlocProvider<FeedbackSubmissionCubit>(
          create: (_) => sl<FeedbackSubmissionCubit>(),
          child: Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.s16,
              vertical: AppSpacing.s24,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 580),
              child: FeedbackSubmissionModal(
                productId: productId,
                productName: productName,
                orderId: orderId,
                defaultType: defaultType,
                onSuccess: onSuccess,
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  State<FeedbackSubmissionModal> createState() =>
      _FeedbackSubmissionModalState();
}

class _FeedbackSubmissionModalState extends State<FeedbackSubmissionModal> {
  final _formKey = GlobalKey<FormState>();

  late int _rating;
  late FeedbackType _selectedType;
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();
  final TextEditingController _orderIdController = TextEditingController();

  // Guest inputs
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _rating = 5;
    _selectedType = widget.defaultType ??
        (widget.productId != null
            ? FeedbackType.product
            : FeedbackType.general);

    if (widget.orderId != null) {
      _orderIdController.text = widget.orderId.toString();
    }
  }

  @override
  void dispose() {
    _subjectController.dispose();
    _commentController.dispose();
    _orderIdController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _submit(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    final authState = context.read<AuthCubit>().state;
    final isLoggedIn = authState.isAuthenticated;

    final orderIdInt = int.tryParse(_orderIdController.text.trim()) ??
        widget.orderId;

    final payload = CreateFeedbackPayload(
      feedbackType: _selectedType,
      rating: _rating,
      subject: _subjectController.text.trim().isNotEmpty
          ? _subjectController.text.trim()
          : null,
      comment: _commentController.text.trim(),
      productId: widget.productId,
      orderId: orderIdInt,
      customerName: isLoggedIn
          ? authState.customer?.fullName
          : _nameController.text.trim(),
      customerEmail: isLoggedIn
          ? authState.customer?.email
          : (_emailController.text.trim().isNotEmpty
              ? _emailController.text.trim()
              : null),
      customerPhone: isLoggedIn
          ? authState.customer?.phone
          : (_phoneController.text.trim().isNotEmpty
              ? _phoneController.text.trim()
              : null),
    );

    final success = await context
        .read<FeedbackSubmissionCubit>()
        .submitFeedback(payload);

    if (success) {
      widget.onSuccess?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthCubit>().state;
    final isLoggedIn = authState.isAuthenticated;
    final customer = authState.customer;

    return AppContainer.surface(
      radius: AppRadius.card,
      padding: const EdgeInsetsDirectional.all(AppSpacing.s24),
      child: BlocBuilder<FeedbackSubmissionCubit, FeedbackSubmissionState>(
        builder: (context, state) {
          if (state.status == FeedbackSubmissionStatus.success) {
            return _buildSuccessView(context, state.successMessage);
          }

          return SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.s8),
                        decoration: BoxDecoration(
                          color: AppColors.blush,
                          borderRadius: BorderRadius.circular(AppRadius.small),
                        ),
                        child: const Icon(
                          Iconsax.star_1,
                          color: AppColors.burgundy,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.s12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText.title(
                              widget.productId != null
                                  ? 'أضف تقييمك للمنتج'
                                  : 'شاركنا رأيك وتجربتك',
                              color: AppColors.deepWine,
                            ),
                            if (widget.productName != null) ...[
                              const SizedBox(height: 2),
                              AppText.caption(
                                widget.productName!,
                                color: AppColors.muted,
                                maxLines: 1,
                              ),
                            ],
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(
                          Icons.close_rounded,
                          color: AppColors.muted,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: AppSpacing.s16),
                  const Divider(color: AppColors.line, height: 1),
                  const SizedBox(height: AppSpacing.s24),

                  // Logged-in Customer Banner vs Guest notice
                  if (isLoggedIn && customer != null)
                    Container(
                      margin: const EdgeInsets.only(bottom: AppSpacing.s16),
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.s16,
                        vertical: AppSpacing.s12,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.blush,
                        borderRadius: BorderRadius.circular(AppRadius.card),
                        border: Border.all(
                          color: AppColors.burgundy.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Iconsax.user_tick,
                            color: AppColors.burgundy,
                            size: 20,
                          ),
                          const SizedBox(width: AppSpacing.s12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppText.label(
                                  'التقييم مسجل بحسابك: ${customer.fullName}',
                                  color: AppColors.burgundy,
                                  weight: FontWeight.w700,
                                ),
                                if (customer.email.isNotEmpty)
                                  AppText.caption(
                                    customer.email,
                                    color: AppColors.muted,
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                  // Rating Picker (Required)
                  Center(
                    child: Column(
                      children: [
                        const AppText.label(
                          'حدد التقييم العام *',
                          color: AppColors.deepWine,
                          weight: FontWeight.w700,
                        ),
                        const SizedBox(height: AppSpacing.s8),
                        InteractiveRatingPicker(
                          initialRating: _rating,
                          starSize: 40,
                          onRatingChanged: (val) => setState(() => _rating = val),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppSpacing.s24),

                  // Feedback Type Dropdown
                  const AppText.label(
                    'نوع التقييم',
                    color: AppColors.deepWine,
                    weight: FontWeight.w600,
                  ),
                  const SizedBox(height: AppSpacing.s8),
                  DropdownButtonFormField<FeedbackType>(
                    initialValue: _selectedType,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.s16,
                        vertical: AppSpacing.s12,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadius.card),
                        borderSide: const BorderSide(color: AppColors.line),
                      ),
                    ),
                    items: FeedbackType.values.map((type) {
                      return DropdownMenuItem<FeedbackType>(
                        value: type,
                        child: Text(type.labelAr),
                      );
                    }).toList(),
                    onChanged: (newType) {
                      if (newType != null) {
                        setState(() => _selectedType = newType);
                      }
                    },
                  ),

                  const SizedBox(height: AppSpacing.s16),

                  // Guest fields (if not logged in)
                  if (!isLoggedIn) ...[
                    const AppText.label(
                      'بيانات الزائر',
                      color: AppColors.deepWine,
                      weight: FontWeight.w600,
                    ),
                    const SizedBox(height: AppSpacing.s8),
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'الاسم الكريم *',
                        hintText: 'مثال: سارة أحمد',
                        prefixIcon: Icon(Iconsax.user, size: 18),
                      ),
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) {
                          return 'يرجى إدخال اسمك لتسجيل التقييم';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppSpacing.s12),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              labelText: 'البريد الإلكتروني (اختياري)',
                              prefixIcon: Icon(Iconsax.sms, size: 18),
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.s12),
                        Expanded(
                          child: TextFormField(
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            decoration: const InputDecoration(
                              labelText: 'رقم الهاتف (اختياري)',
                              prefixIcon: Icon(Iconsax.call, size: 18),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.s16),
                  ],

                  // Subject (Optional)
                  const AppText.label(
                    'عنوان التقييم (اختياري)',
                    color: AppColors.deepWine,
                    weight: FontWeight.w600,
                  ),
                  const SizedBox(height: AppSpacing.s8),
                  TextFormField(
                    controller: _subjectController,
                    decoration: const InputDecoration(
                      hintText: 'مثال: جودة ممتازة وتغليف رائع',
                      prefixIcon: Icon(Iconsax.edit_2, size: 18),
                    ),
                  ),

                  const SizedBox(height: AppSpacing.s16),

                  // Comment / Review body (Required)
                  const AppText.label(
                    'تفاصيل رأيك وتجربتك *',
                    color: AppColors.deepWine,
                    weight: FontWeight.w600,
                  ),
                  const SizedBox(height: AppSpacing.s8),
                  TextFormField(
                    controller: _commentController,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      hintText:
                          'شارِكنا تجربتك بكل أمانة: ما الذي أعجبك في القطعة، الخامة، التغليف أو سرعة التوصيل...',
                    ),
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return 'يرجى كتابة تفاصيل التقييم';
                      }
                      if (val.trim().length < 5) {
                        return 'يرجى كتابة تقييم أوضح (5 أحرف على الأقل)';
                      }
                      return null;
                    },
                  ),

                  // Error notice if any
                  if (state.errorMessage != null) ...[
                    const SizedBox(height: AppSpacing.s12),
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.s12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEE2E2),
                        borderRadius: BorderRadius.circular(AppRadius.small),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.error_outline_rounded,
                            color: Color(0xFF991B1B),
                            size: 18,
                          ),
                          const SizedBox(width: AppSpacing.s8),
                          Expanded(
                            child: AppText.caption(
                              state.errorMessage!,
                              color: const Color(0xFF991B1B),
                              weight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: AppSpacing.s24),

                  // Action Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      AppButton.secondary(
                        label: 'إلغاء',
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      const SizedBox(width: AppSpacing.s12),
                      AppButton.primary(
                        label: state.status == FeedbackSubmissionStatus.loading
                            ? 'جاري الإرسال...'
                            : 'إرسال التقييم',
                        isLoading:
                            state.status == FeedbackSubmissionStatus.loading,
                        onPressed: () => _submit(context),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSuccessView(BuildContext context, String? message) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.s24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: const BoxDecoration(
              color: Color(0xFFDCFCE7),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_circle_rounded,
              color: Color(0xFF166534),
              size: 44,
            ),
          ),
          const SizedBox(height: AppSpacing.s16),
          const AppText.title(
            'شكراً لمشاركتنا رأيك القيم!',
            color: AppColors.deepWine,
          ),
          const SizedBox(height: AppSpacing.s8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s16),
            child: AppText.body(
              message ??
                  'تم استلام تقييمك بنجاح. آراؤكم هي أساس ثقتنا وتطورنا المستمر.',
              color: AppColors.muted,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: AppSpacing.s24),
          AppButton.primary(
            label: 'إغلاق',
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}
