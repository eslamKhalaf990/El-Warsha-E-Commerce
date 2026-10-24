import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:warsha_commerce/core/error/api_error_mapper.dart';
import 'package:warsha_commerce/core/error/failures.dart';

DioException withBody(int status, Object? body) {
  final request = RequestOptions(path: '/orders/checkout');
  return DioException(
    requestOptions: request,
    type: DioExceptionType.badResponse,
    response: Response(requestOptions: request, statusCode: status, data: body),
  );
}

void main() {
  test('network problems become NetworkFailure', () {
    final e = DioException(
      requestOptions: RequestOptions(path: '/x'),
      type: DioExceptionType.connectionError,
    );
    expect(failureFromDio(e), isA<NetworkFailure>());
  });

  test('INSUFFICIENT_STOCK becomes OutOfStockFailure with the server message', () {
    final f = failureFromDio(withBody(409, {
      'status': 409,
      'code': 'INSUFFICIENT_STOCK',
      'message': "'Black bracelet' is out of stock.",
    }));
    expect(f, isA<OutOfStockFailure>());
    expect(f.message, "'Black bracelet' is out of stock.");
  });

  test('VALIDATION_FAILED prefers the first field message', () {
    final f = failureFromDio(withBody(400, {
      'status': 400,
      'code': 'VALIDATION_FAILED',
      'message': 'Some fields are missing or invalid.',
      'details': [
        {'field': 'items', 'message': 'Add at least one product to the order.'}
      ],
    }));
    expect(f, isA<ValidationFailure>());
    expect(f.message, 'Add at least one product to the order.');
  });

  test('UNAUTHENTICATED becomes UnauthorizedFailure', () {
    expect(
      failureFromDio(withBody(401, {'status': 401, 'code': 'UNAUTHENTICATED', 'message': 'Please log in.'})),
      isA<UnauthorizedFailure>(),
    );
  });

  test('a server error is no longer reported as out of stock', () {
    final f = failureFromDio(withBody(500, {
      'status': 500,
      'code': 'INTERNAL_ERROR',
      'message': 'Something went wrong on our side. Please try again.',
    }));
    expect(f, isA<ServerFailure>());
  });

  test('responses without an ApiError body fall back by status', () {
    expect(failureFromDio(withBody(401, 'Unauthorized')), isA<UnauthorizedFailure>());
    expect(failureFromDio(withBody(409, null)), isA<OutOfStockFailure>());
    expect(failureFromDio(withBody(502, '<html>'), fallback: 'x').message, 'x');
  });
}
