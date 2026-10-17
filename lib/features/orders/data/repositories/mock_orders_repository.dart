import 'dart:math';

import 'package:dartz/dartz.dart' hide Order;
import 'package:warsha_commerce/core/config/mock_debug_state.dart';
import 'package:warsha_commerce/core/error/failures.dart';
import 'package:warsha_commerce/features/orders/domain/entities/order.dart';
import 'package:warsha_commerce/features/orders/domain/entities/order_item.dart';
import 'package:warsha_commerce/features/orders/domain/entities/order_status.dart';
import 'package:warsha_commerce/features/orders/domain/entities/order_tracking_event.dart';
import 'package:warsha_commerce/features/orders/domain/repositories/orders_repository.dart';
import 'package:warsha_commerce/features/profile/data/repositories/mock_profile_repository.dart';

class MockOrdersRepository implements OrdersRepository {
  final MockDebugController _debugController;
  final Random _random = Random();

  MockOrdersRepository({MockDebugController? debugController})
    : _debugController = debugController ?? MockDebugController.instance;

  Future<void> _simulateLatency() async {
    final ms = 300 + _random.nextInt(300); // 300-600 ms
    await Future.delayed(Duration(milliseconds: ms));
  }

  static final List<Order> mockOrders = [
    // Order #10248: Shipped with 3 items and tracking events
    Order(
      orderId: 10248,
      orderNumber: '#10248',
      orderDate: DateTime(2026, 9, 28, 14, 30),
      status: OrderStatus.shipped,
      subtotal: 145000, // 1,450.00 EGP
      deliveryFee: 8000, // 80.00 EGP
      discount: 0,
      totalPrice: 153000, // 1,530.00 EGP
      downPayment: 0,
      paymentMethod: 'الدفع عند الاستلام (Cash on Delivery)',
      shippingAddress: MockProfileRepository.defaultAddress,
      items: const [
        OrderItem(
          productId: 1,
          productName: 'خاتم الزمرد الملكي',
          quantity: 1,
          unitPrice: 45000,
          totalPrice: 45000,
          imageUrl: null,
        ),
        OrderItem(
          productId: 2,
          productName: 'سوار اللؤلؤ الراقي',
          quantity: 1,
          unitPrice: 65000,
          totalPrice: 65000,
          imageUrl: 'https://images.unsplash.com/photo-1611591475819-797de1a72638?w=500',
        ),
        OrderItem(
          productId: 3,
          productName: 'خاتم الزهور المرصع',
          quantity: 1,
          unitPrice: 35000,
          totalPrice: 35000,
          imageUrl: 'https://images.unsplash.com/photo-1605100804763-247f67b3557e?w=500',
        ),
      ],
      trackingEvents: [
        OrderTrackingEvent(
          status: OrderStatus.placed,
          title: 'تم استلام الطلب بنجاح',
          description: 'تم تسجيل طلبك في النظام وجاري مراجعته',
          timestamp: DateTime(2026, 9, 28, 14, 30),
          isCompleted: true,
        ),
        OrderTrackingEvent(
          status: OrderStatus.confirmed,
          title: 'تم تأكيد الطلب',
          description: 'تم التحقق من بيانات التوصيل وتأكيد الطلب',
          timestamp: DateTime(2026, 9, 28, 15, 10),
          isCompleted: true,
        ),
        OrderTrackingEvent(
          status: OrderStatus.packed,
          title: 'تم تجهيز وتغليف الطلب',
          description: 'تم تغليف إكسسواراتك في علبة هدايا الورشة الفاخرة',
          timestamp: DateTime(2026, 9, 29, 10, 00),
          isCompleted: true,
        ),
        OrderTrackingEvent(
          status: OrderStatus.shipped,
          title: 'الطلب في الطريق مع مندوب الشحن',
          description: 'خرجت الشحنة مع شركة التوصيل للتسليم اليوم',
          timestamp: DateTime(2026, 9, 30, 09, 15),
          isCompleted: true,
        ),
        OrderTrackingEvent(
          status: OrderStatus.delivered,
          title: 'تم التوصيل للعميل',
          description: 'في انتظار تسليم الشحنة وتأكيد الاستلام',
          timestamp: DateTime(2026, 10, 1, 18, 00),
          isCompleted: false,
        ),
      ],
    ),

    // Order #10231: Delivered
    Order(
      orderId: 10231,
      orderNumber: '#10231',
      orderDate: DateTime(2026, 9, 15, 11, 20),
      status: OrderStatus.delivered,
      subtotal: 170000, // 1,700.00 EGP
      deliveryFee: 8000, // 80.00 EGP
      discount: 0,
      totalPrice: 178000, // 1,780.00 EGP
      downPayment: 0,
      paymentMethod: 'انستاباي (Instapay)',
      shippingAddress: MockProfileRepository.defaultAddress,
      items: const [
        OrderItem(
          productId: 6,
          productName: 'طقم الأميرة الماسي',
          quantity: 1,
          unitPrice: 170000,
          totalPrice: 170000,
          imageUrl: 'https://images.unsplash.com/photo-1535632066927-ab7c9ab60908?w=500',
        ),
      ],
      trackingEvents: [
        OrderTrackingEvent(
          status: OrderStatus.placed,
          title: 'تم استلام الطلب',
          description: 'تم تسجيل الطلب',
          timestamp: DateTime(2026, 9, 15, 11, 20),
          isCompleted: true,
        ),
        OrderTrackingEvent(
          status: OrderStatus.delivered,
          title: 'تم التوصيل بنجاح',
          description: 'تم استلام الشحنة وتأكيد الدفع',
          timestamp: DateTime(2026, 9, 17, 16, 45),
          isCompleted: true,
        ),
      ],
    ),

    // Order #10207: Cancelled
    Order(
      orderId: 10207,
      orderNumber: '#10207',
      orderDate: DateTime(2026, 9, 5, 18, 00),
      status: OrderStatus.cancelled,
      subtotal: 140000, // 1,400.00 EGP
      deliveryFee: 8000, // 80.00 EGP
      discount: 0,
      totalPrice: 148000, // 1,480.00 EGP
      downPayment: 0,
      paymentMethod: 'الدفع عند الاستلام',
      shippingAddress: MockProfileRepository.defaultAddress,
      items: const [
        OrderItem(
          productId: 11,
          productName: 'طقم النجوم المسائية',
          quantity: 1,
          unitPrice: 140000,
          totalPrice: 140000,
          imageUrl: 'https://images.unsplash.com/photo-1611591475819-797de1a72638?w=500',
        ),
      ],
      trackingEvents: [
        OrderTrackingEvent(
          status: OrderStatus.placed,
          title: 'تم استلام الطلب',
          description: 'تم تسجيل الطلب',
          timestamp: DateTime(2026, 9, 5, 18, 00),
          isCompleted: true,
        ),
        OrderTrackingEvent(
          status: OrderStatus.cancelled,
          title: 'تم إلغاء الطلب',
          description: 'تم إلغاء الطلب بناءً على رغبة العميل',
          timestamp: DateTime(2026, 9, 6, 10, 15),
          isCompleted: true,
        ),
      ],
    ),
  ];

  @override
  Future<Either<Failure, List<Order>>> getCustomerOrders() async {
    await _simulateLatency();

    switch (_debugController.state) {
      case MockRepoState.error:
        return const Left(ServerFailure('Failed to load orders'));
      case MockRepoState.empty:
        return const Right([]);
      case MockRepoState.loading:
        await Future.delayed(const Duration(seconds: 10));
        return const Right([]);
      case MockRepoState.normal:
        return Right(mockOrders);
    }
  }

  @override
  Future<Either<Failure, Order>> getOrderById(int orderId) async {
    await _simulateLatency();

    switch (_debugController.state) {
      case MockRepoState.error:
        return const Left(ServerFailure('Failed to load order'));
      case MockRepoState.empty:
      case MockRepoState.loading:
      case MockRepoState.normal:
        try {
          final order = mockOrders.firstWhere((o) => o.orderId == orderId);
          return Right(order);
        } catch (_) {
          return const Left(ServerFailure('Order not found'));
        }
    }
  }
}
