import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:warsha_commerce/features/feedback/data/models/create_feedback_payload.dart';
import 'package:warsha_commerce/features/feedback/domain/repositories/feedback_repository.dart';
import 'package:warsha_commerce/features/feedback/presentation/cubit/feedback_submission_state.dart';

class FeedbackSubmissionCubit extends Cubit<FeedbackSubmissionState> {
  final FeedbackRepository feedbackRepository;

  FeedbackSubmissionCubit({required this.feedbackRepository})
    : super(const FeedbackSubmissionState());

  Future<bool> submitFeedback(CreateFeedbackPayload payload) async {
    if (payload.rating < 1 || payload.rating > 5) {
      emit(
        state.copyWith(
          status: FeedbackSubmissionStatus.failure,
          errorMessage: 'يرجى تحديد التقييم من 1 إلى 5 نجوم',
        ),
      );
      return false;
    }

    if (payload.comment.trim().isEmpty) {
      emit(
        state.copyWith(
          status: FeedbackSubmissionStatus.failure,
          errorMessage: 'يرجى كتابة تفاصيل التقييم',
        ),
      );
      return false;
    }

    emit(
      state.copyWith(
        status: FeedbackSubmissionStatus.loading,
        clearMessages: true,
      ),
    );

    final result = await feedbackRepository.submitFeedback(payload);
    return result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: FeedbackSubmissionStatus.failure,
            errorMessage: failure.friendlyMessage,
          ),
        );
        return false;
      },
      (submittedItem) {
        emit(
          state.copyWith(
            status: FeedbackSubmissionStatus.success,
            submittedItem: submittedItem,
            successMessage:
                'شكراً لمشاركتنا رأيك! تم استلام تقييمك بنجاح وسوف يساعدنا دائماً على تقديم الأفضل.',
          ),
        );
        return true;
      },
    );
  }

  void reset() {
    emit(const FeedbackSubmissionState());
  }
}
