import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:warsha_commerce/features/feedback/domain/entities/feedback_comment.dart';
import 'package:warsha_commerce/features/feedback/domain/entities/feedback_item.dart';
import 'package:warsha_commerce/features/feedback/domain/entities/product_feedback_summary.dart';
import 'package:warsha_commerce/features/feedback/domain/repositories/feedback_repository.dart';
import 'package:warsha_commerce/features/feedback/presentation/cubit/product_feedback_state.dart';

class ProductFeedbackCubit extends Cubit<ProductFeedbackState> {
  final FeedbackRepository feedbackRepository;
  int? _currentProductId;

  ProductFeedbackCubit({required this.feedbackRepository})
    : super(const ProductFeedbackState());

  Future<void> loadProductReviews(int productId) async {
    _currentProductId = productId;
    emit(
      state.copyWith(
        status: ProductFeedbackStatus.loading,
        clearMessages: true,
      ),
    );

    final result = await feedbackRepository.getProductReviews(productId);
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ProductFeedbackStatus.failure,
          errorMessage: failure.friendlyMessage,
        ),
      ),
      (summary) => emit(
        state.copyWith(
          status: ProductFeedbackStatus.success,
          summary: summary,
        ),
      ),
    );
  }

  Future<bool> addComment({
    required int feedbackId,
    required String commentText,
    String? authorName,
  }) async {
    if (commentText.trim().isEmpty) return false;

    emit(
      state.copyWith(
        isSubmittingComment: true,
        clearMessages: true,
      ),
    );

    final result = await feedbackRepository.addFeedbackComment(
      feedbackId,
      commentText.trim(),
      authorName: authorName,
    );

    return result.fold(
      (failure) {
        emit(
          state.copyWith(
            isSubmittingComment: false,
            errorMessage: failure.friendlyMessage,
          ),
        );
        return false;
      },
      (newComment) {
        // Update review in existing summary
        if (state.summary != null) {
          final updatedReviews = state.summary!.reviews.map((r) {
            if (r.id == feedbackId) {
              final newComments = List<FeedbackComment>.from(r.comments)
                ..add(newComment);
              return r.copyWith(comments: newComments);
            }
            return r;
          }).toList();

          final updatedSummary = ProductFeedbackSummary(
            productId: state.summary!.productId,
            productName: state.summary!.productName,
            averageRating: state.summary!.averageRating,
            totalReviews: state.summary!.totalReviews,
            ratingDistribution: state.summary!.ratingDistribution,
            reviews: updatedReviews,
          );

          emit(
            state.copyWith(
              isSubmittingComment: false,
              summary: updatedSummary,
              commentSuccessMessage: 'تم إضافة تعليقك بنجاح',
            ),
          );
        } else {
          emit(
            state.copyWith(
              isSubmittingComment: false,
              commentSuccessMessage: 'تم إضافة تعليقك بنجاح',
            ),
          );
        }
        return true;
      },
    );
  }

  void onFeedbackSubmitted(FeedbackItem item) {
    if (_currentProductId != null) {
      loadProductReviews(_currentProductId!);
    }
  }
}
