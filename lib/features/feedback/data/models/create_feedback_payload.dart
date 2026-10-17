import 'package:warsha_commerce/features/feedback/domain/entities/feedback_type.dart';

class CreateFeedbackPayload {
  final FeedbackType? feedbackType;
  final int rating;
  final String? subject;
  final String comment;
  final int? productId;
  final int? orderId;
  final String? customerName;
  final String? customerEmail;
  final String? customerPhone;

  const CreateFeedbackPayload({
    this.feedbackType,
    required this.rating,
    this.subject,
    required this.comment,
    this.productId,
    this.orderId,
    this.customerName,
    this.customerEmail,
    this.customerPhone,
  });

  Map<String, dynamic> toJson() {
    return {
      if (feedbackType != null) 'feedbackType': feedbackType!.apiValue,
      'rating': rating,
      if (subject != null && subject!.trim().isNotEmpty)
        'subject': subject!.trim(),
      'comment': comment.trim(),
      if (productId != null) 'productId': productId,
      if (orderId != null) 'orderId': orderId,
      if (customerName != null && customerName!.trim().isNotEmpty)
        'customerName': customerName!.trim(),
      if (customerEmail != null && customerEmail!.trim().isNotEmpty)
        'customerEmail': customerEmail!.trim(),
      if (customerPhone != null && customerPhone!.trim().isNotEmpty)
        'customerPhone': customerPhone!.trim(),
    };
  }
}
