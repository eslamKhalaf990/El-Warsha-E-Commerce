import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:warsha_commerce/core/error/failures.dart';
import 'package:warsha_commerce/features/auth/domain/repositories/auth_repository.dart';
import 'package:warsha_commerce/features/auth/presentation/cubit/auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository authRepository;

  AuthCubit({required this.authRepository}) : super(const AuthState());

  Future<void> checkAuth() async {
    final user = await authRepository.getCurrentUser();
    if (user != null) {
      emit(
        state.copyWith(
          status: AuthStatus.authenticated,
          customer: user,
          email: user.email,
        ),
      );
    } else {
      emit(state.copyWith(status: AuthStatus.unauthenticated));
    }
  }

  void switchMode(CheckoutAuthMode mode) {
    emit(
      state.copyWith(
        activeMode: mode,
        clearError: true,
        clearMessage: true,
      ),
    );
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    emit(
      state.copyWith(
        status: AuthStatus.loading,
        email: email.trim(),
        clearError: true,
        clearMessage: true,
      ),
    );

    final result = await authRepository.login(
      email: email.trim(),
      password: password,
    );

    result.fold(
      (failure) {
        if (failure is AccountPendingFailure) {
          emit(
            state.copyWith(
              status: AuthStatus.otpRequired,
              activeMode: CheckoutAuthMode.verifyOtp,
              email: email.trim(),
              pendingPassword: password,
              message: failure.friendlyMessage,
            ),
          );
        } else {
          emit(
            state.copyWith(
              status: AuthStatus.failure,
              errorMessage: failure.friendlyMessage,
            ),
          );
        }
      },
      (customer) {
        emit(
          state.copyWith(
            status: AuthStatus.authenticated,
            customer: customer,
            email: customer.email,
            clearError: true,
            clearMessage: true,
          ),
        );
      },
    );
  }

  Future<void> signUp({
    required String name,
    required String phone,
    String? secondaryPhone,
    required String email,
    required String password,
    required String governorate,
    String? city,
    required String address,
  }) async {
    emit(
      state.copyWith(
        status: AuthStatus.loading,
        email: email.trim(),
        clearError: true,
        clearMessage: true,
      ),
    );

    final result = await authRepository.signUp(
      name: name.trim(),
      phone: phone.trim(),
      secondaryPhone: secondaryPhone,
      email: email.trim(),
      password: password,
      governorate: governorate.trim(),
      city: city,
      address: address.trim(),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: AuthStatus.failure,
          errorMessage: failure.friendlyMessage,
        ),
      ),
      (successMsg) => emit(
        state.copyWith(
          status: AuthStatus.otpRequired,
          activeMode: CheckoutAuthMode.verifyOtp,
          email: email.trim(),
          pendingPassword: password,
          message: successMsg,
        ),
      ),
    );
  }

  Future<void> verifyOtp({required String otp}) async {
    if (otp.trim().isEmpty) {
      emit(
        state.copyWith(
          status: AuthStatus.failure,
          errorMessage: 'يرجى إدخال رمز التحقق',
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        status: AuthStatus.loading,
        clearError: true,
        clearMessage: true,
      ),
    );

    final result = await authRepository.verifyOtp(
      email: state.email,
      otp: otp.trim(),
    );

    Failure? failure;
    result.fold((f) => failure = f, (_) {});

    if (failure != null) {
      emit(
        state.copyWith(
          status: AuthStatus.failure,
          errorMessage: failure!.friendlyMessage,
        ),
      );
      return;
    }

    // If we have saved credentials from signup or pending login, auto-login seamlessly!
    if (state.pendingPassword != null && state.pendingPassword!.isNotEmpty) {
      await login(email: state.email, password: state.pendingPassword!);
    } else {
      emit(
        state.copyWith(
          status: AuthStatus.unauthenticated,
          activeMode: CheckoutAuthMode.login,
          message: 'تم التحقق من الرمز بنجاح! يمكنك الآن تسجيل الدخول',
        ),
      );
    }
  }

  Future<void> resendOtp() async {
    if (state.email.isEmpty) return;

    final result = await authRepository.resendOtp(email: state.email);
    result.fold(
      (failure) => emit(
        state.copyWith(
          errorMessage: failure.friendlyMessage,
        ),
      ),
      (msg) => emit(
        state.copyWith(
          message: 'تم إرسال كود جديد إلى بريدك الإلكتروني',
        ),
      ),
    );
  }

  Future<void> forgotPassword({required String email}) async {
    if (email.trim().isEmpty) {
      emit(
        state.copyWith(
          status: AuthStatus.failure,
          errorMessage: 'يرجى كتابة البريد الإلكتروني',
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        status: AuthStatus.loading,
        email: email.trim(),
        clearError: true,
        clearMessage: true,
      ),
    );

    final result = await authRepository.forgotPassword(email: email.trim());

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: AuthStatus.failure,
          errorMessage: failure.friendlyMessage,
        ),
      ),
      (msg) => emit(
        state.copyWith(
          status: AuthStatus.forgotPasswordSent,
          activeMode: CheckoutAuthMode.resetPassword,
          email: email.trim(),
          message: 'تم إرسال رمز استعادة كلمة المرور إلى بريدك',
        ),
      ),
    );
  }

  Future<void> resetPassword({
    required String otp,
    required String newPassword,
  }) async {
    if (otp.trim().isEmpty || newPassword.trim().isEmpty) {
      emit(
        state.copyWith(
          status: AuthStatus.failure,
          errorMessage: 'يرجى إدخال رمز التحقق وكلمة المرور الجديدة',
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        status: AuthStatus.loading,
        clearError: true,
        clearMessage: true,
      ),
    );

    final result = await authRepository.resetPassword(
      email: state.email,
      otp: otp.trim(),
      newPassword: newPassword,
    );

    Failure? failure;
    result.fold((f) => failure = f, (_) {});

    if (failure != null) {
      emit(
        state.copyWith(
          status: AuthStatus.failure,
          errorMessage: failure!.friendlyMessage,
        ),
      );
      return;
    }

    // Automatically login with the new password
    await login(email: state.email, password: newPassword);
  }

  Future<void> logout() async {
    await authRepository.logout();
    emit(
      const AuthState(
        status: AuthStatus.unauthenticated,
        customer: null,
        activeMode: CheckoutAuthMode.login,
      ),
    );
  }
}
