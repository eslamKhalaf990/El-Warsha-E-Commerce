import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:warsha_commerce/core/network/api_constants.dart';

class DioClient {
  final Dio dio;
  final SharedPreferences sharedPreferences;
  static const String tokenKey = 'auth_token';

  DioClient({required this.dio, required this.sharedPreferences}) {
    dio.options = BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = sharedPreferences.getString(tokenKey);
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) {
          return handler.next(e);
        },
      ),
    );
  }
}
