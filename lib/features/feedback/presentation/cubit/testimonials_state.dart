import 'package:equatable/equatable.dart';
import 'package:warsha_commerce/features/feedback/domain/entities/feedback_item.dart';
import 'package:warsha_commerce/features/feedback/domain/entities/feedback_type.dart';

enum TestimonialsStatus { initial, loading, success, failure }

class TestimonialsState extends Equatable {
  final TestimonialsStatus status;
  final List<FeedbackItem> testimonials;
  final FeedbackType? selectedType;
  final String? errorMessage;

  const TestimonialsState({
    this.status = TestimonialsStatus.initial,
    this.testimonials = const [],
    this.selectedType,
    this.errorMessage,
  });

  TestimonialsState copyWith({
    TestimonialsStatus? status,
    List<FeedbackItem>? testimonials,
    FeedbackType? selectedType,
    bool clearType = false,
    String? errorMessage,
  }) {
    return TestimonialsState(
      status: status ?? this.status,
      testimonials: testimonials ?? this.testimonials,
      selectedType: clearType ? null : (selectedType ?? this.selectedType),
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, testimonials, selectedType, errorMessage];
}
