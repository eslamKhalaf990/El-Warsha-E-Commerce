import 'package:warsha_commerce/features/orders/data/models/order_item_model.dart';
import 'package:warsha_commerce/features/orders/domain/entities/order.dart';
import 'package:warsha_commerce/features/orders/domain/entities/order_status.dart';
import 'package:warsha_commerce/features/orders/domain/entities/order_tracking_event.dart';
import 'package:warsha_commerce/features/profile/domain/entities/address.dart';

class OrderModel extends Order {
  const OrderModel({
    required super.orderId,
    required super.orderNumber,
    required super.orderDate,
    required super.status,
    required super.items,
    required super.subtotal,
    required super.deliveryFee,
    required super.discount,
    required super.totalPrice,
    super.downPayment = 0,
    required super.paymentMethod,
    super.trackingEvents = const [],
    super.shippingAddress,
  });

  factory OrderModel.fromJson(
    Map<String, dynamic> json, {
    Address? fallbackAddress,
    String? fallbackPaymentMethod,
    Map<int, String?>? productImages,
  }) {
    final id = (json['orderId'] ?? json['id'] ?? 0) as int;
    final orderNum = json['orderNumber']?.toString() ?? '#$id';

    DateTime parsedDate;
    final rawDate = json['orderDate'];
    if (rawDate is String) {
      parsedDate = DateTime.tryParse(rawDate) ?? DateTime.now();
    } else {
      parsedDate = DateTime.now();
    }

    final status = OrderStatus.fromBackendString(
      (json['status'] ?? 'placed').toString(),
    );

    // Order items
    final rawItems = json['orderItems'] ?? json['items'];
    final List<OrderItemModel> itemsList = [];
    if (rawItems is List) {
      for (final itemJson in rawItems) {
        if (itemJson is Map<String, dynamic>) {
          final item = OrderItemModel.fromJson(itemJson);
          final imageUrl = item.imageUrl ?? productImages?[item.productId];
          itemsList.add(
            OrderItemModel(
              productId: item.productId,
              productName: item.productName,
              quantity: item.quantity,
              unitPrice: item.unitPrice,
              totalPrice: item.totalPrice,
              imageUrl: imageUrl,
            ),
          );
        }
      }
    }

    // Money conversions: EGP double -> minor units (piastres = EGP * 100)
    final discountDouble = (json['discount'] as num?)?.toDouble() ?? 0.0;
    final discountMinor = (discountDouble * 100).round();

    final deliveryDouble =
        (json['delivery'] ?? json['deliveryFee'] as num?)?.toDouble() ?? 0.0;
    final deliveryMinor = (deliveryDouble * 100).round();

    final totalPriceDouble =
        (json['totalPrice'] ?? json['total'] as num?)?.toDouble() ?? 0.0;
    final totalPriceMinor = (totalPriceDouble * 100).round();

    final downPaymentDouble = (json['downPayment'] as num?)?.toDouble() ?? 0.0;
    final downPaymentMinor = (downPaymentDouble * 100).round();

    final computedSubtotal = itemsList.fold<int>(
      0,
      (sum, i) => sum + i.totalPrice,
    );
    final finalSubtotal = computedSubtotal > 0
        ? computedSubtotal
        : (totalPriceMinor - deliveryMinor + discountMinor + downPaymentMinor);

    // Customer / shipping address
    Address? address = fallbackAddress;
    final rawCustomer = json['customer'];
    if (rawCustomer is Map<String, dynamic>) {
      address = Address(
        id: (rawCustomer['customerId'] as num?)?.toInt(),
        fullName:
            (rawCustomer['fullName'] ??
                    rawCustomer['name'] ??
                    fallbackAddress?.fullName ??
                    '')
                .toString(),
        phone:
            (rawCustomer['phone'] ?? fallbackAddress?.phone ?? '').toString(),
        secondaryPhone:
            rawCustomer['secondaryPhone']?.toString() ??
            fallbackAddress?.secondaryPhone,
        governorate:
            (rawCustomer['governorate'] ??
                    fallbackAddress?.governorate ??
                    '')
                .toString(),
        city: (rawCustomer['city'] ?? fallbackAddress?.city ?? '').toString(),
        addressLine:
            (rawCustomer['address'] ??
                    rawCustomer['addressLine'] ??
                    fallbackAddress?.addressLine ??
                    '')
                .toString(),
      );
    }

    final trackingEvents = [
      OrderTrackingEvent(
        status: status,
        title: status.labelAr,
        description: 'تم تسجيل طلبك بنجاح وجاري مراجعته وتجهيزه.',
        timestamp: parsedDate,
        isCompleted: true,
      ),
    ];

    final paymentMethod =
        json['paymentMethod']?.toString() ??
        fallbackPaymentMethod ??
        'Cash on Delivery';

    return OrderModel(
      orderId: id,
      orderNumber: orderNum,
      orderDate: parsedDate,
      status: status,
      items: itemsList,
      subtotal: finalSubtotal,
      deliveryFee: deliveryMinor,
      discount: discountMinor,
      totalPrice: totalPriceMinor,
      downPayment: downPaymentMinor,
      paymentMethod: paymentMethod,
      trackingEvents: trackingEvents,
      shippingAddress: address,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'orderNumber': orderNumber,
      'orderDate': orderDate.toIso8601String(),
      'status': status.toBackendString(),
      'items': items
          .map(
            (i) =>
                (i is OrderItemModel
                        ? i
                        : OrderItemModel(
                            productId: i.productId,
                            productName: i.productName,
                            quantity: i.quantity,
                            unitPrice: i.unitPrice,
                            totalPrice: i.totalPrice,
                            imageUrl: i.imageUrl,
                          ))
                    .toJson(),
          )
          .toList(),
      'subtotal': subtotal / 100.0,
      'deliveryFee': deliveryFee / 100.0,
      'discount': discount / 100.0,
      'totalPrice': totalPrice / 100.0,
      'downPayment': downPayment / 100.0,
      'paymentMethod': paymentMethod,
    };
  }
}
