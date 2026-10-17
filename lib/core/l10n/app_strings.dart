import 'package:flutter/widgets.dart';
import 'package:warsha_commerce/core/error/failures.dart';

/// Centralized Arabic-first microcopy for El Warsha Store.
///
/// Voice & Microcopy: Egyptian Colloquial Arabic (عامية مصرية), friendly and conversational
/// in the tone of Noon / Dubizzle.
/// All strings live in this file as a const class without code generation.
class AppStrings {
  const AppStrings._();

  // ---------------------------------------------------------------------------
  // Reference Copy Bank (Exact User Specifications)
  // ---------------------------------------------------------------------------
  static const String mainCta = 'مستني إيه؟ اطلب دلوقتي';
  static const String addToCart = 'ضيف للسلة';
  static const String addedToCart = 'اتضاف للسلة ✓';
  static const String continueToCheckout = 'كمّل طلبك';
  static const String confirmOrder = 'أكّد الطلب';
  static const String outOfStock = 'خلصت الكمية';
  static const String soldOut = 'خلصت الكمية';
  static const String saleStripTitle = 'عروض ماتتفوتش';
  static const String newArrivals = 'وصل حديثًا';
  static const String deliveryNote = 'التوصيل لحد باب بيتك';
  static const String emptyCart = 'سلتك فاضية.. يلا نملاها حاجات حلوة؟';
  static const String emptyWishlist = 'لسه مضافتش حاجة للمفضلة';
  static const String loadingError = 'حصلت مشكلة عندنا، جرّب تاني بعد شوية';
  static const String noConnection = 'النت فاصل؟ اتأكد من الاتصال وجرّب تاني';
  static const String retry = 'حاول تاني';
  static const String loginWelcome = 'أهلاً بيك تاني';
  static const String otpSent = 'بعتنالك كود على إيميلك';
  static const String otpInvalid = 'الكود غلط أو خلص وقته، ابعت كود جديد';
  static const String orderSuccess = 'تمام! طلبك اتسجّل 🎉 هنواصل معاك قريب';
  static const String sessionExpired = 'الجلسة خلصت، سجّل دخول تاني';

  // Dynamic helpers from Copy Bank
  static String lowStock(int count) => 'باقي $count قطع بس! الحقها';
  static String saveAmount(String amount) => 'وفّر $amount';
  static String emptySearch(String query) =>
      'مفيش نتائج لـ "$query".. جرّب كلمة تانية';

  // ---------------------------------------------------------------------------
  // Brand & General
  // ---------------------------------------------------------------------------
  static const String brandName = 'الورشة';
  static const String brandNameEn = 'ELWARSHA';
  static const String brandSubtitle = 'إكسسوارات';
  static const String brandSubtitleEn = 'ELWARSHA ACCESSORIES';
  static const String currency = 'ج.م';
  static const String searchPlaceholder = 'دوّر في المنتجات...';
  static const bool isArabic = true;

  // ---------------------------------------------------------------------------
  // Navigation & Tabs
  // ---------------------------------------------------------------------------
  static const String home = 'الرئيسية';
  static const String shop = 'المتجر';
  static const String rings = 'خواتم';
  static const String bracelets = 'أساور';
  static const String necklaces = 'سلاسل';
  static const String earrings = 'حلقان';
  static const String sets = 'أطقم';
  static const String gifts = 'الهدايا';
  static const String wishlist = 'المفضلة';
  static const String account = 'حسابي';
  static const String cart = 'سلتك';
  static const String menu = 'القائمة';
  static const String close = 'قفل';
  static const String back = 'رجوع';

  // ---------------------------------------------------------------------------
  // Product Details Microcopy
  // ---------------------------------------------------------------------------
  static const String productDetails = 'تفاصيل المنتج';
  static const String category = 'الفئة';
  static const String sku = 'كود المنتج';
  static const String inStock = 'متوفر بالمخزن';
  static const String quantity = 'الكمية';
  static const String description = 'وصف المنتج';
  static const String specifications = 'المواصفات والخامة';
  static const String careTips = 'نصائح العناية بالإكسسوار';
  static const String relatedProducts = 'منتجات قد تعجبك';
  static const String relatedProductsSubtitle =
      'تشكيلة مختارة بعناية تناسب ذوقك الراقي';
  static const String viewCart = 'عرض السلة';
  static const String productNotFound = 'المنتج غير موجود أو تم حذفه';
  static const String materialValue =
      'مطلي بماء الذهب عيار 18 عالي الجودة ومقاوم لتغير اللون ومضاد للحساسية';
  static const String careTipsValue =
      'تجنب ملامسة العطور المباشرة والكيماويات والماء الساخن، واحفظه في علبة الورشة المخملية ليبقى لامعًا كالجديد';

  // ---------------------------------------------------------------------------
  // Home & Catalog Sections
  // ---------------------------------------------------------------------------
  static const String allCategories = 'الكل';
  static const String bestSellers = 'الأكتر مبيعًا';
  static const String viewAll = 'عرض الكل ←';
  static const String shopByCategory = 'تسوّق حسب الفئة';
  static const String saleBadge = 'خصم';
  static const String newBadge = 'جديد';
  static const String emptyShelf = 'مفيش منتجات متوفرة دلوقتي';

  // ---------------------------------------------------------------------------
  // Promo Band & Trust Highlights
  // ---------------------------------------------------------------------------
  static const String giftEditEyebrow = 'تألق استثنائي';
  static const String giftEditTitle = 'تشكيلة الهدايا من الورشة';
  static const String giftEditSubtitle =
      'تغليف هدايا فخم مع كارت إهداء مخصوص هدية مع كل طلب.';
  static const String giftEditCta = 'مستني إيه؟ اطلب دلوقتي';

  static const String trustFreeWrappingTitle = 'تغليف هدايا فخم';
  static const String trustFreeWrappingDesc =
      'علبة الورشة البورجوندي المخملية الأنيقة';

  static const String trustEasyExchangeTitle = 'استبدال واسترجاع سهل';
  static const String trustEasyExchangeDesc =
      'معاك 14 يوم ومندوبنا يجيلك للباب';

  static const String trustSecureCheckoutTitle = 'دفع آمن 100%';
  static const String trustSecureCheckoutDesc =
      'تحويل فوري وآمن عبر انستاباي وفودافون كاش';

  static const String announcement =
      'شحن ببلاش لكل المحافظات للطلبات فوق 1,000 ج.م • تغليف هدايا فخم مع كل طلب';

  // ---------------------------------------------------------------------------
  // Cart Microcopy
  // ---------------------------------------------------------------------------
  static const String cartTitle = 'سلتك';
  static const String cartEmptyTitle = 'سلتك فاضية.. يلا نملاها حاجات حلوة؟';
  static const String cartEmptySubtitle =
      'لسه مضافتش أي إكسسوارات لسلتك. تصفح تشكيلتنا واختار اللي يعجبك.';
  static const String continueShopping = 'كمّل تسوق';
  static const String proceedToCheckout = 'كمّل طلبك';
  static const String orderSummary = 'ملخص الطلب';
  static const String subtotal = 'المجموع';
  static const String shippingFee = 'مصاريف التوصيل';
  static const String freeShipping = 'شحن ببلاش';
  static const String freeShippingEligible = 'مبروك! شحن طلبك ببلاش';
  static String freeShippingRemaining(String amount) =>
      'فاضلك $amount عشان الشحن يبقى ببلاش!';
  static const String discount = 'الخصم';
  static const String total = 'الإجمالي';
  static const String promoCode = 'كود الخصم';
  static const String promoCodePlaceholder = 'اكتب كود الخصم (زي WARSHA10)';
  static const String apply = 'تطبيق';
  static const String remove = 'حذف';
  static const String clearCart = 'فضّي السلة';
  static const String itemsCount = 'منتجات';

  // ---------------------------------------------------------------------------
  // Checkout Microcopy
  // ---------------------------------------------------------------------------
  static const String checkoutTitle = 'إتمام الطلب';
  static const String shippingDetails = 'بيانات التوصيل';
  static const String fullName = 'الاسم بالكامل';
  static const String fullNameHint = 'اكتب اسمك الثلاثي';
  static const String phone = 'رقم الموبايل';
  static const String phoneHint = '01xxxxxxxxx';
  static const String secondaryPhone = 'رقم موبايل تاني (اختياري)';
  static const String secondaryPhoneHint = '01xxxxxxxxx';
  static const String governorate = 'المحافظة';
  static const String selectGovernorate = 'اختار المحافظة';
  static const String city = 'المدينة / المنطقة';
  static const String cityHint = 'مثلاً: المعادي، الدقي، مصر الجديدة';
  static const String address = 'العنوان بالتفصيل';
  static const String addressHint = 'الشارع، رقم العمارة، الشقة أو علامة مميزة';
  static const String orderNotes = 'ملاحظات للتوصيل (اختياري)';
  static const String notesPlaceholder =
      'مثلاً: رن الجرس، أو التوصيل بعد الساعة 5';
  static const String paymentMethod = 'طريقة الدفع';
  static const String paymentMethodsAllowedSubtitle =
      'الدفع متاح حصرياً عبر انستاباي وفودافون كاش فقط';
  static const String cashOnDelivery = 'الدفع عند الاستلام';
  static const String cashOnDeliveryDesc =
      'ادفع كاش لما المندوب يوصل طلبك لحد باب بيتك';
  static const String instapay = 'انستاباي (InstaPay)';
  static const String instapayDesc = 'تحويل فوري ولحظي عبر تطبيق انستاباي';
  static const String instapayNumber = '01159069897';
  static const String instapayNumberLabel = 'رقم انستاباي للتحويل:';
  static const String instapayAccount = '01159069897';
  static const String instapayAccountLabel = 'رقم انستاباي للتحويل:';
  static const String instapayInstructions =
      'حوّل قيمة الطلب لرقم انستاباي أعلاه، وخد سكرين شوت للعملية عشان ترفعها هنا.';

  static const String vodafoneCash = 'فودافون كاش (Vodafone Cash)';
  static const String vodafoneCashDesc = 'تحويل فوري إلى رقم محفظة فودافون كاش';
  static const String vodafoneCashNumber = '01012041231';
  static const String vodafoneCashNumberLabel =
      'رقم محفظة فودافون كاش للتحويل:';
  static const String vodafoneCashInstructions =
      'حوّل قيمة الطلب لرقم فودافون كاش أعلاه، وخد سكرين شوت للعملية عشان ترفعها هنا.';

  static const String cardPayment = 'كارت بنكي (فيزا / ماستركارد)';
  static const String cardPaymentDesc = 'دفع إلكتروني آمن ومشفر 100%';
  static const placeOrder = 'أكّد الطلب';

  // Friendly deposit screenshot microcopy
  static const String depositScreenshotNoticeTitle =
      'إرفاق سكرين شوت التحويل مطلوب لتأكيد طلبك 📸';
  static const String depositScreenshotNoticeDesc =
      'عشان نأكد طلبك ونبدأ نجهزه بكل حب وعناية، يرجى تحويل المبلغ ثم إرفاق صورة أو سكرين شوت لإيصال الإيداع كملف مرفق هنا. أول ما يوصلنا هنراجع التحويل فوراً ونتواصل معاك! 💖';
  static const String depositScreenshotRequired =
      'من فضلك ارفق سكرين شوت (إيصال) التحويل عشان نقدر نأكد طلبك ونبدأ نجهزه لك فوراً 🌸';
  static const String uploadDepositReceipt = 'إرفاق إيصال التحويل (مطلوب)';
  static const String uploadDepositReceiptHint =
      'اضغط هنا لاختيار صورة الإيصال (PNG, JPG, JPEG, WEBP حتى 5 ميجابايت)';
  static const String depositReceiptAttached = 'تم إرفاق إيصال التحويل بنجاح ✓';
  static const String changeReceipt = 'تغيير الصورة';
  static const String removeReceipt = 'حذف';
  static const String copy = 'نسخ';
  static const String copied = 'تم النسخ!';
  static const String downPayment = 'الدفعة المقدمة (العربون)';
  static const String downPaymentAmount = 'مبلغ الدفعة المقدمة (العربون) (مطلوب)';
  static const String downPaymentHint = 'مثلاً: 200';
  static const String downPaymentDesc =
      'أدخل المبلغ الذي قمت بتحويله لحسابنا لتأكيد حجز طلبك';
  static const String downPaymentRequired =
      'من فضلك ادخل مبلغ الدفعة المقدمة (العربون) لتأكيد طلبك';
  static const String downPaymentExceedsTotal =
      'مبلغ الدفعة المقدمة لا يمكن أن يتجاوز إجمالي الطلب';
  static const String remainingAmount = 'المتبقي عند الاستلام';

  // ---------------------------------------------------------------------------
  // Order Confirmation Microcopy
  // ---------------------------------------------------------------------------
  static const String orderConfirmation = 'تأكيد طلبك';
  static const String orderSuccessTitle =
      'تمام! طلبك اتسجّل 🎉 هنواصل معاك قريب';
  static const String orderSuccessSubtitle =
      'شكرًا لطلبك من الورشة. بنجهّز إكسسواراتك دلوقتي وهنبلغك بكل خطوة لحد ما توصلك.';
  static const String orderNumber = 'رقم الطلب';
  static const String orderDate = 'تاريخ الطلب';
  static const String estimatedDelivery = 'الميعاد المتوقع للوصول';
  static const String estimatedDeliveryVal = 'خلال 2 إلى 4 أيام عمل';
  static const String viewMyOrders = 'شوف طلباتك';
  static const String backToShopping = 'ارجع للمتجر';
  static const String deliveryAddressReview = 'عنوان التوصيل';
  static const String itemsInOrder = 'المنتجات المطلوبة';
  static const String depositReceiptReceived =
      'تم إرفاق إيصال التحويل وسيتم مراجعته فوراً لتأكيد تجهيز الطلب 🌸';

  // ---------------------------------------------------------------------------
  // Footer Microcopy
  // ---------------------------------------------------------------------------
  static const String footerAbout =
      'الورشة ELWARSHA علامة تجارية راقية للإكسسوارات المصنوعة يدويًا بعناية، عشان تبرز جمالك ولمستك المميزة في كل لحظة.';
  static const String quickLinks = 'روابط سريعة';
  static const String customerCare = 'خدمة العملاء';
  static const String contactUs = 'تواصل معانا';
  static const String contactPhone = '+20 100 123 4567';
  static const String contactEmail = 'care@elwarsha-accessories.com';
  static const String privacyPolicy = 'سياسة الخصوصية';
  static const String termsOfService = 'شروط الخدمة';
  static const String copyright =
      '© 2026 إكسسوارات الورشة ELWARSHA. جميع الحقوق محفوظة.';

  // ---------------------------------------------------------------------------
  // Validation & Error Handling (Friendly Egyptian Tone)
  // ---------------------------------------------------------------------------
  static const String validationError =
      'اتأكد من استكمال كل البيانات الإلزامية وجرّب تاني';
  static const String requiredField = 'الخانة دي مطلوبة';
  static const String invalidPhone =
      'رقم الموبايل لازم يبدأ بـ 01 ويتكون من 11 رقم';
  static const String promoInvalid =
      'كود الخصم مش صحيح أو خلص وقته، جرّب كود تاني';
  static const String cartEmptyError = 'سلتك فاضية، ضيف منتجات عشان تكمل الطلب';
  static const String accountPending =
      'حسابك قيد المراجعة، هنبلّغك أول ما يتفعّل';

  /// Maps domain failure objects to conversational, friendly Egyptian microcopy.
  static String failureMessage(Failure failure) {
    return failure.friendlyMessage;
  }

  // ---------------------------------------------------------------------------
  // Compatibility Scope Adapter for existing `AppStrings.of(context)` callers
  // ---------------------------------------------------------------------------
  static const AppStringsScope scope = AppStringsScope();
  static AppStringsScope of(BuildContext context) => scope;
  static AppStringsScope forLocale(Locale locale) => scope;
}

/// Instance view of AppStrings to seamlessly support `AppStrings.of(context).propertyName`.
class AppStringsScope {
  const AppStringsScope();

  bool get isArabic => true;
  String get brandName => AppStrings.brandName;
  String get brandNameEn => AppStrings.brandNameEn;
  String get brandSubtitle => AppStrings.brandSubtitle;
  String get brandSubtitleEn => AppStrings.brandSubtitleEn;
  String get currency => AppStrings.currency;
  String get searchPlaceholder => AppStrings.searchPlaceholder;
  String get home => AppStrings.home;
  String get shop => AppStrings.shop;
  String get rings => AppStrings.rings;
  String get bracelets => AppStrings.bracelets;
  String get necklaces => AppStrings.necklaces;
  String get earrings => AppStrings.earrings;
  String get sets => AppStrings.sets;
  String get gifts => AppStrings.gifts;
  String get wishlist => AppStrings.wishlist;
  String get account => AppStrings.account;
  String get cart => AppStrings.cart;
  String get menu => AppStrings.menu;
  String get close => AppStrings.close;
  String get back => AppStrings.back;
  String get productDetails => AppStrings.productDetails;
  String get category => AppStrings.category;
  String get sku => AppStrings.sku;
  String get inStock => AppStrings.inStock;
  String get quantity => AppStrings.quantity;
  String get description => AppStrings.description;
  String get specifications => AppStrings.specifications;
  String get careTips => AppStrings.careTips;
  String get relatedProducts => AppStrings.relatedProducts;
  String get relatedProductsSubtitle => AppStrings.relatedProductsSubtitle;
  String get viewCart => AppStrings.viewCart;
  String get productNotFound => AppStrings.productNotFound;
  String get materialValue => AppStrings.materialValue;
  String get careTipsValue => AppStrings.careTipsValue;
  String get allCategories => AppStrings.allCategories;
  String get bestSellers => AppStrings.bestSellers;
  String get newArrivals => AppStrings.newArrivals;
  String get viewAll => AppStrings.viewAll;
  String get shopByCategory => AppStrings.shopByCategory;
  String get saleBadge => AppStrings.saleBadge;
  String get sale => AppStrings.saleBadge;
  String get newBadge => AppStrings.newBadge;
  String get emptyShelf => AppStrings.emptyShelf;
  String get giftEditEyebrow => AppStrings.giftEditEyebrow;
  String get giftEditTitle => AppStrings.giftEditTitle;
  String get giftEditSubtitle => AppStrings.giftEditSubtitle;
  String get giftEditCta => AppStrings.giftEditCta;
  String get trustFreeWrappingTitle => AppStrings.trustFreeWrappingTitle;
  String get trustFreeWrappingDesc => AppStrings.trustFreeWrappingDesc;
  String get trustEasyExchangeTitle => AppStrings.trustEasyExchangeTitle;
  String get trustEasyExchangeDesc => AppStrings.trustEasyExchangeDesc;
  String get trustSecureCheckoutTitle => AppStrings.trustSecureCheckoutTitle;
  String get trustSecureCheckoutDesc => AppStrings.trustSecureCheckoutDesc;
  String get announcement => AppStrings.announcement;
  String get cartTitle => AppStrings.cartTitle;
  String get cartEmptyTitle => AppStrings.cartEmptyTitle;
  String get cartEmptySubtitle => AppStrings.cartEmptySubtitle;
  String get continueShopping => AppStrings.continueShopping;
  String get proceedToCheckout => AppStrings.proceedToCheckout;
  String get orderSummary => AppStrings.orderSummary;
  String get subtotal => AppStrings.subtotal;
  String get shippingFee => AppStrings.shippingFee;
  String get freeShipping => AppStrings.freeShipping;
  String get freeShippingEligible => AppStrings.freeShippingEligible;
  String get discount => AppStrings.discount;
  String get total => AppStrings.total;
  String get promoCode => AppStrings.promoCode;
  String get promoCodePlaceholder => AppStrings.promoCodePlaceholder;
  String get apply => AppStrings.apply;
  String get remove => AppStrings.remove;
  String get clearCart => AppStrings.clearCart;
  String get itemsCount => AppStrings.itemsCount;
  String get checkoutTitle => AppStrings.checkoutTitle;
  String get shippingDetails => AppStrings.shippingDetails;
  String get fullName => AppStrings.fullName;
  String get fullNameHint => AppStrings.fullNameHint;
  String get phone => AppStrings.phone;
  String get phoneHint => AppStrings.phoneHint;
  String get secondaryPhone => AppStrings.secondaryPhone;
  String get secondaryPhoneHint => AppStrings.secondaryPhoneHint;
  String get governorate => AppStrings.governorate;
  String get selectGovernorate => AppStrings.selectGovernorate;
  String get city => AppStrings.city;
  String get cityHint => AppStrings.cityHint;
  String get address => AppStrings.address;
  String get addressHint => AppStrings.addressHint;
  String get orderNotes => AppStrings.orderNotes;
  String get notesPlaceholder => AppStrings.notesPlaceholder;
  String get paymentMethod => AppStrings.paymentMethod;
  String get paymentMethodsAllowedSubtitle =>
      AppStrings.paymentMethodsAllowedSubtitle;
  String get cashOnDelivery => AppStrings.cashOnDelivery;
  String get cashOnDeliveryDesc => AppStrings.cashOnDeliveryDesc;
  String get instapay => AppStrings.instapay;
  String get instapayDesc => AppStrings.instapayDesc;
  String get instapayNumber => AppStrings.instapayNumber;
  String get instapayNumberLabel => AppStrings.instapayNumberLabel;
  String get instapayAccount => AppStrings.instapayAccount;
  String get instapayAccountLabel => AppStrings.instapayAccountLabel;
  String get instapayInstructions => AppStrings.instapayInstructions;
  String get vodafoneCash => AppStrings.vodafoneCash;
  String get vodafoneCashDesc => AppStrings.vodafoneCashDesc;
  String get vodafoneCashNumber => AppStrings.vodafoneCashNumber;
  String get vodafoneCashNumberLabel => AppStrings.vodafoneCashNumberLabel;
  String get vodafoneCashInstructions => AppStrings.vodafoneCashInstructions;
  String get cardPayment => AppStrings.cardPayment;
  String get cardPaymentDesc => AppStrings.cardPaymentDesc;
  String get placeOrder => AppStrings.placeOrder;
  String get depositScreenshotNoticeTitle =>
      AppStrings.depositScreenshotNoticeTitle;
  String get depositScreenshotNoticeDesc =>
      AppStrings.depositScreenshotNoticeDesc;
  String get depositScreenshotRequired => AppStrings.depositScreenshotRequired;
  String get uploadDepositReceipt => AppStrings.uploadDepositReceipt;
  String get uploadDepositReceiptHint => AppStrings.uploadDepositReceiptHint;
  String get depositReceiptAttached => AppStrings.depositReceiptAttached;
  String get changeReceipt => AppStrings.changeReceipt;
  String get removeReceipt => AppStrings.removeReceipt;
  String get copy => AppStrings.copy;
  String get copied => AppStrings.copied;
  String get downPayment => AppStrings.downPayment;
  String get downPaymentAmount => AppStrings.downPaymentAmount;
  String get downPaymentHint => AppStrings.downPaymentHint;
  String get downPaymentDesc => AppStrings.downPaymentDesc;
  String get downPaymentRequired => AppStrings.downPaymentRequired;
  String get downPaymentExceedsTotal => AppStrings.downPaymentExceedsTotal;
  String get remainingAmount => AppStrings.remainingAmount;
  String get orderConfirmation => AppStrings.orderConfirmation;
  String get orderSuccessTitle => AppStrings.orderSuccessTitle;
  String get orderSuccessSubtitle => AppStrings.orderSuccessSubtitle;
  String get orderNumber => AppStrings.orderNumber;
  String get orderDate => AppStrings.orderDate;
  String get estimatedDelivery => AppStrings.estimatedDelivery;
  String get estimatedDeliveryVal => AppStrings.estimatedDeliveryVal;
  String get viewMyOrders => AppStrings.viewMyOrders;
  String get backToShopping => AppStrings.backToShopping;
  String get deliveryAddressReview => AppStrings.deliveryAddressReview;
  String get itemsInOrder => AppStrings.itemsInOrder;
  String get depositReceiptReceived => AppStrings.depositReceiptReceived;
  String get footerAbout => AppStrings.footerAbout;
  String get quickLinks => AppStrings.quickLinks;
  String get customerCare => AppStrings.customerCare;
  String get contactUs => AppStrings.contactUs;
  String get contactPhone => AppStrings.contactPhone;
  String get contactEmail => AppStrings.contactEmail;
  String get privacyPolicy => AppStrings.privacyPolicy;
  String get termsOfService => AppStrings.termsOfService;
  String get copyright => AppStrings.copyright;
  String get validationError => AppStrings.validationError;
  String get requiredField => AppStrings.requiredField;
  String get invalidPhone => AppStrings.invalidPhone;
  String get promoInvalid => AppStrings.promoInvalid;
  String get cartEmptyError => AppStrings.cartEmptyError;
  String get accountPending => AppStrings.accountPending;
  String get mainCta => AppStrings.mainCta;
  String get addToCart => AppStrings.addToCart;
  String get addedToCart => AppStrings.addedToCart;
  String get continueToCheckout => AppStrings.continueToCheckout;
  String get confirmOrder => AppStrings.confirmOrder;
  String get outOfStock => AppStrings.outOfStock;
  String get soldOut => AppStrings.soldOut;
  String get saleStripTitle => AppStrings.saleStripTitle;
  String get deliveryNote => AppStrings.deliveryNote;
  String get emptyCart => AppStrings.emptyCart;
  String get emptyWishlist => AppStrings.emptyWishlist;
  String get loadingError => AppStrings.loadingError;
  String get noConnection => AppStrings.noConnection;
  String get retry => AppStrings.retry;
  String get loginWelcome => AppStrings.loginWelcome;
  String get otpSent => AppStrings.otpSent;
  String get otpInvalid => AppStrings.otpInvalid;
  String get orderSuccess => AppStrings.orderSuccess;
  String get sessionExpired => AppStrings.sessionExpired;

  String lowStock(int count) => AppStrings.lowStock(count);
  String saveAmount(String amount) => AppStrings.saveAmount(amount);
  String emptySearch(String query) => AppStrings.emptySearch(query);
  String freeShippingRemaining(String amount) =>
      AppStrings.freeShippingRemaining(amount);
}
