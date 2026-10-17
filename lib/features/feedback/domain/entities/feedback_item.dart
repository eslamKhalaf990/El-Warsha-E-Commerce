import 'package:equatable/equatable.dart';
import 'package:warsha_commerce/features/feedback/domain/entities/feedback_comment.dart';
import 'package:warsha_commerce/features/feedback/domain/entities/feedback_status.dart';
import 'package:warsha_commerce/features/feedback/domain/entities/feedback_type.dart';

class FeedbackItem extends Equatable {
  final int id;
  final int? customerId;
  final String customerName;
  final String? customerEmail;
  final String? customerPhone;
  final int? productId;
  final String? productName;
  final int? orderId;
  final FeedbackType feedbackType;
  final String? subject;
  final String comment;
  final int rating; // 1 to 5
  final FeedbackStatus status;
  final bool isPublic;
  final bool isFeatured;
  final String? adminReply;
  final String? repliedBy;
  final DateTime? repliedAt;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final List<FeedbackComment> comments;

  const FeedbackItem({
    required this.id,
    this.customerId,
    required this.customerName,
    this.customerEmail,
    this.customerPhone,
    this.productId,
    this.productName,
    this.orderId,
    required this.feedbackType,
    this.subject,
    required this.comment,
    required this.rating,
    required this.status,
    this.isPublic = true,
    this.isFeatured = false,
    this.adminReply,
    this.repliedBy,
    this.repliedAt,
    required this.createdAt,
    this.updatedAt,
    this.comments = const [],
  });

  bool get hasAdminReply => adminReply != null && adminReply!.trim().isNotEmpty;

  FeedbackItem copyWith({
    int? id,
    int? customerId,
    String? customerName,
    String? customerEmail,
    String? customerPhone,
    int? productId,
    String? productName,
    int? orderId,
    FeedbackType? feedbackType,
    String? subject,
    String? comment,
    int? rating,
    FeedbackStatus? status,
    bool? isPublic,
    bool? isFeatured,
    String? adminReply,
    String? repliedBy,
    DateTime? repliedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<FeedbackComment>? comments,
  }) {
    return FeedbackItem(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      customerName: customerName ?? this.customerName,
      customerEmail: customerEmail ?? this.customerEmail,
      customerPhone: customerPhone ?? this.customerPhone,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      orderId: orderId ?? this.orderId,
      feedbackType: feedbackType ?? this.feedbackType,
      subject: subject ?? this.subject,
      comment: comment ?? this.comment,
      rating: rating ?? this.rating,
      status: status ?? this.status,
      isPublic: isPublic ?? this.isPublic,
      isFeatured: isFeatured ?? this.isFeatured,
      adminReply: adminReply ?? this.adminReply,
      repliedBy: repliedBy ?? this.repliedBy,
      repliedAt: repliedAt ?? this.repliedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      comments: comments ?? this.comments,
    );
  }

  @override
  List<Object?> get props => [
    id,
    customerId,
    customerName,
    customerEmail,
    customerPhone,
    productId,
    productName,
    orderId,
    feedbackType,
    subject,
    comment,
    rating,
    status,
    isPublic,
    isFeatured,
    adminReply,
    repliedBy,
    repliedAt,
    createdAt,
    updatedAt,
    comments,
  ];
}
