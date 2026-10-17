import 'package:dartz/dartz.dart';
import 'package:warsha_commerce/core/error/failures.dart';
import 'package:warsha_commerce/core/network/dio_client.dart';
import 'package:warsha_commerce/features/auth/domain/repositories/auth_repository.dart';
import 'package:warsha_commerce/features/profile/domain/entities/address.dart';
import 'package:warsha_commerce/features/profile/domain/entities/customer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockAuthRepository implements AuthRepository {
  final SharedPreferences sharedPreferences;

  Customer? _currentUser = const Customer(
    id: 1,
    fullName: 'سارة أحمد',
    email: 'sara@example.com',
    phone: '01012345678',
    governorate: 'القاهرة',
    city: 'المعادي',
    address: 'شارع 9، عمارة 12، شقة 4',
    defaultAddress: Address(
      fullName: 'سارة أحمد',
      phone: '01012345678',
      governorate: 'القاهرة',
      city: 'المعادي',
      addressLine: 'شارع 9، عمارة 12، شقة 4',
    ),
  );

  MockAuthRepository({required this.sharedPreferences});

  @override
  Future<Either<Failure, Customer>> login({
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));

    if (email.contains('pending')) {
      return Left(AccountPendingFailure('الحساب في انتظار تأكيد الرمز', email));
    }

    if (password == 'wrong') {
      return const Left(AuthFailure('البريد الإلكتروني أو كلمة المرور غير صحيحة'));
    }

    await sharedPreferences.setString(DioClient.tokenKey, 'mock_token_abc123');
    return Right(_currentUser!);
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
    await Future.delayed(const Duration(milliseconds: 600));

    if (email.contains('error')) {
      return const Left(ValidationFailure('البريد الإلكتروني مسجل مسبقاً'));
    }

    _currentUser = Customer(
      id: 99,
      fullName: name,
      email: email,
      phone: phone,
      secondaryPhone: secondaryPhone,
      governorate: governorate,
      city: city ?? '',
      address: address,
      defaultAddress: Address(
        fullName: name,
        phone: phone,
        secondaryPhone: secondaryPhone,
        governorate: governorate,
        city: city ?? '',
        addressLine: address,
      ),
    );

    return const Right('تم إنشاء الحساب بنجاح. تم إرسال كود التحقق إلى بريدك الإلكتروني.');
  }

  @override
  Future<Either<Failure, String>> verifyOtp({
    required String email,
    required String otp,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));

    if (otp != '123456') {
      return const Left(ValidationFailure('رمز التحقق غير صحيح أو منتهي الصلاحية'));
    }

    return const Right('تم تأكيد الحساب بنجاح.');
  }

  @override
  Future<Either<Failure, String>> resendOtp({required String email}) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return const Right('تم إرسال كود جديد إلى بريدك الإلكتروني');
  }

  @override
  Future<Either<Failure, String>> forgotPassword({required String email}) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return const Right('تم إرسال كود استعادة كلمة المرور');
  }

  @override
  Future<Either<Failure, String>> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));
    if (otp != '123456') {
      return const Left(ValidationFailure('رمز التحقق غير صحيح'));
    }
    return const Right('تم إعادة تعيين كلمة المرور بنجاح');
  }

  @override
  Future<Customer?> getCurrentUser() async {
    final token = sharedPreferences.getString(DioClient.tokenKey);
    if (token == null) return null;
    return _currentUser;
  }

  @override
  Future<void> logout() async {
    await sharedPreferences.remove(DioClient.tokenKey);
  }
}
