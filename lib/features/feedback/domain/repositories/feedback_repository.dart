import 'package:dartz/dartz.dart';
import 'package:warsha_commerce/core/error/failures.dart';
import 'package:warsha_commerce/features/feedback/data/models/create_feedback_payload.dart';
import 'package:warsha_commerce/features/feedback/domain/entities/feedback_comment.dart';
import 'package:warsha_commerce/features/feedback/domain/entities/feedback_item.dart';
import 'package:warsha_commerce/features/feedback/domain/entities/feedback_type.dart';
import 'package:warsha_commerce/features/feedback/domain/entities/product_feedback_summary.dart';

abstract class FeedbackRepository {
  Future<Either<Failure, FeedbackItem>> submitFeedback(
    CreateFeedbackPayload payload,
  );
  Future<Either<Failure, List<FeedbackItem>>> getFeaturedTestimonials({
    FeedbackType? type,
  });
  Future<Either<Failure, ProductFeedbackSummary>> getProductReviews(
    int productId,
  );
  Future<Either<Failure, List<FeedbackItem>>> getCustomerFeedbacks();
  Future<Either<Failure, FeedbackItem>> getFeedbackDetails(int id);
  Future<Either<Failure, FeedbackComment>> addFeedbackComment(
    int feedbackId,
    String commentText, {
    String? authorName,
  });
}
