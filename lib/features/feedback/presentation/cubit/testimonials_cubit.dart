import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:warsha_commerce/features/feedback/domain/entities/feedback_type.dart';
import 'package:warsha_commerce/features/feedback/domain/repositories/feedback_repository.dart';
import 'package:warsha_commerce/features/feedback/presentation/cubit/testimonials_state.dart';

class TestimonialsCubit extends Cubit<TestimonialsState> {
  final FeedbackRepository feedbackRepository;

  TestimonialsCubit({required this.feedbackRepository})
    : super(const TestimonialsState());

  Future<void> loadFeaturedTestimonials({FeedbackType? type}) async {
    emit(
      state.copyWith(
        status: TestimonialsStatus.loading,
        selectedType: type,
        clearType: type == null,
      ),
    );

    final result = await feedbackRepository.getFeaturedTestimonials(type: type);
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: TestimonialsStatus.failure,
          errorMessage: failure.friendlyMessage,
        ),
      ),
      (list) => emit(
        state.copyWith(
          status: TestimonialsStatus.success,
          testimonials: list,
        ),
      ),
    );
  }

  void filterByType(FeedbackType? type) {
    loadFeaturedTestimonials(type: type);
  }
}
