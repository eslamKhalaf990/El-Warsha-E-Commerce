import 'package:equatable/equatable.dart';
import 'package:warsha_commerce/core/l10n/app_strings.dart';

sealed class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  /// Converts any technical failure into a friendly, Egyptian colloquial Arabic microcopy.
  /// If the message is already in Arabic, it preserves it; otherwise maps it to friendly copy.
  String get friendlyMessage {
    final hasArabic = RegExp(r'[\u0600-\u06FF]').hasMatch(message);

    if (this is NetworkFailure) {
      return AppStrings.noConnection;
    } else if (this is UnauthorizedFailure) {
      return AppStrings.sessionExpired;
    } else if (this is OutOfStockFailure) {
      return AppStrings.outOfStock;
    } else if (this is AccountPendingFailure) {
      return AppStrings.accountPending;
    }

    if (hasArabic && message.trim().isNotEmpty) {
      return message;
    }

    if (this is ValidationFailure || this is AuthFailure) {
      return message.isNotEmpty ? message : AppStrings.validationError;
    }

    return AppStrings.loadingError;
  }

  @override
  List<Object?> get props => [message];
}

class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

class AuthFailure extends Failure {
  const AuthFailure(super.message);
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure([super.message = 'Unauthorized']);
}

class AccountPendingFailure extends Failure {
  final String? email;
  const AccountPendingFailure([
    super.message = 'Account pending verification',
    this.email,
  ]);

  @override
  List<Object?> get props => [message, email];
}

class OutOfStockFailure extends Failure {
  const OutOfStockFailure([
    super.message = 'One or more items are out of stock or have price changes',
  ]);
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'Network connection failed']);
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = 'An unexpected server error occurred']);
}
