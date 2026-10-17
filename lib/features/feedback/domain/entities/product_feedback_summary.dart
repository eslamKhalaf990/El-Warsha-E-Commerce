import 'package:equatable/equatable.dart';
import 'package:warsha_commerce/features/feedback/domain/entities/feedback_item.dart';

class ProductFeedbackSummary extends Equatable {
  final int productId;
  final String productName;
  final double averageRating;
  final int totalReviews;
  final Map<int, int> ratingDistribution; // { 5: 12, 4: 2, 3: 0, 2: 0, 1: 0 }
  final List<FeedbackItem> reviews;

  const ProductFeedbackSummary({
    required this.productId,
    required this.productName,
    required this.averageRating,
    required this.totalReviews,
    required this.ratingDistribution,
    required this.reviews,
  });

  factory ProductFeedbackSummary.empty(
    int productId, [
    String productName = '',
  ]) {
    return ProductFeedbackSummary(
      productId: productId,
      productName: productName,
      averageRating: 0.0,
      totalReviews: 0,
      ratingDistribution: const {5: 0, 4: 0, 3: 0, 2: 0, 1: 0},
      reviews: const [],
    );
  }

  @override
  List<Object?> get props => [
    productId,
    productName,
    averageRating,
    totalReviews,
    ratingDistribution,
    reviews,
  ];
}
