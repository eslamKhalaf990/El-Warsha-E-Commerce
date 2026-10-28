import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:warsha_commerce/core/error/failures.dart';
import 'package:warsha_commerce/core/l10n/app_strings.dart';
import 'package:warsha_commerce/features/auth/data/auth_error_mapper.dart';

DioException _error(int? status, Object? body, {DioExceptionType type = DioExceptionType.badResponse}) {
  final options = RequestOptions(path: '/auth');
  return DioException(
    requestOptions: options,
    type: type,
    response: status == null ? null : Response(requestOptions: options, statusCode: status, data: body),
  );
}

String _shown(DioException e, AuthAction action) => authFailureFromDio(e, action).friendlyMessage;

void main() {
  group('login', () {
    test('wrong email or password', () {
      expect(_shown(_error(401, 'Invalid customer credentials'), AuthAction.login), AppStrings.wrongCredentials);
    });

    test('inactive account', () {
      expect(_shown(_error(401, 'Account is not active.'), AuthAction.login), AppStrings.accountInactive);
    });

    test('pending account keeps the email for the OTP step', () {
      final f = authFailureFromDio(_error(403, 'Account needs verification. OTP sent to email.'), AuthAction.login,
          email: 'a@b.com');
      expect(f, isA<AccountPendingFailure>());
      expect((f as AccountPendingFailure).email, 'a@b.com');
    });
  });

  group('sign up', () {
    test('email already registered', () {
      expect(_shown(_error(400, 'Registration failed: This email is already registered.'), AuthAction.signUp),
          AppStrings.emailTaken);
    });

    test('a raw database exception is never shown', () {
      const raw = 'Registration failed: could not execute statement; SQL [n/a]; constraint [UQ_Customers_Email]; '
          'nested exception is org.hibernate.exception.ConstraintViolationException: Violation of UNIQUE KEY';
      expect(_shown(_error(400, raw), AuthAction.signUp), AppStrings.emailTaken);
    });

    test('anything else becomes a friendly retry message', () {
      expect(_shown(_error(400, 'Registration failed: Please check your details and try again.'), AuthAction.signUp),
          AppStrings.signUpFailed);
      expect(_shown(_error(400, 'Registration failed: Invalid governorate.'), AuthAction.signUp),
          AppStrings.invalidGovernorate);
    });
  });

  test('a wrong OTP', () {
    expect(_shown(_error(400, 'Invalid or expired OTP'), AuthAction.verifyOtp), AppStrings.otpInvalid);
    expect(_shown(_error(400, 'Invalid or expired OTP, or user not found'), AuthAction.resetPassword),
        AppStrings.otpInvalid);
  });

  test('ApiError JSON bodies are read but never shown', () {
    final body = {'status': 500, 'code': 'INTERNAL_ERROR', 'message': 'Something went wrong on our side.'};
    expect(_shown(_error(500, body), AuthAction.login), AppStrings.loadingError);
  });

  test('no connection', () {
    expect(_shown(_error(null, null, type: DioExceptionType.connectionError), AuthAction.signUp),
        AppStrings.noConnection);
  });

  test('every auth error is shown in Arabic', () {
    final arabic = RegExp(r'[؀-ۿ]');
    for (final action in AuthAction.values) {
      for (final status in [400, 401, 403, 404, 409, 429, 500]) {
        final shown = _shown(_error(status, 'java.lang.RuntimeException: boom'), action);
        expect(arabic.hasMatch(shown), isTrue, reason: '$action $status -> $shown');
      }
    }
  });

  test('the global safety net hides technical text in other features', () {
    expect(const ValidationFailure('{"status":400,"code":"X"}').friendlyMessage, AppStrings.validationError);
    expect(const ServerFailure('DioException [bad response]: status code 500').friendlyMessage,
        AppStrings.loadingError);
    expect(const ValidationFailure('Add at least one product to the order.').friendlyMessage,
        'Add at least one product to the order.');
  });
}
