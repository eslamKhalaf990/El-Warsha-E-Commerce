import 'package:dio/dio.dart';
import 'package:warsha_commerce/core/error/failures.dart';
import 'package:warsha_commerce/core/l10n/app_strings.dart';

/// The auth call that failed; the same HTTP status means different things per call.
enum AuthAction { login, signUp, verifyOtp, resendOtp, forgotPassword, resetPassword }

/// Turns a failed auth request into a [Failure] whose message is friendly Arabic copy.
///
/// The customer auth endpoints answer errors with plain text (e.g. "Invalid customer
/// credentials") or an ApiError JSON body. Neither is shown to the customer: only the
/// status, the ApiError `code` and a few known phrases are read.
Failure authFailureFromDio(DioException e, AuthAction action, {String? email}) {
  switch (e.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
    case DioExceptionType.connectionError:
      return const NetworkFailure();
    default:
      break;
  }

  final status = e.response?.statusCode;
  final body = _bodyText(e.response?.data).toLowerCase();
  final code = _code(e.response?.data);

  if (status == 429) return const AuthFailure(AppStrings.tooManyAttempts);
  if (status == null || status >= 500 || code == 'INTERNAL_ERROR') {
    return switch (action) {
      AuthAction.resendOtp || AuthAction.forgotPassword => const ServerFailure(AppStrings.otpSendFailed),
      _ => const ServerFailure(AppStrings.loadingError),
    };
  }

  switch (action) {
    case AuthAction.login:
      if (status == 403) return AccountPendingFailure(AppStrings.accountPending, email);
      if (body.contains('not active')) return const AuthFailure(AppStrings.accountInactive);
      if (status == 401 || status == 400) return const AuthFailure(AppStrings.wrongCredentials);

    case AuthAction.signUp:
      if (status == 409 || _mentionsDuplicate(body)) return const ValidationFailure(AppStrings.emailTaken);
      if (body.contains('governorate')) return const ValidationFailure(AppStrings.invalidGovernorate);
      return const ValidationFailure(AppStrings.signUpFailed);

    case AuthAction.verifyOtp:
    case AuthAction.resetPassword:
      if (status == 400 || status == 404) return const AuthFailure(AppStrings.otpInvalid);

    case AuthAction.resendOtp:
      return const ServerFailure(AppStrings.otpSendFailed);

    case AuthAction.forgotPassword:
      return const AuthFailure(AppStrings.resetCodeFailed);
  }

  return const ValidationFailure(AppStrings.validationError);
}

bool _mentionsDuplicate(String body) =>
    body.contains('already') || body.contains('duplicate') || body.contains('unique');

String _bodyText(Object? data) {
  if (data is String) return data;
  if (data is Map) return '${data['message'] ?? ''} ${data['code'] ?? ''}';
  return '';
}

String? _code(Object? data) {
  if (data is Map && data['code'] is String) return data['code'] as String;
  if (data is String && data.contains('"code"')) {
    return RegExp(r'"code"\s*:\s*"([A-Z_]+)"').firstMatch(data)?.group(1);
  }
  return null;
}
