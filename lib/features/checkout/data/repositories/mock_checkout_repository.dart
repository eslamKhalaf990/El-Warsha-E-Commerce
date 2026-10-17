import 'dart:math';

import 'package:dartz/dartz.dart' hide Order;
import 'package:warsha_commerce/core/config/mock_debug_state.dart';
import 'package:warsha_commerce/core/error/failures.dart';
import 'package:warsha_commerce/core/utils/governorates.dart';
import 'package:warsha_commerce/features/checkout/domain/entities/checkout_order_params.dart';
import 'package:warsha_commerce/features/checkout/domain/repositories/checkout_repository.dart';
import 'package:warsha_commerce/features/orders/data/repositories/mock_orders_repository.dart';
import 'package:warsha_commerce/features/orders/domain/entities/order.dart';
import 'package:warsha_commerce/features/orders/domain/entities/order_item.dart';
import 'package:warsha_commerce/features/orders/domain/entities/order_status.dart';
import 'package:warsha_commerce/features/orders/domain/entities/order_tracking_event.dart';

class MockCheckoutRepository implements CheckoutRepository {
  final MockDebugController _debugController;
  final Random _random = Random();
  static int _orderCounter = 10250;

  MockCheckoutRepository({MockDebugController? debugController})
    : _debugController = debugController ?? MockDebugController.instance;

  Future<void> _simulateLatency() async {
    final ms = 400 + _random.nextInt(400); // 400-800 ms
    await Future.delayed(Duration(milliseconds: ms));
  }

  @override
  int calculateDeliveryFee(String governorate) {
    // Delivery fees in Governorates map are in EGP major units
    // Convert to minor units (piastres = fee * 100)
    final feeMajor = Governorates.deliveryFees[governorate] ?? 80;
    return feeMajor * 100;
  }

  @override
  Future<Either<Failure, Order>> placeOrder(CheckoutOrderParams params) async {
    await _simulateLatency();

    switch (_debugController.state) {
      case MockRepoState.error:
        return const Left(
          ServerFailure('عذراً، فشل تأكيد الطلب. يرجى المحاولة مرة أخرى'),
        );
      case MockRepoState.empty:
      case MockRepoState.loading:
      case MockRepoState.normal:
        final orderId = _orderCounter++;
        final now = DateTime.now();

        final orderItems = params.cartItems.map((cartItem) {
          return OrderItem(
            productId: cartItem.product.id,
            productName: cartItem.product.name,
            quantity: cartItem.quantity,
            unitPrice: cartItem.product.totalPrice,
            totalPrice: cartItem.totalPrice,
            imageUrl: cartItem.product.imageUrl,
          );
        }).toList();

        final newOrder = Order(
          orderId: orderId,
          orderNumber: '#$orderId',
          orderDate: now,
          status: OrderStatus.placed,
          subtotal: params.subtotal,
          deliveryFee: params.deliveryFee,
          discount: params.discount,
          totalPrice: params.total,
          downPayment: params.downPayment,
          paymentMethod: params.paymentMethod,
          shippingAddress: params.shippingAddress,
          items: orderItems,
          trackingEvents: [
            OrderTrackingEvent(
              status: OrderStatus.placed,
              title: 'تم استلام الطلب بنجاح',
              description:
                  'تم تسجيل طلبك وجاري مراجعته وتجهيزه للصياغة والتغليف.',
              timestamp: now,
              isCompleted: true,
            ),
          ],
        );

        // Prepend to mock orders list so it appears instantly in order history!
        MockOrdersRepository.mockOrders.insert(0, newOrder);

        return Right(newOrder);
    }
  }
}
