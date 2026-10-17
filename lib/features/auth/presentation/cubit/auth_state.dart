import 'package:equatable/equatable.dart';
import 'package:warsha_commerce/features/profile/domain/entities/customer.dart';

enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
  otpRequired,
  forgotPasswordSent,
  passwordResetSuccess,
  failure,
}

enum CheckoutAuthMode {
  login,
  signUp,
  verifyOtp,
  forgotPassword,
  resetPassword,
}

class AuthState extends Equatable {
  final AuthStatus status;
  final Customer? customer;
  final CheckoutAuthMode activeMode;
  final String email;
  final String? pendingPassword;
  final String? message;
  final String? errorMessage;

  const AuthState({
    this.status = AuthStatus.initial,
    this.customer,
    this.activeMode = CheckoutAuthMode.login,
    this.email = '',
    this.pendingPassword,
    this.message,
    this.errorMessage,
  });

  bool get isAuthenticated =>
      status == AuthStatus.authenticated && customer != null;
  bool get isLoading => status == AuthStatus.loading;

  AuthState copyWith({
    AuthStatus? status,
    Customer? customer,
    CheckoutAuthMode? activeMode,
    String? email,
    String? pendingPassword,
    String? message,
    String? errorMessage,
    bool clearCustomer = false,
    bool clearMessage = false,
    bool clearError = false,
  }) {
    return AuthState(
      status: status ?? this.status,
      customer: clearCustomer ? null : (customer ?? this.customer),
      activeMode: activeMode ?? this.activeMode,
      email: email ?? this.email,
      pendingPassword: pendingPassword ?? this.pendingPassword,
      message: clearMessage ? null : (message ?? this.message),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [
    status,
    customer,
    activeMode,
    email,
    pendingPassword,
    message,
    errorMessage,
  ];
}
