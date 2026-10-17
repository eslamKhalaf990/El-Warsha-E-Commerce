import 'package:dartz/dartz.dart' hide Order;
import 'package:dio/dio.dart';
import 'package:warsha_commerce/core/error/failures.dart';
import 'package:warsha_commerce/core/utils/governorates.dart';
import 'package:warsha_commerce/features/catalog/domain/repositories/catalog_repository.dart';
import 'package:warsha_commerce/features/checkout/data/datasources/checkout_remote_datasource.dart';
import 'package:warsha_commerce/features/checkout/domain/entities/checkout_order_params.dart';
import 'package:warsha_commerce/features/checkout/domain/repositories/checkout_repository.dart';
import 'package:warsha_commerce/features/orders/domain/entities/order.dart';
import 'package:warsha_commerce/features/shipping/domain/repositories/shipping_repository.dart';

class CheckoutRepositoryImpl implements CheckoutRepository {
  final CheckoutRemoteDataSource remoteDataSource;
  final CatalogRepository catalogRepository;
  final ShippingRepository shippingRepository;

  CheckoutRepositoryImpl({
    required this.remoteDataSource,
    required this.catalogRepository,
    required this.shippingRepository,
  });

  @override
  int calculateDeliveryFee(String governorate) {
    final price = shippingRepository.getCachedPrice(governorate) ??
        Governorates.getPrice(governorate);
    return (price * 100).round();
  }

  @override
  Future<Either<Failure, Order>> placeOrder(CheckoutOrderParams params) async {
    // Step 1: Pre-flight stock and price reconciliation against backend API
    for (final item in params.cartItems) {
      final productResult = await catalogRepository.getProductById(
        item.product.id,
      );

      final reconciliationError = productResult.fold(
        (failure) => null, // If network lookup fails, allow server to validate
        (freshProduct) {
          if (freshProduct.quantity > 0 &&
              freshProduct.quantity < item.quantity) {
            return OutOfStockFailure(
              'الكمية المطلوبة من "${item.product.name}" غير متوفرة حالياً (المتوفر: ${freshProduct.quantity})',
            );
          }
          if (freshProduct.totalPrice != item.product.totalPrice) {
            return OutOfStockFailure(
              'تغير سعر المنتج "${item.product.name}". يرجى مراجعة السلة لتحديث الأسعار',
            );
          }
          return null;
        },
      );

      if (reconciliationError != null) {
        return Left(reconciliationError);
      }
    }

    // Step 2: Submit order to backend API
    try {
      final order = await remoteDataSource.placeOrder(params);
      return Right(order);
    } on DioException catch (e) {
      return Left(_mapDioException(e));
    } catch (e) {
      return Left(ServerFailure('حدث خطأ أثناء تأكيد الطلب: ${e.toString()}'));
    }
  }

  Failure _mapDioException(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout ||
        e.type == DioExceptionType.connectionError) {
      return const NetworkFailure();
    }

    final status = e.response?.statusCode;
    if (status == 401) {
      return const UnauthorizedFailure();
    }
    if (status == 400) {
      final msg = e.response?.data?.toString() ?? 'بيانات الطلب غير صالحة';
      return ValidationFailure(msg);
    }
    if (status == 409 || status == 500) {
      return const OutOfStockFailure(
        'أحد المنتجات غير متوفر حالياً في المخزن أو حدث تعارض في المخزون',
      );
    }

    final data = e.response?.data;
    if (data is Map && data.containsKey('message')) {
      return ServerFailure(data['message'].toString());
    }

    return ServerFailure(e.message ?? 'فشل الاتصال بالخادم لتأكيد الطلب');
  }
}
