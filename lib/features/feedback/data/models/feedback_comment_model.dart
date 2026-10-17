import 'package:warsha_commerce/features/feedback/domain/entities/feedback_comment.dart';

class FeedbackCommentModel extends FeedbackComment {
  const FeedbackCommentModel({
    required super.commentId,
    required super.feedbackId,
    super.customerId,
    super.userId,
    required super.authorName,
    required super.authorRole,
    required super.commentText,
    required super.createdAt,
  });

  factory FeedbackCommentModel.fromJson(Map<String, dynamic> json) {
    return FeedbackCommentModel(
      commentId: (json['commentId'] as num?)?.toInt() ?? 0,
      feedbackId: (json['feedbackId'] as num?)?.toInt() ?? 0,
      customerId: (json['customerId'] as num?)?.toInt(),
      userId: (json['userId'] as num?)?.toInt(),
      authorName: (json['authorName'] ?? 'زائر').toString(),
      authorRole: (json['authorRole'] ?? 'CUSTOMER').toString(),
      commentText: (json['commentText'] ?? '').toString(),
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'commentId': commentId,
      'feedbackId': feedbackId,
      if (customerId != null) 'customerId': customerId,
      if (userId != null) 'userId': userId,
      'authorName': authorName,
      'authorRole': authorRole,
      'commentText': commentText,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
