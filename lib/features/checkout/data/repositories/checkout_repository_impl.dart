import 'package:dartz/dartz.dart' hide Order;
import 'package:dio/dio.dart';
import 'package:warsha_commerce/core/error/api_error_mapper.dart';
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
        Governorates.getPrice(governorate) ??
        0;
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
          final freshVariant = freshProduct.variantById(item.variantId);
          if (item.variantId != null && freshVariant == null) {
            return OutOfStockFailure(
              'المقاس/اللون اللي اخترته من "${item.product.nameFor('ar')}" مبقاش متاح. شيله من السلة واختار تاني',
            );
          }
          final stock = freshVariant?.quantity ?? freshProduct.quantity;
          if (stock > 0 && stock < item.quantity) {
            return OutOfStockFailure(
              'الكمية المطلوبة من "${item.product.nameFor('ar')}" غير متوفرة حالياً (المتوفر: $stock)',
            );
          }
          final freshPrice = freshVariant?.totalPrice ?? freshProduct.totalPrice;
          if (freshPrice != item.unitPrice) {
            return OutOfStockFailure(
              'تغير سعر المنتج "${item.product.nameFor('ar')}". يرجى مراجعة السلة لتحديث الأسعار',
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
      return Left(failureFromDio(e, fallback: 'فشل الاتصال بالخادم لتأكيد الطلب'));
    } catch (e) {
      return Left(ServerFailure('حدث خطأ أثناء تأكيد الطلب: ${e.toString()}'));
    }
  }

}
