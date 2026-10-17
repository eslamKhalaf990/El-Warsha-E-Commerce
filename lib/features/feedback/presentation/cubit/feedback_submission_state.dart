import 'package:equatable/equatable.dart';
import 'package:warsha_commerce/features/feedback/domain/entities/feedback_item.dart';

enum FeedbackSubmissionStatus { initial, loading, success, failure }

class FeedbackSubmissionState extends Equatable {
  final FeedbackSubmissionStatus status;
  final FeedbackItem? submittedItem;
  final String? errorMessage;
  final String? successMessage;

  const FeedbackSubmissionState({
    this.status = FeedbackSubmissionStatus.initial,
    this.submittedItem,
    this.errorMessage,
    this.successMessage,
  });

  FeedbackSubmissionState copyWith({
    FeedbackSubmissionStatus? status,
    FeedbackItem? submittedItem,
    String? errorMessage,
    String? successMessage,
    bool clearMessages = false,
  }) {
    return FeedbackSubmissionState(
      status: status ?? this.status,
      submittedItem: submittedItem ?? this.submittedItem,
      errorMessage: clearMessages ? null : (errorMessage ?? this.errorMessage),
      successMessage: clearMessages
          ? null
          : (successMessage ?? this.successMessage),
    );
  }

  @override
  List<Object?> get props => [
    status,
    submittedItem,
    errorMessage,
    successMessage,
  ];
}
