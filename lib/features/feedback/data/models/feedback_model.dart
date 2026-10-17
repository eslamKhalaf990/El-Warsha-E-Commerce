import 'package:warsha_commerce/features/feedback/data/models/feedback_comment_model.dart';
import 'package:warsha_commerce/features/feedback/domain/entities/feedback_item.dart';
import 'package:warsha_commerce/features/feedback/domain/entities/feedback_status.dart';
import 'package:warsha_commerce/features/feedback/domain/entities/feedback_type.dart';

class FeedbackModel extends FeedbackItem {
  const FeedbackModel({
    required super.id,
    super.customerId,
    required super.customerName,
    super.customerEmail,
    super.customerPhone,
    super.productId,
    super.productName,
    super.orderId,
    required super.feedbackType,
    super.subject,
    required super.comment,
    required super.rating,
    required super.status,
    super.isPublic = true,
    super.isFeatured = false,
    super.adminReply,
    super.repliedBy,
    super.repliedAt,
    required super.createdAt,
    super.updatedAt,
    super.comments = const [],
  });

  factory FeedbackModel.fromJson(Map<String, dynamic> json) {
    final rawComments = json['comments'];
    var commentsList = <FeedbackCommentModel>[];
    if (rawComments is List) {
      commentsList = rawComments
          .map((c) => FeedbackCommentModel.fromJson(c as Map<String, dynamic>))
          .toList();
    }

    return FeedbackModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      customerId: (json['customerId'] as num?)?.toInt(),
      customerName: (json['customerName'] ?? 'عميل الورشة').toString(),
      customerEmail: json['customerEmail']?.toString(),
      customerPhone: json['customerPhone']?.toString(),
      productId: (json['productId'] as num?)?.toInt(),
      productName: json['productName']?.toString(),
      orderId: (json['orderId'] as num?)?.toInt(),
      feedbackType: FeedbackType.fromString(json['feedbackType']?.toString()),
      subject: json['subject']?.toString(),
      comment: (json['comment'] ?? '').toString(),
      rating: (json['rating'] as num?)?.toInt() ?? 5,
      status: FeedbackStatus.fromString(json['status']?.toString()),
      isPublic: json['isPublic'] as bool? ?? true,
      isFeatured: json['isFeatured'] as bool? ?? false,
      adminReply: json['adminReply']?.toString(),
      repliedBy: json['repliedBy']?.toString(),
      repliedAt: json['repliedAt'] != null
          ? DateTime.tryParse(json['repliedAt'].toString())
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'].toString())
          : null,
      comments: commentsList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      if (customerId != null) 'customerId': customerId,
      'customerName': customerName,
      if (customerEmail != null) 'customerEmail': customerEmail,
      if (customerPhone != null) 'customerPhone': customerPhone,
      if (productId != null) 'productId': productId,
      if (productName != null) 'productName': productName,
      if (orderId != null) 'orderId': orderId,
      'feedbackType': feedbackType.apiValue,
      if (subject != null) 'subject': subject,
      'comment': comment,
      'rating': rating,
      'status': status.apiValue,
      'isPublic': isPublic,
      'isFeatured': isFeatured,
      if (adminReply != null) 'adminReply': adminReply,
      if (repliedBy != null) 'repliedBy': repliedBy,
      if (repliedAt != null) 'repliedAt': repliedAt?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toIso8601String(),
      'comments': comments
          .map((c) => FeedbackCommentModel(
                commentId: c.commentId,
                feedbackId: c.feedbackId,
                customerId: c.customerId,
                userId: c.userId,
                authorName: c.authorName,
                authorRole: c.authorRole,
                commentText: c.commentText,
                createdAt: c.createdAt,
              ).toJson())
          .toList(),
    };
  }
}
