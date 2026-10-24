import 'package:dio/dio.dart';
import 'package:warsha_commerce/core/error/failures.dart';

/// Turns a [DioException] into a [Failure] using the backend's ApiError body:
/// `{ status, code, message, details: [{field, message}], requestId }`.
///
/// The `code` decides the failure type (and so the Arabic copy the UI shows via
/// [Failure.friendlyMessage]); [fallback] is used when the server sent nothing usable.
Failure failureFromDio(DioException e, {String? fallback}) {
  switch (e.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
    case DioExceptionType.connectionError:
      return const NetworkFailure();
    default:
      break;
  }

  final data = e.response?.data;
  if (data is Map && data['code'] is String) {
    final code = data['code'] as String;
    final message = _messageOf(data) ?? fallback ?? '';
    return switch (code) {
      'UNAUTHENTICATED' => const UnauthorizedFailure(),
      'INSUFFICIENT_STOCK' => OutOfStockFailure(message),
      'VALIDATION_FAILED' || 'MALFORMED_REQUEST' => ValidationFailure(message),
      _ => ServerFailure(message),
    };
  }

  final status = e.response?.statusCode;
  if (status == 401) return const UnauthorizedFailure();
  if (status == 409) return const OutOfStockFailure();
  return ServerFailure(fallback ?? e.message ?? '');
}

/// The first field error if there is one (most specific), otherwise the main message.
String? _messageOf(Map data) {
  final details = data['details'];
  if (details is List && details.isNotEmpty) {
    final first = details.first;
    if (first is Map && first['message'] is String && (first['message'] as String).isNotEmpty) {
      return first['message'] as String;
    }
  }
  final message = data['message'];
  return message is String && message.isNotEmpty ? message : null;
}
