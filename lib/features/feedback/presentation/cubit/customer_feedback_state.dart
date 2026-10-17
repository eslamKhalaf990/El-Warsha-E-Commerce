import 'package:equatable/equatable.dart';
import 'package:warsha_commerce/features/feedback/domain/entities/feedback_item.dart';

enum CustomerFeedbackStatus { initial, loading, success, failure }

class CustomerFeedbackState extends Equatable {
  final CustomerFeedbackStatus status;
  final List<FeedbackItem> feedbacks;
  final bool isSubmittingComment;
  final String? errorMessage;
  final String? message;

  const CustomerFeedbackState({
    this.status = CustomerFeedbackStatus.initial,
    this.feedbacks = const [],
    this.isSubmittingComment = false,
    this.errorMessage,
    this.message,
  });

  CustomerFeedbackState copyWith({
    CustomerFeedbackStatus? status,
    List<FeedbackItem>? feedbacks,
    bool? isSubmittingComment,
    String? errorMessage,
    String? message,
    bool clearMessages = false,
  }) {
    return CustomerFeedbackState(
      status: status ?? this.status,
      feedbacks: feedbacks ?? this.feedbacks,
      isSubmittingComment: isSubmittingComment ?? this.isSubmittingComment,
      errorMessage: clearMessages ? null : (errorMessage ?? this.errorMessage),
      message: clearMessages ? null : (message ?? this.message),
    );
  }

  @override
  List<Object?> get props => [
    status,
    feedbacks,
    isSubmittingComment,
    errorMessage,
    message,
  ];
}
