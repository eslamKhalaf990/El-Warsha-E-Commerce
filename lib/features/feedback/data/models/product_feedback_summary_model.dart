import 'package:warsha_commerce/features/feedback/data/models/feedback_model.dart';
import 'package:warsha_commerce/features/feedback/domain/entities/product_feedback_summary.dart';

class ProductFeedbackSummaryModel extends ProductFeedbackSummary {
  const ProductFeedbackSummaryModel({
    required super.productId,
    required super.productName,
    required super.averageRating,
    required super.totalReviews,
    required super.ratingDistribution,
    required super.reviews,
  });

  factory ProductFeedbackSummaryModel.fromJson(Map<String, dynamic> json) {
    final reviewsRaw = json['reviews'];
    final reviews = <FeedbackModel>[];
    if (reviewsRaw is List) {
      for (final item in reviewsRaw) {
        if (item is Map<String, dynamic>) {
          reviews.add(FeedbackModel.fromJson(item));
        }
      }
    }

    final distRaw = json['ratingDistribution'];
    final ratingDistribution = <int, int>{5: 0, 4: 0, 3: 0, 2: 0, 1: 0};
    if (distRaw is Map) {
      distRaw.forEach((key, val) {
        final star = int.tryParse(key.toString());
        final count = (val as num?)?.toInt() ?? 0;
        if (star != null) {
          ratingDistribution[star] = count;
        }
      });
    }

    return ProductFeedbackSummaryModel(
      productId: (json['productId'] as num?)?.toInt() ?? 0,
      productName: (json['productName'] ?? '').toString(),
      averageRating: (json['averageRating'] as num?)?.toDouble() ?? 0.0,
      totalReviews: (json['totalReviews'] as num?)?.toInt() ?? reviews.length,
      ratingDistribution: ratingDistribution,
      reviews: reviews,
    );
  }
}
