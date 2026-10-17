import 'package:warsha_commerce/core/network/api_constants.dart';
import 'package:warsha_commerce/core/network/dio_client.dart';
import 'package:warsha_commerce/features/feedback/data/models/create_feedback_payload.dart';
import 'package:warsha_commerce/features/feedback/data/models/feedback_comment_model.dart';
import 'package:warsha_commerce/features/feedback/data/models/feedback_model.dart';
import 'package:warsha_commerce/features/feedback/data/models/product_feedback_summary_model.dart';
import 'package:warsha_commerce/features/feedback/domain/entities/feedback_type.dart';

abstract class FeedbackRemoteDataSource {
  Future<FeedbackModel> submitFeedback(CreateFeedbackPayload payload);
  Future<List<FeedbackModel>> getFeaturedTestimonials({FeedbackType? type});
  Future<ProductFeedbackSummaryModel> getProductReviews(int productId);
  Future<List<FeedbackModel>> getCustomerFeedbacks();
  Future<FeedbackModel> getFeedbackDetails(int id);
  Future<FeedbackCommentModel> addFeedbackComment(
    int feedbackId,
    String commentText, {
    String? authorName,
  });
}

class FeedbackRemoteDataSourceImpl implements FeedbackRemoteDataSource {
  final DioClient client;

  FeedbackRemoteDataSourceImpl({required this.client});

  @override
  Future<FeedbackModel> submitFeedback(CreateFeedbackPayload payload) async {
    final response = await client.dio.post(
      ApiConstants.feedbacks,
      data: payload.toJson(),
    );
    return FeedbackModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<List<FeedbackModel>> getFeaturedTestimonials({
    FeedbackType? type,
  }) async {
    final queryParams = <String, dynamic>{'featuredOnly': true};
    if (type != null) {
      queryParams['type'] = type.apiValue;
    }
    final response = await client.dio.get(
      ApiConstants.publicFeedbacks,
      queryParameters: queryParams,
    );
    final data = response.data;
    if (data is List) {
      return data
          .map((item) => FeedbackModel.fromJson(item as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  @override
  Future<ProductFeedbackSummaryModel> getProductReviews(int productId) async {
    final response = await client.dio.get(
      ApiConstants.productFeedbacks(productId),
    );
    return ProductFeedbackSummaryModel.fromJson(
      response.data as Map<String, dynamic>,
    );
  }

  @override
  Future<List<FeedbackModel>> getCustomerFeedbacks() async {
    final response = await client.dio.get(ApiConstants.customerFeedbacks);
    final data = response.data;
    if (data is List) {
      return data
          .map((item) => FeedbackModel.fromJson(item as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  @override
  Future<FeedbackModel> getFeedbackDetails(int id) async {
    final response = await client.dio.get(ApiConstants.feedbackDetails(id));
    return FeedbackModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<FeedbackCommentModel> addFeedbackComment(
    int feedbackId,
    String commentText, {
    String? authorName,
  }) async {
    final payload = <String, dynamic>{
      'commentText': commentText,
      if (authorName != null && authorName.trim().isNotEmpty)
        'authorName': authorName.trim(),
    };
    final response = await client.dio.post(
      ApiConstants.feedbackComments(feedbackId),
      data: payload,
    );
    return FeedbackCommentModel.fromJson(response.data as Map<String, dynamic>);
  }
}
