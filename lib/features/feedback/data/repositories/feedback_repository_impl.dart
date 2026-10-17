import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:warsha_commerce/core/error/failures.dart';
import 'package:warsha_commerce/features/feedback/data/datasources/feedback_remote_datasource.dart';
import 'package:warsha_commerce/features/feedback/data/models/create_feedback_payload.dart';
import 'package:warsha_commerce/features/feedback/data/repositories/mock_feedback_repository.dart';
import 'package:warsha_commerce/features/feedback/domain/entities/feedback_comment.dart';
import 'package:warsha_commerce/features/feedback/domain/entities/feedback_item.dart';
import 'package:warsha_commerce/features/feedback/domain/entities/feedback_type.dart';
import 'package:warsha_commerce/features/feedback/domain/entities/product_feedback_summary.dart';
import 'package:warsha_commerce/features/feedback/domain/repositories/feedback_repository.dart';

class FeedbackRepositoryImpl implements FeedbackRepository {
  final FeedbackRemoteDataSource remoteDataSource;
  final MockFeedbackRepository _fallbackRepo = MockFeedbackRepository();

  FeedbackRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, FeedbackItem>> submitFeedback(
    CreateFeedbackPayload payload,
  ) async {
    try {
      final result = await remoteDataSource.submitFeedback(payload);
      return Right(result);
    } on DioException catch (e) {
      // If connection refused / server offline, fallback gracefully
      if (_isConnectionError(e)) {
        return _fallbackRepo.submitFeedback(payload);
      }
      return Left(ServerFailure(e.message ?? 'فشل في إرسال التقييم'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<FeedbackItem>>> getFeaturedTestimonials({
    FeedbackType? type,
  }) async {
    try {
      final result = await remoteDataSource.getFeaturedTestimonials(type: type);
      if (result.isEmpty) {
        return await _fallbackRepo.getFeaturedTestimonials(type: type);
      }
      return Right(result);
    } on DioException catch (e) {
      if (_isConnectionError(e)) {
        return _fallbackRepo.getFeaturedTestimonials(type: type);
      }
      return Left(ServerFailure(e.message ?? 'فشل في جلب التقييمات المميزة'));
    } catch (e) {
      return _fallbackRepo.getFeaturedTestimonials(type: type);
    }
  }

  @override
  Future<Either<Failure, ProductFeedbackSummary>> getProductReviews(
    int productId,
  ) async {
    try {
      final result = await remoteDataSource.getProductReviews(productId);
      return Right(result);
    } on DioException catch (e) {
      if (_isConnectionError(e)) {
        return _fallbackRepo.getProductReviews(productId);
      }
      return Left(ServerFailure(e.message ?? 'فشل في جلب تقييمات المنتج'));
    } catch (e) {
      return _fallbackRepo.getProductReviews(productId);
    }
  }

  @override
  Future<Either<Failure, List<FeedbackItem>>> getCustomerFeedbacks() async {
    try {
      final result = await remoteDataSource.getCustomerFeedbacks();
      return Right(result);
    } on DioException catch (e) {
      if (_isConnectionError(e)) {
        return _fallbackRepo.getCustomerFeedbacks();
      }
      return Left(ServerFailure(e.message ?? 'فشل في جلب تقييماتك'));
    } catch (e) {
      return _fallbackRepo.getCustomerFeedbacks();
    }
  }

  @override
  Future<Either<Failure, FeedbackItem>> getFeedbackDetails(int id) async {
    try {
      final result = await remoteDataSource.getFeedbackDetails(id);
      return Right(result);
    } on DioException catch (e) {
      if (_isConnectionError(e)) {
        return _fallbackRepo.getFeedbackDetails(id);
      }
      return Left(ServerFailure(e.message ?? 'فشل في جلب تفاصيل التقييم'));
    } catch (e) {
      return _fallbackRepo.getFeedbackDetails(id);
    }
  }

  @override
  Future<Either<Failure, FeedbackComment>> addFeedbackComment(
    int feedbackId,
    String commentText, {
    String? authorName,
  }) async {
    try {
      final result = await remoteDataSource.addFeedbackComment(
        feedbackId,
        commentText,
        authorName: authorName,
      );
      return Right(result);
    } on DioException catch (e) {
      if (_isConnectionError(e)) {
        return _fallbackRepo.addFeedbackComment(
          feedbackId,
          commentText,
          authorName: authorName,
        );
      }
      return Left(ServerFailure(e.message ?? 'فشل في إضافة الرد'));
    } catch (e) {
      return _fallbackRepo.addFeedbackComment(
        feedbackId,
        commentText,
        authorName: authorName,
      );
    }
  }

  bool _isConnectionError(DioException e) {
    return e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.unknown;
  }
}
