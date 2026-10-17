import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

import 'package:warsha_commerce/core/di/di.dart';
import 'package:warsha_commerce/core/theme/app_colors.dart';
import 'package:warsha_commerce/core/theme/app_radius.dart';
import 'package:warsha_commerce/core/theme/app_spacing.dart';
import 'package:warsha_commerce/core/utils/breakpoints.dart';
import 'package:warsha_commerce/core/utils/money.dart';
import 'package:warsha_commerce/core/widgets/app_button.dart';
import 'package:warsha_commerce/core/widgets/app_container.dart';
import 'package:warsha_commerce/core/widgets/app_text.dart';
import 'package:warsha_commerce/core/widgets/loading_view.dart';
import 'package:warsha_commerce/core/widgets/status_pill.dart';
import 'package:warsha_commerce/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:warsha_commerce/features/auth/presentation/cubit/auth_state.dart';
import 'package:warsha_commerce/features/checkout/presentation/cubit/checkout_cubit.dart';
import 'package:warsha_commerce/features/checkout/presentation/widgets/checkout_auth_card.dart';
import 'package:warsha_commerce/features/feedback/presentation/cubit/customer_feedback_cubit.dart';
import 'package:warsha_commerce/features/feedback/presentation/cubit/customer_feedback_state.dart';
import 'package:warsha_commerce/features/feedback/presentation/widgets/feedback_card.dart';
import 'package:warsha_commerce/features/feedback/presentation/widgets/feedback_submission_modal.dart';
import 'package:warsha_commerce/features/home/presentation/widgets/home_drawer.dart';
import 'package:warsha_commerce/features/home/presentation/widgets/home_footer.dart';
import 'package:warsha_commerce/features/home/presentation/widgets/home_header.dart';
import 'package:warsha_commerce/features/orders/domain/entities/order.dart';
import 'package:warsha_commerce/features/orders/domain/repositories/orders_repository.dart';

class CustomerDashboardPage extends StatefulWidget {
  final int initialTabIndex;

  const CustomerDashboardPage({super.key, this.initialTabIndex = 0});

  @override
  State<CustomerDashboardPage> createState() => _CustomerDashboardPageState();
}

class _CustomerDashboardPageState extends State<CustomerDashboardPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late int _activeTabIndex;

  List<Order> _orders = [];
  bool _isLoadingOrders = false;

  @override
  void initState() {
    super.initState();
    _activeTabIndex = widget.initialTabIndex;
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    setState(() => _isLoadingOrders = true);
    final result = await sl<OrdersRepository>().getCustomerOrders();
    if (mounted) {
      result.fold(
        (_) => setState(() => _isLoadingOrders = false),
        (orders) => setState(() {
          _orders = orders;
          _isLoadingOrders = false;
        }),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CustomerFeedbackCubit>(
      create: (_) => sl<CustomerFeedbackCubit>()..loadCustomerFeedbacks(),
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: AppColors.ivory,
        drawer: const HomeDrawer(),
        appBar: HomeHeader(
          onOpenDrawer: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: Breakpoints.maxContentWidth,
                  ),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.symmetric(
                      horizontal: AppSpacing.s24,
                      vertical: AppSpacing.s24,
                    ),
                    child: BlocBuilder<AuthCubit, AuthState>(
                      builder: (context, authState) {
                        if (!authState.isAuthenticated) {
                          return _buildUnauthenticatedView(context);
                        }

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Customer profile header banner
                            _buildProfileHeader(authState),

                            const SizedBox(height: AppSpacing.s24),

                            // Navigation Tabs
                            _buildTabsRow(),

                            const SizedBox(height: AppSpacing.s16),

                            // Tab Body
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 200),
                              child: _buildActiveTabContent(context),
                            ),

                            const SizedBox(height: AppSpacing.s48),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),

              const HomeFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(AuthState authState) {
    final customer = authState.customer;
    final initials = customer?.fullName.isNotEmpty == true
        ? customer!.fullName.trim().substring(0, 1)
        : 'ع';

    return AppContainer.surface(
      padding: const EdgeInsetsDirectional.all(AppSpacing.s24),
      radius: AppRadius.card,
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.burgundy, AppColors.deepWine],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(AppRadius.pill),
            ),
            child: Center(
              child: AppText.title(
                initials,
                color: AppColors.white,
                weight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.s16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    AppText.title(
                      customer?.fullName ?? 'عميل الورشة',
                      color: AppColors.deepWine,
                    ),
                    const SizedBox(width: AppSpacing.s8),
                    Container(
                      padding: const EdgeInsetsDirectional.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.blush,
                        borderRadius: BorderRadius.circular(AppRadius.pill),
                      ),
                      child: const AppText.caption(
                        'عميل مميز',
                        color: AppColors.burgundy,
                        weight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                AppText.caption(
                  '${customer?.phone ?? ''} ${customer?.email.isNotEmpty == true ? '• ${customer!.email}' : ''}',
                  color: AppColors.muted,
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              context.read<AuthCubit>().logout();
            },
            tooltip: 'تسجيل الخروج',
            icon: const Icon(
              Iconsax.logout,
              color: AppColors.muted,
              size: 22,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabsRow() {
    return Wrap(
      spacing: AppSpacing.s12,
      runSpacing: AppSpacing.s8,
      children: [
        _buildTabButton(0, 'تقييماتي', Iconsax.star_1),
        _buildTabButton(1, 'طلباتي (${_orders.length})', Iconsax.box_1),
        _buildTabButton(2, 'بيانات الحساب', Iconsax.user_edit),
      ],
    );
  }

  Widget _buildTabButton(int index, String title, IconData icon) {
    final isSelected = _activeTabIndex == index;

    return GestureDetector(
      onTap: () => setState(() => _activeTabIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsetsDirectional.symmetric(
          horizontal: AppSpacing.s16,
          vertical: AppSpacing.s8,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.burgundy : AppColors.white,
          borderRadius: BorderRadius.circular(AppRadius.pill),
          border: Border.all(
            color: isSelected ? AppColors.burgundy : AppColors.line,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? AppColors.white : AppColors.muted,
            ),
            const SizedBox(width: AppSpacing.s8),
            AppText.body(
              title,
              color: isSelected ? AppColors.white : AppColors.deepWine,
              weight: isSelected ? FontWeight.w700 : FontWeight.w500,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveTabContent(BuildContext context) {
    switch (_activeTabIndex) {
      case 0:
        return _buildMyReviewsTab(context);
      case 1:
        return _buildMyOrdersTab(context);
      case 2:
      default:
        return _buildAccountDetailsTab(context);
    }
  }

  // 1. "تقييماتي" (My Reviews) Tab
  Widget _buildMyReviewsTab(BuildContext context) {
    return BlocBuilder<CustomerFeedbackCubit, CustomerFeedbackState>(
      builder: (context, state) {
        if (state.status == CustomerFeedbackStatus.loading &&
            state.feedbacks.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(AppSpacing.s32),
              child: LoadingView(),
            ),
          );
        }

        final feedbacks = state.feedbacks;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Top action bar
            Row(
              children: [
                const Icon(
                  Iconsax.star_1,
                  size: 22,
                  color: AppColors.burgundy,
                ),
                const SizedBox(width: AppSpacing.s8),
                AppText.title(
                  'تقييماتي وآرائي (${feedbacks.length})',
                  color: AppColors.deepWine,
                ),
                const Spacer(),
                AppButton.primary(
                  label: 'إضافة تقييم جديد',
                  icon: const Icon(
                    Iconsax.add,
                    size: 16,
                    color: AppColors.white,
                  ),
                  onPressed: () {
                    FeedbackSubmissionModal.show(
                      context,
                      onSuccess: () {
                        context
                            .read<CustomerFeedbackCubit>()
                            .loadCustomerFeedbacks();
                      },
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.s16),

            if (feedbacks.isEmpty)
              AppContainer.surface(
                padding: const EdgeInsets.all(AppSpacing.s32),
                radius: AppRadius.card,
                child: Column(
                  children: [
                    const Icon(
                      Iconsax.message_favorite,
                      size: 48,
                      color: AppColors.champagne,
                    ),
                    const SizedBox(height: AppSpacing.s16),
                    const AppText.title(
                      'لم تقم بإضافة أي تقييمات بعد',
                      color: AppColors.deepWine,
                    ),
                    const SizedBox(height: AppSpacing.s8),
                    const AppText.body(
                      'شاركنا رأيك في القطع التي اشتريتها أو تجربتك مع المتجر لنستمر في إسعادكم.',
                      color: AppColors.muted,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.s16),
                    AppButton.primary(
                      label: 'أضف أول تقييم الآن',
                      onPressed: () {
                        FeedbackSubmissionModal.show(
                          context,
                          onSuccess: () {
                            context
                                .read<CustomerFeedbackCubit>()
                                .loadCustomerFeedbacks();
                          },
                        );
                      },
                    ),
                  ],
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: feedbacks.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: AppSpacing.s16),
                itemBuilder: (context, index) {
                  final feedback = feedbacks[index];
                  return FeedbackCard(
                    feedback: feedback,
                    showStatus: true,
                    showComments: true,
                    onAddComment: (feedbackId, text, author) => context
                        .read<CustomerFeedbackCubit>()
                        .addComment(
                          feedbackId: feedbackId,
                          commentText: text,
                          authorName: author,
                        ),
                  );
                },
              ),
          ],
        );
      },
    );
  }

  // 2. "طلباتي" (My Orders) Tab
  Widget _buildMyOrdersTab(BuildContext context) {
    if (_isLoadingOrders) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.s32),
          child: LoadingView(),
        ),
      );
    }

    if (_orders.isEmpty) {
      return AppContainer.surface(
        padding: const EdgeInsets.all(AppSpacing.s32),
        radius: AppRadius.card,
        child: Column(
          children: [
            const Icon(Iconsax.box_1, size: 48, color: AppColors.muted),
            const SizedBox(height: AppSpacing.s16),
            const AppText.title('لا توجد طلبات سابقة', color: AppColors.deepWine),
            const SizedBox(height: AppSpacing.s8),
            const AppText.body(
              'ابدأ رحلة تسوقك وتعرف على أحدث الإكسسوارات الفاخرة.',
              color: AppColors.muted,
            ),
            const SizedBox(height: AppSpacing.s16),
            AppButton.primary(
              label: 'تصفح التشكيلة',
              onPressed: () => context.go('/shop'),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _orders.length,
      separatorBuilder: (context, index) => const SizedBox(height: AppSpacing.s16),
      itemBuilder: (context, index) {
        final order = _orders[index];
        return AppContainer.surface(
          padding: const EdgeInsets.all(AppSpacing.s16),
          radius: AppRadius.card,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  AppText.title(
                    'طلب #${order.orderNumber}',
                    color: AppColors.deepWine,
                  ),
                  const Spacer(),
                  StatusPill.fromStatus(
                    order.status,
                    locale: const Locale('ar'),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.s12),
              AppText.caption(
                'تاريخ الطلب: ${order.orderDate.year}-${order.orderDate.month.toString().padLeft(2, '0')}-${order.orderDate.day.toString().padLeft(2, '0')}',
                color: AppColors.muted,
              ),
              const SizedBox(height: AppSpacing.s8),
              AppText.label(
                'الإجمالي: ${MoneyUtils.formatMinor(order.totalPrice, symbol: 'ج.م')}',
                color: AppColors.burgundy,
                weight: FontWeight.w700,
              ),
              const SizedBox(height: AppSpacing.s12),
              const Divider(color: AppColors.line, height: 1),
              const SizedBox(height: AppSpacing.s12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  AppButton.secondary(
                    label: 'تقييم هذا الطلب',
                    onPressed: () {
                      FeedbackSubmissionModal.show(
                        context,
                        orderId: order.orderId,
                        onSuccess: () => context
                            .read<CustomerFeedbackCubit>()
                            .loadCustomerFeedbacks(),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  // 3. "بيانات الحساب" (Account Details) Tab
  Widget _buildAccountDetailsTab(BuildContext context) {
    final customer = context.watch<AuthCubit>().state.customer;

    return AppContainer.surface(
      padding: const EdgeInsets.all(AppSpacing.s24),
      radius: AppRadius.card,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppText.title('بيانات الحساب والعناوين', color: AppColors.deepWine),
          const SizedBox(height: AppSpacing.s16),
          const Divider(color: AppColors.line, height: 1),
          const SizedBox(height: AppSpacing.s16),
          _buildInfoRow('الاسم بالكامل', customer?.fullName ?? 'غير محدد'),
          const SizedBox(height: AppSpacing.s12),
          _buildInfoRow('البريد الإلكتروني', customer?.email ?? 'غير محدد'),
          const SizedBox(height: AppSpacing.s12),
          _buildInfoRow('رقم الهاتف', customer?.phone ?? 'غير محدد'),
          const SizedBox(height: AppSpacing.s12),
          _buildInfoRow('المحافظة', customer?.governorate ?? 'القاهرة'),
          const SizedBox(height: AppSpacing.s12),
          _buildInfoRow('العنوان', customer?.address ?? 'غير محدد'),
          const SizedBox(height: AppSpacing.s24),
          const Divider(color: AppColors.line, height: 1),
          const SizedBox(height: AppSpacing.s16),
          AppButton.secondary(
            label: 'تسجيل الخروج',
            icon: const Icon(Iconsax.logout, size: 16),
            onPressed: () => context.read<AuthCubit>().logout(),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      children: [
        SizedBox(
          width: 140,
          child: AppText.body(label, color: AppColors.muted, weight: FontWeight.w600),
        ),
        Expanded(
          child: AppText.body(value, color: AppColors.deepWine, weight: FontWeight.w700),
        ),
      ],
    );
  }

  Widget _buildUnauthenticatedView(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: AppSpacing.s32),
        const Icon(Iconsax.user_cirlce_add, size: 64, color: AppColors.burgundy),
        const SizedBox(height: AppSpacing.s16),
        const AppText.headline(
          'مرحباً بك في متجر الورشة',
          color: AppColors.deepWine,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.s8),
        const AppText.body(
          'سجّل دخولك الآن لعرض تقييماتك الشخصية، ومتابعة حالة النشر والردود، والاطلاع على طلباتك السابقة.',
          color: AppColors.muted,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.s32),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: BlocProvider<CheckoutCubit>(
            create: (_) => sl<CheckoutCubit>(),
            child: Builder(
              builder: (ctx) => CheckoutAuthCard(
                checkoutCubit: ctx.read<CheckoutCubit>(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
