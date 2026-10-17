import 'package:dio/dio.dart';
import 'package:warsha_commerce/core/network/api_constants.dart';
import 'package:warsha_commerce/core/network/dio_client.dart';

abstract class AuthRemoteDataSource {
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  });

  Future<String> signUp({
    required String name,
    required String phone,
    String? secondaryPhone,
    required String email,
    required String password,
    required String governorate,
    String? city,
    required String address,
  });

  Future<String> verifyOtp({
    required String email,
    required String otp,
  });

  Future<String> resendOtp({
    required String email,
  });

  Future<String> forgotPassword({
    required String email,
  });

  Future<String> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioClient client;

  AuthRemoteDataSourceImpl({required this.client});

  @override
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await client.dio.post(
      ApiConstants.login,
      data: {
        'username': email.trim(),
        'password': password,
      },
    );

    if (response.data is Map<String, dynamic>) {
      return response.data as Map<String, dynamic>;
    }
    return {'raw': response.data.toString()};
  }

  @override
  Future<String> signUp({
    required String name,
    required String phone,
    String? secondaryPhone,
    required String email,
    required String password,
    required String governorate,
    String? city,
    required String address,
  }) async {
    final response = await client.dio.post(
      ApiConstants.signUp,
      data: {
        'fullName': name.trim(),
        'email': email.trim(),
        'password': password,
        'phone': phone.trim(),
        if (secondaryPhone != null && secondaryPhone.trim().isNotEmpty)
          'secondaryPhone': secondaryPhone.trim(),
        'governorate': governorate.trim(),
        if (city != null && city.trim().isNotEmpty) 'city': city.trim(),
        'address': address.trim(),
      },
      options: Options(responseType: ResponseType.plain),
    );

    return response.data?.toString() ?? 'Success';
  }

  @override
  Future<String> verifyOtp({
    required String email,
    required String otp,
  }) async {
    final response = await client.dio.post(
      ApiConstants.verifyOtp,
      data: {
        'email': email.trim(),
        'otp': otp.trim(),
      },
      options: Options(responseType: ResponseType.plain),
    );

    return response.data?.toString() ?? 'Verified';
  }

  @override
  Future<String> resendOtp({
    required String email,
  }) async {
    final response = await client.dio.post(
      ApiConstants.resendOtp,
      queryParameters: {'email': email.trim()},
      options: Options(responseType: ResponseType.plain),
    );

    return response.data?.toString() ?? 'Code resent';
  }

  @override
  Future<String> forgotPassword({
    required String email,
  }) async {
    final response = await client.dio.post(
      ApiConstants.forgotPassword,
      data: {'email': email.trim()},
      options: Options(responseType: ResponseType.plain),
    );

    return response.data?.toString() ?? 'Reset code sent';
  }

  @override
  Future<String> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    final response = await client.dio.post(
      ApiConstants.resetPassword,
      data: {
        'email': email.trim(),
        'otp': otp.trim(),
        'newPassword': newPassword,
      },
      options: Options(responseType: ResponseType.plain),
    );

    return response.data?.toString() ?? 'Password reset successfully';
  }
}
