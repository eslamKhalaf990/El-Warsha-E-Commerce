import 'package:dartz/dartz.dart';
import 'package:warsha_commerce/core/error/failures.dart';
import 'package:warsha_commerce/features/feedback/data/models/create_feedback_payload.dart';
import 'package:warsha_commerce/features/feedback/domain/entities/feedback_comment.dart';
import 'package:warsha_commerce/features/feedback/domain/entities/feedback_item.dart';
import 'package:warsha_commerce/features/feedback/domain/entities/feedback_status.dart';
import 'package:warsha_commerce/features/feedback/domain/entities/feedback_type.dart';
import 'package:warsha_commerce/features/feedback/domain/entities/product_feedback_summary.dart';
import 'package:warsha_commerce/features/feedback/domain/repositories/feedback_repository.dart';

class MockFeedbackRepository implements FeedbackRepository {
  MockFeedbackRepository();

  static final List<FeedbackItem> _mockDatabase = [
    FeedbackItem(
      id: 1,
      customerId: 101,
      customerName: 'سارة محمود',
      customerEmail: 'sara.m@gmail.com',
      productId: 1,
      productName: 'سوار الذهب الوردي المرصع',
      orderId: 501,
      feedbackType: FeedbackType.product,
      subject: 'جودة استثنائية وتغليف فخم جداً',
      comment:
          'اشتريت السوار كهدية لوالدتي، الصنعة ممتازة ومتقنة والتفاصيل أجمل بكثير من الصور على الطبيعة. التغليف المخملي كان لمسة راقية جداً ووصل الطلب في أقل من 48 ساعة.',
      rating: 5,
      status: FeedbackStatus.approved,
      isPublic: true,
      isFeatured: true,
      adminReply:
          'شكراً جزيلاً أستاذة سارة، نسعد دائماً بثقتكم ونتمنى لوالدتك الكريمة دوام الصحة والسعادة ❤️',
      repliedBy: 'فريق خدمة عملاء الورشة',
      repliedAt: DateTime.now().subtract(const Duration(days: 3)),
      createdAt: DateTime.now().subtract(const Duration(days: 4)),
      comments: [
        FeedbackComment(
          commentId: 1001,
          feedbackId: 1,
          authorName: 'فاطمة الزهراء',
          authorRole: 'CUSTOMER',
          commentText: 'هل مقاس السوار قابل للتعديل بسهولة؟',
          createdAt: DateTime.now().subtract(const Duration(days: 2)),
        ),
        FeedbackComment(
          commentId: 1002,
          feedbackId: 1,
          authorName: 'خدمة عملاء الورشة',
          authorRole: 'ADMIN',
          commentText:
              'أهلاً بكِ أستاذة فاطمة، نعم السوار مزود بسلسلة تمديد بطول 3 سم تناسب جميع مقاسات المعصم.',
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
        ),
      ],
    ),
    FeedbackItem(
      id: 2,
      customerId: 102,
      customerName: 'نور الهدى إبراهيم',
      customerEmail: 'nour.hoda@hotmail.com',
      productId: 2,
      productName: 'عقد اللؤلؤ الطبيعي الملكي',
      orderId: 502,
      feedbackType: FeedbackType.product,
      subject: 'تجربة تسوق راقية وتوصيل سريع',
      comment:
          'القطعة تحفة فنية بجد! اللؤلؤ لمعانه طبيعي ومريح جداً في اللبس. خدمة العملاء تعاملهم في منتهى الاحترافية والذوق ومتابعة مستمرة لحد الاستلام.',
      rating: 5,
      status: FeedbackStatus.approved,
      isPublic: true,
      isFeatured: true,
      adminReply:
          'أهلاً بكِ أستاذة نور، سعداء جداً بتجربتك وإعجابك بالعقد، دائماً نسعى لتقديم الأفضل لعملائنا الأعزاء ✨',
      repliedBy: 'إدارة متجر الورشة',
      repliedAt: DateTime.now().subtract(const Duration(days: 5)),
      createdAt: DateTime.now().subtract(const Duration(days: 6)),
      comments: const [],
    ),
    FeedbackItem(
      id: 3,
      customerId: 103,
      customerName: 'مروة عبد الرحمن',
      customerEmail: 'marwa.abdel@yahoo.com',
      productId: 3,
      productName: 'أقراط الزمرد الكلاسيكية',
      feedbackType: FeedbackType.product,
      subject: 'ثبات اللون واللمعان مذهل',
      comment:
          'بستعمل الأقراط بقالي أكثر من شهر ومحافظة على بريقها وجمالها كأنها لسه جديدة تماماً. ده رابع أوردر أطلبه من الورشة وكل مرة بنبهر أكتر بجودة الطلاء.',
      rating: 5,
      status: FeedbackStatus.approved,
      isPublic: true,
      isFeatured: true,
      adminReply: null,
      createdAt: DateTime.now().subtract(const Duration(days: 8)),
      comments: [
        FeedbackComment(
          commentId: 1003,
          feedbackId: 3,
          authorName: 'ياسمين كمال',
          authorRole: 'CUSTOMER',
          commentText: 'هل الوزن خفيف على الأذن ولا تقيل؟',
          createdAt: DateTime.now().subtract(const Duration(days: 7)),
        ),
        FeedbackComment(
          commentId: 1004,
          feedbackId: 3,
          authorName: 'مروة عبد الرحمن',
          authorRole: 'CUSTOMER',
          commentText:
              'خفيفة جداً ومريحة حتى في الاستخدام اليومي الطويل.',
          createdAt: DateTime.now().subtract(const Duration(days: 6)),
        ),
      ],
    ),
    FeedbackItem(
      id: 4,
      customerId: 104,
      customerName: 'د. ياسمين خالد',
      customerEmail: 'dr.yasmeen@gmail.com',
      feedbackType: FeedbackType.service,
      subject: 'أفضل خدمة عملاء وتغليف فاخر في مصر',
      comment:
          'كنت محتاجة الهدية توصل في نفس اليوم لمناسبة خاصة، وتواصلت مع خدمة العملاء وساعدوني بكل ذوق وتم التوصيل في الموعد المحدد مع بطاقة إهداء مكتوبة بخط يدوي جميل.',
      rating: 5,
      status: FeedbackStatus.approved,
      isPublic: true,
      isFeatured: true,
      adminReply:
          'دكتورة ياسمين، نسعد دائماً بمشاركتكم أسعد اللحظات وكل عام وأنتم بخير وسعادة 🎉',
      repliedBy: 'فريق الورشة',
      repliedAt: DateTime.now().subtract(const Duration(days: 9)),
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
      comments: const [],
    ),
    FeedbackItem(
      id: 5,
      customerId: 105,
      customerName: 'أحمد الشناوي',
      customerEmail: 'ahmed.shenawy@gmail.com',
      productId: 1,
      feedbackType: FeedbackType.product,
      subject: 'ممتاز جداً وخامات قوية',
      comment:
          'المنتج جميل جداً وفاق توقعاتي، التقفيل نظيف واللون ثابت.',
      rating: 4,
      status: FeedbackStatus.approved,
      isPublic: true,
      isFeatured: false,
      adminReply: 'شكراً لك أستاذ أحمد على ثقتك واختيارك الورشة!',
      repliedBy: 'خدمة العملاء',
      repliedAt: DateTime.now().subtract(const Duration(days: 12)),
      createdAt: DateTime.now().subtract(const Duration(days: 13)),
      comments: const [],
    ),
    FeedbackItem(
      id: 6,
      customerId: 101, // Belongs to customer 101 (for testing customer reviews)
      customerName: 'سارة محمود',
      customerEmail: 'sara.m@gmail.com',
      feedbackType: FeedbackType.suggestion,
      subject: 'اقتراح لتوفير تشكيلة أوسع من الخواتم الرجالية الفضية',
      comment:
          'يا ريت تضيفوا قسم خاص بالخواتم والإكسسوارات الرجالية المصنوعة من الفضة عيار 925 بتصميمات تراثية.',
      rating: 5,
      status: FeedbackStatus.resolved,
      isPublic: false,
      isFeatured: false,
      adminReply:
          'اقتراح رائع أستاذة سارة! بالفعل نقوم بالتحضير لمجموعة خاصة بالفضيات التراثية وسيتم إطلاقها قريباً جداً بإذن الله.',
      repliedBy: 'مدير التطوير بالورشة',
      repliedAt: DateTime.now().subtract(const Duration(days: 1)),
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      comments: const [],
    ),
    FeedbackItem(
      id: 7,
      customerId: 101, // Belongs to customer 101 (for testing customer reviews)
      customerName: 'سارة محمود',
      customerEmail: 'sara.m@gmail.com',
      productId: 4,
      productName: 'طقم الفراشة الملكية مطلي بالذهب',
      feedbackType: FeedbackType.product,
      subject: 'طلب جديد وملاحظة على التوصيل',
      comment:
          'الطقم جميل ومطابق للوصف ولكن مندوب الشحن تأخر بضع ساعات عن الموعد المحدد.',
      rating: 4,
      status: FeedbackStatus.pending,
      isPublic: false,
      isFeatured: false,
      adminReply: null,
      createdAt: DateTime.now().subtract(const Duration(hours: 6)),
      comments: const [],
    ),
  ];

  @override
  Future<Either<Failure, FeedbackItem>> submitFeedback(
    CreateFeedbackPayload payload,
  ) async {
    final newId = _mockDatabase.length + 1;
    final newItem = FeedbackItem(
      id: newId,
      customerId: 101,
      customerName: payload.customerName ?? 'عميل الورشة',
      customerEmail: payload.customerEmail,
      customerPhone: payload.customerPhone,
      productId: payload.productId,
      orderId: payload.orderId,
      feedbackType: payload.feedbackType ?? FeedbackType.product,
      subject: payload.subject,
      comment: payload.comment,
      rating: payload.rating,
      status: FeedbackStatus.pending, // Pending review initially
      isPublic: true,
      isFeatured: false,
      createdAt: DateTime.now(),
      comments: const [],
    );

    _mockDatabase.insert(0, newItem);
    return Right(newItem);
  }

  @override
  Future<Either<Failure, List<FeedbackItem>>> getFeaturedTestimonials({
    FeedbackType? type,
  }) async {
    final list = _mockDatabase
        .where(
          (f) =>
              f.status == FeedbackStatus.approved &&
              f.isFeatured &&
              (type == null || f.feedbackType == type),
        )
        .toList();
    return Right(list);
  }

  @override
  Future<Either<Failure, ProductFeedbackSummary>> getProductReviews(
    int productId,
  ) async {
    final productReviews = _mockDatabase
        .where(
          (f) =>
              (f.productId == productId || f.productId == null) &&
              f.status == FeedbackStatus.approved,
        )
        .toList();

    if (productReviews.isEmpty) {
      // Return representative reviews so the UI displays nicely
      final fallbackReviews = _mockDatabase
          .where((f) => f.status == FeedbackStatus.approved)
          .take(3)
          .toList();
      final dist = <int, int>{5: 2, 4: 1, 3: 0, 2: 0, 1: 0};
      return Right(
        ProductFeedbackSummary(
          productId: productId,
          productName: 'المنتج',
          averageRating: 4.8,
          totalReviews: fallbackReviews.length,
          ratingDistribution: dist,
          reviews: fallbackReviews,
        ),
      );
    }

    final dist = <int, int>{5: 0, 4: 0, 3: 0, 2: 0, 1: 0};
    double sum = 0;
    for (final r in productReviews) {
      dist[r.rating] = (dist[r.rating] ?? 0) + 1;
      sum += r.rating;
    }
    final avg = productReviews.isNotEmpty
        ? (sum / productReviews.length)
        : 0.0;

    return Right(
      ProductFeedbackSummary(
        productId: productId,
        productName: productReviews.first.productName ?? 'المنتج',
        averageRating: double.parse(avg.toStringAsFixed(1)),
        totalReviews: productReviews.length,
        ratingDistribution: dist,
        reviews: productReviews,
      ),
    );
  }

  @override
  Future<Either<Failure, List<FeedbackItem>>> getCustomerFeedbacks() async {
    // Return feedbacks matching current user (or fallback to customer 101)
    final list = _mockDatabase.where((f) => f.customerId == 101).toList();
    return Right(list);
  }

  @override
  Future<Either<Failure, FeedbackItem>> getFeedbackDetails(int id) async {
    final item = _mockDatabase.firstWhere(
      (f) => f.id == id,
      orElse: () => _mockDatabase.first,
    );
    return Right(item);
  }

  @override
  Future<Either<Failure, FeedbackComment>> addFeedbackComment(
    int feedbackId,
    String commentText, {
    String? authorName,
  }) async {
    final newComment = FeedbackComment(
      commentId: DateTime.now().millisecondsSinceEpoch,
      feedbackId: feedbackId,
      authorName: authorName ?? 'عميل الورشة',
      authorRole: 'CUSTOMER',
      commentText: commentText,
      createdAt: DateTime.now(),
    );

    final index = _mockDatabase.indexWhere((f) => f.id == feedbackId);
    if (index != -1) {
      final current = _mockDatabase[index];
      final updatedComments = List<FeedbackComment>.from(current.comments)
        ..add(newComment);
      _mockDatabase[index] = current.copyWith(comments: updatedComments);
    }

    return Right(newComment);
  }
}
