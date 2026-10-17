import 'package:warsha_commerce/core/utils/image_helper.dart';

class ApiConstants {
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:8080',
  );

  static const String baseURLImages = String.fromEnvironment(
    'BASE_URL_IMAGES',
    defaultValue: 'https://drive.google.com/uc?export=view&id=',
  );

  // Auth endpoints
  static const String signUp = '/customers/customerSignUp';
  static const String verifyOtp = '/auth/verifyCode';
  static const String resendOtp = '/customers/resend-otp';
  static const String login = '/auth/customerLogin';
  static const String forgotPassword = '/auth/forgotPassword';
  static const String resetPassword = '/auth/resetPassword';
  static const String changePassword = '/auth/changePassword';

  // Catalog endpoints
  static const String categories = '/category';
  static const String products = '/products';
  static const String productsByCategory = '/products/getByCategoryId';
  static String productDetails(int id) => '/products/$id';
  static String imageFilename(String filename) =>
      '/products/getImage?filename=$filename';

  // Orders endpoints
  static const String placeOrder = '/orders/placeOrder';
  static const String customerOrders = '/orders/customer';

  // Feedback, Reviews & Comments endpoints
  static const String feedbacks = '/feedbacks';
  static const String publicFeedbacks = '/feedbacks/public';
  static String productFeedbacks(int productId) =>
      '/feedbacks/product/$productId';
  static const String customerFeedbacks = '/feedbacks/customer';
  static String feedbackDetails(int id) => '/feedbacks/$id';
  static String feedbackComments(int id) => '/feedbacks/$id/comments';

  /// Resolves an image URL into a displayable HTTP URL.
  /// If the URL is a Google Drive link, extracts the file ID and prefixes with [baseURLImages].
  /// If the URL is a relative path, prefixes with [baseUrl].
  static String imageUrl(String path) {
    if (path.isEmpty) return path;

    // Check if path is a Google Drive link or contains a file ID
    final fileId = ImageHelper.extractFileId(path);
    if (fileId != null && fileId.isNotEmpty) {
      return '$baseURLImages$fileId';
    }

    if (path.startsWith('http://') || path.startsWith('https://')) {
      return path;
    }
    if (path.startsWith('/')) {
      return '$baseUrl$path';
    }
    return '$baseUrl/$path';
  }
}
