import 'package:dartz/dartz.dart';
import 'package:warsha_commerce/core/error/failures.dart';
import 'package:warsha_commerce/features/profile/domain/entities/customer.dart';

abstract class AuthRepository {
  Future<Either<Failure, Customer>> login({
    required String email,
    required String password,
  });

  Future<Either<Failure, String>> signUp({
    required String name,
    required String phone,
    String? secondaryPhone,
    required String email,
    required String password,
    required String governorate,
    String? city,
    required String address,
  });

  Future<Either<Failure, String>> verifyOtp({
    required String email,
    required String otp,
  });

  Future<Either<Failure, String>> resendOtp({
    required String email,
  });

  Future<Either<Failure, String>> forgotPassword({
    required String email,
  });

  Future<Either<Failure, String>> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  });

  Future<Customer?> getCurrentUser();

  Future<void> logout();
}
