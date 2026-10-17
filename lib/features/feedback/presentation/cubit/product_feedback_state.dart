import 'package:equatable/equatable.dart';
import 'package:warsha_commerce/features/feedback/domain/entities/product_feedback_summary.dart';

enum ProductFeedbackStatus { initial, loading, success, failure }

class ProductFeedbackState extends Equatable {
  final ProductFeedbackStatus status;
  final ProductFeedbackSummary? summary;
  final bool isSubmittingComment;
  final String? errorMessage;
  final String? commentSuccessMessage;

  const ProductFeedbackState({
    this.status = ProductFeedbackStatus.initial,
    this.summary,
    this.isSubmittingComment = false,
    this.errorMessage,
    this.commentSuccessMessage,
  });

  ProductFeedbackState copyWith({
    ProductFeedbackStatus? status,
    ProductFeedbackSummary? summary,
    bool? isSubmittingComment,
    String? errorMessage,
    String? commentSuccessMessage,
    bool clearMessages = false,
  }) {
    return ProductFeedbackState(
      status: status ?? this.status,
      summary: summary ?? this.summary,
      isSubmittingComment: isSubmittingComment ?? this.isSubmittingComment,
      errorMessage: clearMessages ? null : (errorMessage ?? this.errorMessage),
      commentSuccessMessage: clearMessages
          ? null
          : (commentSuccessMessage ?? this.commentSuccessMessage),
    );
  }

  @override
  List<Object?> get props => [
    status,
    summary,
    isSubmittingComment,
    errorMessage,
    commentSuccessMessage,
  ];
}
