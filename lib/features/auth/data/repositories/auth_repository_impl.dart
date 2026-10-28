import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:warsha_commerce/core/error/failures.dart';
import 'package:warsha_commerce/core/l10n/app_strings.dart';
import 'package:warsha_commerce/core/network/dio_client.dart';
import 'package:warsha_commerce/features/auth/data/auth_error_mapper.dart';
import 'package:warsha_commerce/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:warsha_commerce/features/auth/domain/repositories/auth_repository.dart';
import 'package:warsha_commerce/features/profile/domain/entities/address.dart';
import 'package:warsha_commerce/features/profile/domain/entities/customer.dart';
import 'package:warsha_commerce/features/profile/domain/repositories/profile_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final SharedPreferences sharedPreferences;
  final ProfileRepository profileRepository;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.sharedPreferences,
    required this.profileRepository,
  });

  @override
  Future<Either<Failure, Customer>> login({
    required String email,
    required String password,
  }) async {
    try {
      final data = await remoteDataSource.login(
        email: email,
        password: password,
      );

      final token = data['token'] as String?;
      if (token != null && token.isNotEmpty) {
        await sharedPreferences.setString(DioClient.tokenKey, token);
      }

      final customer = Customer(
        id: 0,
        fullName: (data['name'] as String?) ?? '',
        email: (data['email'] as String?) ?? email,
        phone: (data['phone'] as String?) ?? '',
        governorate: (data['governorate'] as String?) ?? 'القاهرة',
        city: (data['city'] as String?) ?? '',
        address: (data['address'] as String?) ?? '',
        defaultAddress: Address(
          fullName: (data['name'] as String?) ?? '',
          phone: (data['phone'] as String?) ?? '',
          governorate: (data['governorate'] as String?) ?? 'القاهرة',
          city: (data['city'] as String?) ?? '',
          addressLine: (data['address'] as String?) ?? '',
        ),
      );

      await profileRepository.saveCachedCustomer(customer);

      return Right(customer);
    } on DioException catch (e) {
      return Left(authFailureFromDio(e, AuthAction.login, email: email));
    } catch (_) {
      return const Left(ServerFailure(AppStrings.loadingError));
    }
  }

  @override
  Future<Either<Failure, String>> signUp({
    required String name,
    required String phone,
    String? secondaryPhone,
    required String email,
    required String password,
    required String governorate,
    String? city,
    required String address,
  }) async {
    try {
      final msg = await remoteDataSource.signUp(
        name: name,
        phone: phone,
        secondaryPhone: secondaryPhone,
        email: email,
        password: password,
        governorate: governorate,
        city: city,
        address: address,
      );
      return Right(msg);
    } on DioException catch (e) {
      return Left(authFailureFromDio(e, AuthAction.signUp));
    } catch (_) {
      return const Left(ServerFailure(AppStrings.loadingError));
    }
  }

  @override
  Future<Either<Failure, String>> verifyOtp({
    required String email,
    required String otp,
  }) async {
    try {
      final msg = await remoteDataSource.verifyOtp(email: email, otp: otp);
      return Right(msg);
    } on DioException catch (e) {
      return Left(authFailureFromDio(e, AuthAction.verifyOtp));
    } catch (_) {
      return const Left(ServerFailure(AppStrings.loadingError));
    }
  }

  @override
  Future<Either<Failure, String>> resendOtp({required String email}) async {
    try {
      final msg = await remoteDataSource.resendOtp(email: email);
      return Right(msg);
    } on DioException catch (e) {
      return Left(authFailureFromDio(e, AuthAction.resendOtp));
    } catch (_) {
      return const Left(ServerFailure(AppStrings.loadingError));
    }
  }

  @override
  Future<Either<Failure, String>> forgotPassword({required String email}) async {
    try {
      final msg = await remoteDataSource.forgotPassword(email: email);
      return Right(msg);
    } on DioException catch (e) {
      return Left(authFailureFromDio(e, AuthAction.forgotPassword));
    } catch (_) {
      return const Left(ServerFailure(AppStrings.loadingError));
    }
  }

  @override
  Future<Either<Failure, String>> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    try {
      final msg = await remoteDataSource.resetPassword(
        email: email,
        otp: otp,
        newPassword: newPassword,
      );
      return Right(msg);
    } on DioException catch (e) {
      return Left(authFailureFromDio(e, AuthAction.resetPassword));
    } catch (_) {
      return const Left(ServerFailure(AppStrings.loadingError));
    }
  }

  @override
  Future<Customer?> getCurrentUser() async {
    final token = sharedPreferences.getString(DioClient.tokenKey);
    if (token == null || token.isEmpty) {
      return null;
    }
    return profileRepository.getCachedCustomer();
  }

  @override
  Future<void> logout() async {
    await sharedPreferences.remove(DioClient.tokenKey);
    await profileRepository.clearProfile();
  }
}
