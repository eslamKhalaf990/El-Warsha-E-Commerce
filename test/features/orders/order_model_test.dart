import 'package:flutter_test/flutter_test.dart';
import 'package:warsha_commerce/features/orders/data/models/order_model.dart';
import 'package:warsha_commerce/features/orders/domain/entities/order_status.dart';

void main() {
  test('parses a v2 OrderResponse', () {
    final order = OrderModel.fromJson({
      'orderId': 12,
      'status': 'Processing',
      'orderDate': '2026-10-24',
      'discount': 20.0,
      'delivery': 60.0,
      'totalPrice': 240.0,
      'amountDue': 240.0,
      'grandTotal': 440.0,
      'downPayment': 200.0,
      'paymentMethod': 'InstaPay',
      'orderItems': [
        {'productId': 1, 'productName': 'Bracelet', 'quantity': 2, 'unitPrice': 200.0}
      ],
    });

    expect(order.orderId, 12);
    expect(order.status, OrderStatus.confirmed);
    expect(order.totalPrice, 24000); // amount left to pay on delivery, in piastres
    expect(order.downPayment, 20000);
    expect(order.deliveryFee, 6000);
    expect(order.discount, 2000);
  });

  test('maps every backend status', () {
    expect(OrderStatus.fromBackendString('Pending'), OrderStatus.placed);
    expect(OrderStatus.fromBackendString('Processing'), OrderStatus.confirmed);
    expect(OrderStatus.fromBackendString('Shipped'), OrderStatus.shipped);
    expect(OrderStatus.fromBackendString('Completed'), OrderStatus.delivered);
    expect(OrderStatus.fromBackendString('Cancelled'), OrderStatus.cancelled);
  });
}
