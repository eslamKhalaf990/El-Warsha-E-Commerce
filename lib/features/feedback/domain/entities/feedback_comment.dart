import 'package:equatable/equatable.dart';

class FeedbackComment extends Equatable {
  final int commentId;
  final int feedbackId;
  final int? customerId;
  final int? userId;
  final String authorName;
  final String authorRole; // 'CUSTOMER' | 'ADMIN'
  final String commentText;
  final DateTime createdAt;

  const FeedbackComment({
    required this.commentId,
    required this.feedbackId,
    this.customerId,
    this.userId,
    required this.authorName,
    required this.authorRole,
    required this.commentText,
    required this.createdAt,
  });

  bool get isAdmin => authorRole.toUpperCase() == 'ADMIN';

  @override
  List<Object?> get props => [
    commentId,
    feedbackId,
    customerId,
    userId,
    authorName,
    authorRole,
    commentText,
    createdAt,
  ];
}
