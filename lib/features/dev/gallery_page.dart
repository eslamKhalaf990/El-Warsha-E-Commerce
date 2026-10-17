import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import 'package:warsha_commerce/core/config/app_config.dart';
import 'package:warsha_commerce/core/config/mock_debug_state.dart';
import 'package:warsha_commerce/core/di/di.dart';
import 'package:warsha_commerce/core/theme/app_theme.dart';
import 'package:warsha_commerce/core/utils/breakpoints.dart';
import 'package:warsha_commerce/core/utils/money.dart';
import 'package:warsha_commerce/core/widgets/app_button.dart';
import 'package:warsha_commerce/core/widgets/app_chip.dart';
import 'package:warsha_commerce/core/widgets/app_container.dart';
import 'package:warsha_commerce/core/widgets/app_text.dart';
import 'package:warsha_commerce/core/widgets/product_image.dart';
import 'package:warsha_commerce/core/widgets/quantity_stepper.dart';
import 'package:warsha_commerce/core/widgets/status_pill.dart';
import 'package:warsha_commerce/features/cart/domain/repositories/cart_repository.dart';
import 'package:warsha_commerce/features/catalog/domain/entities/product.dart';
import 'package:warsha_commerce/features/catalog/domain/repositories/catalog_repository.dart';
import 'package:warsha_commerce/features/orders/domain/entities/order.dart';
import 'package:warsha_commerce/features/orders/domain/entities/order_status.dart';
import 'package:warsha_commerce/features/orders/domain/repositories/orders_repository.dart';

class GalleryPage extends StatefulWidget {
  const GalleryPage({super.key});

  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  Locale _locale = const Locale('en');
  int _selectedChipIndex = 0;
  int _cartItemQuantity = 1;
  bool _buttonLoading = false;
  String? _appliedPromoCode;
  String _promoInput = '';
  String? _promoMessage;

  late final CatalogRepository _catalogRepository;
  late final CartRepository _cartRepository;
  late final OrdersRepository _ordersRepository;
  final MockDebugController _debugController = sl<MockDebugController>();

  List<Product> _products = [];
  Order? _sampleOrder;
  bool _isLoadingRepo = false;
  String? _repoError;

  @override
  void initState() {
    super.initState();
    _catalogRepository = sl<CatalogRepository>();
    _cartRepository = sl<CartRepository>();
    _ordersRepository = sl<OrdersRepository>();
    _debugController.addListener(_onDebugStateChanged);
    _loadRepoData();
  }

  @override
  void dispose() {
    _debugController.removeListener(_onDebugStateChanged);
    super.dispose();
  }

  void _onDebugStateChanged() {
    _loadRepoData();
  }

  Future<void> _loadRepoData() async {
    setState(() {
      _isLoadingRepo = true;
      _repoError = null;
    });

    final productsResult = await _catalogRepository.getProducts();
    final ordersResult = await _ordersRepository.getCustomerOrders();

    if (!mounted) return;

    setState(() {
      _isLoadingRepo = false;
      productsResult.fold(
        (failure) => _repoError = failure.message,
        (products) => _products = products,
      );
      ordersResult.fold(
        (failure) => _repoError = failure.message,
        (orders) => _sampleOrder = orders.isNotEmpty ? orders.first : null,
      );
    });
  }

  void _toggleLocale() {
    setState(() {
      _locale = _locale.languageCode == 'en'
          ? const Locale('ar')
          : const Locale('en');
    });
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = _locale.languageCode == 'ar';
    final theme = AppTheme.light(_locale);

    return Theme(
      data: theme,
      child: Directionality(
        textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
        child: Scaffold(
          backgroundColor: AppColors.ivory,
          appBar: AppBar(
            title: AppText.title(
              isArabic
                  ? 'معرض هوية وتصميم ${AppConfig.brandName}'
                  : '${AppConfig.brandName} Design System Gallery',
            ),
            actions: [
              // LTR / RTL toggle
              Padding(
                padding: const EdgeInsetsDirectional.only(end: AppSpacing.s16),
                child: AppButton.secondary(
                  height: 36,
                  label: isArabic ? 'English (LTR)' : 'العربية (RTL)',
                  onPressed: _toggleLocale,
                ),
              ),
            ],
          ),
          body: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: Breakpoints.maxContentWidth,
              ),
              child: ListView(
                padding: const EdgeInsetsDirectional.all(AppSpacing.s24),
                children: [
                  _buildControlsPanel(isArabic),
                  const SizedBox(height: AppSpacing.s32),
                  _buildColorsSection(isArabic),
                  const SizedBox(height: AppSpacing.s32),
                  _buildTypographySection(isArabic),
                  const SizedBox(height: AppSpacing.s32),
                  _buildContainersSection(isArabic),
                  const SizedBox(height: AppSpacing.s32),
                  _buildButtonsSection(isArabic),
                  const SizedBox(height: AppSpacing.s32),
                  _buildChipsSection(isArabic),
                  const SizedBox(height: AppSpacing.s32),
                  _buildStatusPillsSection(isArabic),
                  const SizedBox(height: AppSpacing.s32),
                  _buildProductCardSection(isArabic),
                  const SizedBox(height: AppSpacing.s32),
                  _buildCartSection(isArabic),
                  const SizedBox(height: AppSpacing.s32),
                  _buildOrderSection(isArabic),
                  const SizedBox(height: AppSpacing.s32),
                  _buildOrderTrackerSection(isArabic),
                  const SizedBox(height: AppSpacing.s48),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String titleEn, String titleAr, bool isArabic) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText.headline(
          isArabic ? titleAr : titleEn,
          color: AppColors.deepWine,
        ),
        const SizedBox(height: AppSpacing.s4),
        Container(
          height: 2,
          width: 48,
          decoration: const BoxDecoration(
            color: AppColors.champagne,
            borderRadius: BorderRadius.all(Radius.circular(1)),
          ),
        ),
        const SizedBox(height: AppSpacing.s16),
      ],
    );
  }

  Widget _buildControlsPanel(bool isArabic) {
    return AppContainer.blush(
      padding: const EdgeInsetsDirectional.all(AppSpacing.s16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Iconsax.setting_4,
                color: AppColors.deepWine,
                size: 20,
              ),
              const SizedBox(width: AppSpacing.s8),
              AppText.titleSmall(
                isArabic
                    ? 'لوحة تحكم حالة الاختبار (Debug Controls)'
                    : 'Mock & State Controls',
                color: AppColors.deepWine,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.s12),
          Wrap(
            spacing: AppSpacing.s12,
            runSpacing: AppSpacing.s8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              AppText.bodySmall(
                isArabic ? 'حالة البيانات:' : 'Repository State:',
              ),
              for (final state in MockRepoState.values)
                AppChip(
                  label: state.name.toUpperCase(),
                  isSelected: _debugController.state == state,
                  onTap: () => _debugController.setState(state),
                ),
            ],
          ),
          if (_isLoadingRepo) ...[
            const SizedBox(height: AppSpacing.s12),
            Row(
              children: [
                const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.burgundy,
                  ),
                ),
                const SizedBox(width: AppSpacing.s8),
                AppText.caption(
                  isArabic
                      ? 'جاري محاكاة التحميل...'
                      : 'Simulating repository latency...',
                ),
              ],
            ),
          ],
          if (_repoError != null) ...[
            const SizedBox(height: AppSpacing.s12),
            StatusPill.error(label: 'Error: $_repoError'),
          ],
        ],
      ),
    );
  }

  Widget _buildColorsSection(bool isArabic) {
    final colors = [
      (
        'burgundy',
        AppColors.burgundy,
        '#6D1A2E',
        'Primary: buttons, active states, links',
      ),
      (
        'deepWine',
        AppColors.deepWine,
        '#4A0F1E',
        'Headings, pressed/hover state',
      ),
      (
        'blush',
        AppColors.blush,
        '#F7EBEC',
        'Soft surfaces, chips, image backgrounds',
      ),
      ('ivory', AppColors.ivory, '#FFFAF6', 'Scaffold background'),
      (
        'champagne',
        AppColors.champagne,
        '#C9A66B',
        'Accent: highlights, badges',
      ),
      ('ink', AppColors.ink, '#2B1A1E', 'Primary text'),
      ('muted', AppColors.muted, '#8A737A', 'Secondary text, captions'),
      ('line', AppColors.line, '#EADDD9', 'Borders and dividers'),
      ('white', AppColors.white, '#FFFFFF', 'Cards and inputs'),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          'Brand Colors (AppColors)',
          'ألوان العلامة التجارية',
          isArabic,
        ),
        Wrap(
          spacing: AppSpacing.s16,
          runSpacing: AppSpacing.s16,
          children: colors.map((c) {
            final isLight =
                c.$2 == AppColors.white ||
                c.$2 == AppColors.ivory ||
                c.$2 == AppColors.blush ||
                c.$2 == AppColors.line;
            return AppContainer.surface(
              width: 170,
              padding: const EdgeInsetsDirectional.all(AppSpacing.s12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 56,
                    decoration: BoxDecoration(
                      color: c.$2,
                      borderRadius: AppRadius.smallBorderRadius,
                      border: Border.all(color: AppColors.line),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s8),
                  AppText.titleSmall(c.$1),
                  AppText.caption(c.$3),
                  const SizedBox(height: AppSpacing.s4),
                  AppText.caption(
                    c.$4,
                    color: isLight ? AppColors.muted : AppColors.deepWine,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildTypographySection(bool isArabic) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          'Typography Scale (Cormorant Garamond / Inter / Tajawal)',
          'تدرج الخطوط والطباعة',
          isArabic,
        ),
        AppContainer.surface(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText.display(
                isArabic
                    ? 'عرض 40 - فخامة وأناقة الورشة'
                    : 'Display 40 — Elwarsha Accessories',
              ),
              const Divider(height: AppSpacing.s24),
              AppText.headline(
                isArabic
                    ? 'عنوان رئيسي 28 - تشكيلة الذهب والأحجار'
                    : 'Headline 28 — Timeless Gold & Stones',
              ),
              const Divider(height: AppSpacing.s24),
              AppText.title(
                isArabic
                    ? 'عنوان 20 - خواتم مرصعة بالألماس'
                    : 'Title 20 — Handcrafted Emerald Rings',
              ),
              const Divider(height: AppSpacing.s24),
              AppText.titleSmall(
                isArabic
                    ? 'عنوان صغير 16 - تفاصيل المنتج والمقاس'
                    : 'Title Small 16 — Product Details & Specs',
              ),
              const Divider(height: AppSpacing.s24),
              AppText.body(
                isArabic
                    ? 'نص المحتوى 15 - صُممت هذه القطعة يدويًا بعناية فائقة لتضفي لمسة من الرقي والجمال الطبيعي على إطلالتك اليومية وفي المناسبات المميزة.'
                    : 'Body 15 — Handcrafted with precision and passion, each piece is designed to reflect timeless elegance and modern grace.',
              ),
              const Divider(height: AppSpacing.s24),
              AppText.bodySmall(
                isArabic ? 'نص صغير 14 - متوفر بجميع المقاسات مع شهادة ضمان' : 'Body Small 14 — Available with authenticity warranty certificate',
              ),
              const Divider(height: AppSpacing.s24),
              AppText.caption(
                isArabic ? 'شرح إضافي 12 - التوصيل متاح لجميع محافظات مصر' : 'Caption 12 — Standard shipping across all Egyptian governorates',
              ),
              const Divider(height: AppSpacing.s24),
              Row(
                children: [
                  AppText.label(isArabic ? 'زر 14: ' : 'Label 14: '),
                  const SizedBox(width: AppSpacing.s8),
                  AppText.price(MoneyUtils.formatMinor(145000)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildContainersSection(bool isArabic) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          'AppContainer Variants',
          'أنواع الحاويات والبطاقات',
          isArabic,
        ),
        Wrap(
          spacing: AppSpacing.s16,
          runSpacing: AppSpacing.s16,
          children: [
            const AppContainer.surface(
              width: 220,
              height: 120,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppText.titleSmall('AppContainer.surface'),
                    AppText.caption('White + 1px border'),
                  ],
                ),
              ),
            ),
            const AppContainer.blush(
              width: 220,
              height: 120,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppText.titleSmall('AppContainer.blush'),
                    AppText.caption('Blush soft surface'),
                  ],
                ),
              ),
            ),
            const AppContainer.filled(
              width: 220,
              height: 120,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppText.titleSmall(
                      'AppContainer.filled',
                      color: AppColors.white,
                    ),
                    AppText.caption('Burgundy fill', color: AppColors.blush),
                  ],
                ),
              ),
            ),
            const AppContainer.outlined(
              width: 220,
              height: 120,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppText.titleSmall('AppContainer.outlined'),
                    AppText.caption('Transparent + border'),
                  ],
                ),
              ),
            ),
            const AppContainer.ivory(
              width: 220,
              height: 120,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppText.titleSmall('AppContainer.ivory'),
                    AppText.caption('Ivory surface'),
                  ],
                ),
              ),
            ),
            // Tappable test container with ripple and hover
            AppContainer.surface(
              width: 220,
              height: 120,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      isArabic
                          ? 'تم الضغط على الحاوية بنجاح!'
                          : 'Container tapped! Ripple & focus work.',
                    ),
                    duration: const Duration(seconds: 1),
                  ),
                );
              },
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Iconsax.mouse,
                      color: AppColors.burgundy,
                      size: 24,
                    ),
                    const SizedBox(height: 4),
                    const AppText.titleSmall('Interactive onTap'),
                    AppText.caption(
                      isArabic
                          ? 'يدعم التموج والتركيز'
                          : 'Ripple, hover & focus ring',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildButtonsSection(bool isArabic) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('AppButton Variants', 'أشكال الأزرار', isArabic),
        Wrap(
          spacing: AppSpacing.s16,
          runSpacing: AppSpacing.s16,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            AppButton.primary(
              label: isArabic ? 'زر رئيسي' : 'Primary Button',
              onPressed: () {},
            ),
            AppButton.secondary(
              label: isArabic ? 'زر ثانوي' : 'Secondary Button',
              onPressed: () {},
            ),
            AppButton.text(
              label: isArabic ? 'زر نصي' : 'Text Button',
              onPressed: () {},
            ),
            AppButton.primary(
              label: isArabic ? 'تحميل...' : 'Loading State',
              isLoading: _buttonLoading,
              onPressed: () {
                setState(() => _buttonLoading = true);
                Future.delayed(const Duration(seconds: 2), () {
                  if (mounted) setState(() => _buttonLoading = false);
                });
              },
            ),
            AppButton.primary(
              label: isArabic ? 'معطل' : 'Disabled',
              onPressed: null,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildChipsSection(bool isArabic) {
    final categories = [
      'الكل (All)',
      'خواتم (Rings)',
      'أساور (Bracelets)',
      'قلائد (Necklaces)',
      'أقراط (Earrings)',
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('AppChip', 'الرقاقات والتصنيفات', isArabic),
        Wrap(
          spacing: AppSpacing.s8,
          runSpacing: AppSpacing.s8,
          children: List.generate(categories.length, (index) {
            return AppChip(
              label: categories[index],
              isSelected: _selectedChipIndex == index,
              onTap: () => setState(() => _selectedChipIndex = index),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildStatusPillsSection(bool isArabic) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          'StatusPill (Order Statuses)',
          'شارات حالة الطلب',
          isArabic,
        ),
        Wrap(
          spacing: AppSpacing.s12,
          runSpacing: AppSpacing.s12,
          children: [
            for (final status in OrderStatus.values)
              StatusPill.fromStatus(status, locale: _locale),
            StatusPill.error(
              label: isArabic ? 'خطأ في الدفع' : 'Payment Failed',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProductCardSection(bool isArabic) {
    final product = _products.isNotEmpty ? _products[0] : null;
    final outOfStockProduct = _products.length > 6 ? _products[6] : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Product Card Component', 'بطاقة المنتج', isArabic),
        if (product != null)
          Wrap(
            spacing: AppSpacing.s24,
            runSpacing: AppSpacing.s24,
            children: [
              _buildProductCard(product, isArabic),
              if (outOfStockProduct != null)
                _buildProductCard(outOfStockProduct, isArabic),
              if (_products.length > 3)
                _buildProductCard(
                  _products[3],
                  isArabic,
                ), // Product with discount
            ],
          )
        else
          const AppContainer.blush(
            child: AppText.body('No products loaded in current debug state'),
          ),
      ],
    );
  }

  Widget _buildProductCard(Product product, bool isArabic) {
    return AppContainer.surface(
      width: 280,
      padding: EdgeInsetsDirectional.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image with aspect ratio and fallback
          Stack(
            children: [
              ProductImage(imageUrl: product.imageUrl, fallbackSeed: product.id, height: 220, width: 280),
              if (product.hasDiscount)
                PositionedDirectional(
                  top: AppSpacing.s8,
                  start: AppSpacing.s8,
                  child: AppContainer(
                    color: AppColors.champagne,
                    radius: AppRadius.pill,
                    padding: const EdgeInsetsDirectional.symmetric(
                      horizontal: AppSpacing.s8,
                      vertical: AppSpacing.s4,
                    ),
                    child: AppText.caption(
                      isArabic ? 'خصم خاص' : 'SALE',
                      color: AppColors.ink,
                      weight: FontWeight.w600,
                    ),
                  ),
                ),
              if (product.isOutOfStock)
                PositionedDirectional(
                  top: AppSpacing.s8,
                  end: AppSpacing.s8,
                  child: StatusPill.neutral(
                    label: isArabic ? 'نفد من المخزون' : 'Out of Stock',
                  ),
                ),
            ],
          ),
          Padding(
            padding: const EdgeInsetsDirectional.all(AppSpacing.s16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText.caption(product.categoryName),
                const SizedBox(height: AppSpacing.s4),
                AppText.titleSmall(
                  product.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.s8),
                Row(
                  children: [
                    AppText.price(
                      MoneyUtils.formatMinor(product.totalPrice),
                      color: AppColors.burgundy,
                    ),
                    if (product.hasDiscount) ...[
                      const SizedBox(width: AppSpacing.s8),
                      AppText.caption(
                        MoneyUtils.formatMinor(product.sellingPrice),
                        decoration: TextDecoration.lineThrough,
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: AppSpacing.s12),
                AppButton.primary(
                  width: double.infinity,
                  height: 40,
                  label: product.isOutOfStock
                      ? (isArabic ? 'غير متوفر' : 'Unavailable')
                      : (isArabic ? 'أضف للسلة' : 'Add to Cart'),
                  onPressed: product.isOutOfStock ? null : () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartSection(bool isArabic) {
    final subtotal = _cartRepository.getSubtotal();
    final shipping = _cartRepository.getShippingFee();
    final total = _cartRepository.getTotal(promoCode: _appliedPromoCode);
    final discount = _appliedPromoCode == 'ROSE10'
        ? (subtotal * 0.10).round()
        : 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          'Cart Row & Stepper',
          'عنصر السلة وحاسبة الإجمالي',
          isArabic,
        ),
        AppContainer.surface(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cart row
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const ProductImage(
                    imageUrl: null, // Test placeholder
                    fallbackSeed: 1,
                    width: 72,
                    height: 72,
                    radius: AppRadius.small,
                  ),
                  const SizedBox(width: AppSpacing.s16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText.titleSmall(
                          isArabic
                              ? 'خاتم الزمرد الملكي'
                              : 'Royal Emerald Ring',
                        ),
                        const SizedBox(height: AppSpacing.s4),
                        AppText.price(MoneyUtils.formatMinor(45000)),
                      ],
                    ),
                  ),
                  QuantityStepper(
                    quantity: _cartItemQuantity,
                    onChanged: (qty) => setState(() => _cartItemQuantity = qty),
                  ),
                  const SizedBox(width: AppSpacing.s16),
                  AppText.price(
                    MoneyUtils.formatMinor(45000 * _cartItemQuantity),
                    color: AppColors.burgundy,
                  ),
                ],
              ),
              const Divider(height: AppSpacing.s32),

              // Promo code row
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: isArabic
                            ? 'أدخل كود الخصم (جرب ROSE10)'
                            : 'Promo code (try ROSE10)',
                      ),
                      onChanged: (val) => _promoInput = val,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.s12),
                  AppButton.secondary(
                    label: isArabic ? 'تطبيق الكود' : 'Apply',
                    onPressed: () async {
                      final result = await _cartRepository.applyPromoCode(
                        _promoInput,
                      );
                      if (!mounted) return;
                      setState(() {
                        result.fold(
                          (failure) {
                            _appliedPromoCode = null;
                            _promoMessage = failure.message;
                          },
                          (discountAmt) {
                            _appliedPromoCode = _promoInput
                                .trim()
                                .toUpperCase();
                            _promoMessage = isArabic
                                ? 'تم تطبيق خصم 10% بنجاح!'
                                : '10% discount applied!';
                          },
                        );
                      });
                    },
                  ),
                ],
              ),
              if (_promoMessage != null) ...[
                const SizedBox(height: AppSpacing.s8),
                AppText.caption(
                  _promoMessage!,
                  color: _appliedPromoCode != null
                      ? AppStatusColors.successText
                      : AppStatusColors.errorText,
                  weight: FontWeight.w600,
                ),
              ],
              const Divider(height: AppSpacing.s32),

              // Summary
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppText.body(
                    isArabic
                        ? 'المجموع الفرعي (3 قطع):'
                        : 'Subtotal (3 items):',
                  ),
                  AppText.price(MoneyUtils.formatMinor(subtotal)),
                ],
              ),
              if (discount > 0) ...[
                const SizedBox(height: AppSpacing.s8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppText.body(
                      isArabic
                          ? 'خصم الكود (ROSE10 - 10%):'
                          : 'Promo Discount (ROSE10 - 10%):',
                      color: AppStatusColors.successText,
                    ),
                    AppText.price(
                      '- ${MoneyUtils.formatMinor(discount)}',
                      color: AppStatusColors.successText,
                    ),
                  ],
                ),
              ],
              const SizedBox(height: AppSpacing.s8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppText.body(isArabic ? 'الشحن:' : 'Shipping:'),
                  AppText.price(MoneyUtils.formatMinor(shipping)),
                ],
              ),
              const Divider(height: AppSpacing.s24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppText.title(
                    isArabic ? 'الإجمالي النهائي:' : 'Final Total:',
                  ),
                  AppText.title(
                    MoneyUtils.formatMinor(total),
                    color: AppColors.burgundy,
                    weight: FontWeight.w700,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOrderSection(bool isArabic) {
    final order = _sampleOrder;
    if (order == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          'Order Card Component',
          'بطاقة تفاصيل الطلب',
          isArabic,
        ),
        AppContainer.surface(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText.title(
                        order.orderNumber,
                        color: AppColors.deepWine,
                      ),
                      const SizedBox(height: AppSpacing.s4),
                      AppText.caption(
                        '${order.orderDate.year}-${order.orderDate.month.toString().padLeft(2, '0')}-${order.orderDate.day.toString().padLeft(2, '0')}',
                      ),
                    ],
                  ),
                  StatusPill.fromStatus(order.status, locale: _locale),
                ],
              ),
              const Divider(height: AppSpacing.s24),
              AppText.bodySmall(
                isArabic
                    ? 'عدد المنتجات: ${order.items.length} · الإجمالي: ${MoneyUtils.formatMinor(order.totalPrice)}'
                    : 'Items: ${order.items.length} · Total: ${MoneyUtils.formatMinor(order.totalPrice)}',
              ),
              const SizedBox(height: AppSpacing.s8),
              AppText.caption(
                '${isArabic ? 'طريقة الدفع:' : 'Payment:'} ${order.paymentMethod}',
              ),
              if (order.shippingAddress != null) ...[
                const SizedBox(height: AppSpacing.s4),
                AppText.caption(
                  '${isArabic ? 'عنوان الشحن:' : 'Ship to:'} ${order.shippingAddress!.formattedAddress}',
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOrderTrackerSection(bool isArabic) {
    final steps = [
      (
        OrderStatus.placed,
        isArabic ? 'تم الطلب' : 'Placed',
        isArabic ? '28 سبتمبر 2:30 م' : 'Sep 28, 2:30 PM',
        true,
      ),
      (
        OrderStatus.confirmed,
        isArabic ? 'تم التأكيد' : 'Confirmed',
        isArabic ? '28 سبتمبر 3:10 م' : 'Sep 28, 3:10 PM',
        true,
      ),
      (
        OrderStatus.packed,
        isArabic ? 'تم التجهيز' : 'Packed',
        isArabic ? '29 سبتمبر 10:00 ص' : 'Sep 29, 10:00 AM',
        true,
      ),
      (
        OrderStatus.shipped,
        isArabic ? 'تم الشحن' : 'Shipped',
        isArabic ? '30 سبتمبر 9:15 ص' : 'Sep 30, 9:15 AM',
        true,
      ),
      (
        OrderStatus.delivered,
        isArabic ? 'تم التوصيل' : 'Delivered',
        isArabic ? 'قيد الانتظار' : 'Pending Delivery',
        false,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          '5-Step Order Tracker',
          'متتبع الطلب (5 مراحل)',
          isArabic,
        ),
        AppContainer.surface(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: List.generate(steps.length * 2 - 1, (index) {
                  if (index.isOdd) {
                    final stepIndex = index ~/ 2;
                    final isLineActive = steps[stepIndex + 1].$4;
                    return Expanded(
                      child: Container(
                        height: 2,
                        color: isLineActive
                            ? AppColors.burgundy
                            : AppColors.line,
                      ),
                    );
                  }

                  final stepIndex = index ~/ 2;
                  final step = steps[stepIndex];
                  final isCurrentActive = step.$1 == OrderStatus.shipped;

                  return Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: step.$4 ? AppColors.burgundy : AppColors.blush,
                      border: Border.all(
                        color: isCurrentActive
                            ? AppColors.champagne
                            : AppColors.line,
                        width: isCurrentActive ? 2 : 1,
                      ),
                    ),
                    child: Center(
                      child: step.$4
                          ? const Icon(
                              Iconsax.check,
                              size: 16,
                              color: AppColors.white,
                            )
                          : Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.muted,
                              ),
                            ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: AppSpacing.s12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: steps.map((s) {
                  return SizedBox(
                    width: 70,
                    child: Column(
                      children: [
                        AppText.label(
                          s.$2,
                          textAlign: TextAlign.center,
                          color: s.$4 ? AppColors.deepWine : AppColors.muted,
                        ),
                        const SizedBox(height: 2),
                        AppText.caption(s.$3, textAlign: TextAlign.center),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
