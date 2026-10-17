import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:warsha_commerce/features/feedback/domain/entities/feedback_comment.dart';
import 'package:warsha_commerce/features/feedback/domain/repositories/feedback_repository.dart';
import 'package:warsha_commerce/features/feedback/presentation/cubit/customer_feedback_state.dart';

class CustomerFeedbackCubit extends Cubit<CustomerFeedbackState> {
  final FeedbackRepository feedbackRepository;

  CustomerFeedbackCubit({required this.feedbackRepository})
    : super(const CustomerFeedbackState());

  Future<void> loadCustomerFeedbacks() async {
    emit(
      state.copyWith(
        status: CustomerFeedbackStatus.loading,
        clearMessages: true,
      ),
    );

    final result = await feedbackRepository.getCustomerFeedbacks();
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: CustomerFeedbackStatus.failure,
          errorMessage: failure.friendlyMessage,
        ),
      ),
      (feedbacks) => emit(
        state.copyWith(
          status: CustomerFeedbackStatus.success,
          feedbacks: feedbacks,
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
        final updatedList = state.feedbacks.map((f) {
          if (f.id == feedbackId) {
            final newComments = List<FeedbackComment>.from(f.comments)
              ..add(newComment);
            return f.copyWith(comments: newComments);
          }
          return f;
        }).toList();

        emit(
          state.copyWith(
            isSubmittingComment: false,
            feedbacks: updatedList,
            message: 'تم إضافة تعليقك بنجاح',
          ),
        );
        return true;
      },
    );
  }
}
