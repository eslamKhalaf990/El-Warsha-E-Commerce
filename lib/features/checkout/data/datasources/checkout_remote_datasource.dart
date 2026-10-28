import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:warsha_commerce/core/network/api_constants.dart';
import 'package:warsha_commerce/core/network/dio_client.dart';
import 'package:warsha_commerce/features/checkout/domain/entities/checkout_order_params.dart';
import 'package:warsha_commerce/features/orders/data/models/order_model.dart';

abstract class CheckoutRemoteDataSource {
  Future<OrderModel> placeOrder(CheckoutOrderParams params);
}

class CheckoutRemoteDataSourceImpl implements CheckoutRemoteDataSource {
  final DioClient client;

  CheckoutRemoteDataSourceImpl({required this.client});

  @override
  Future<OrderModel> placeOrder(CheckoutOrderParams params) async {
    // Map product images for fallback if backend OrderResponse omits them
    final productImages = <int, String?>{
      for (final item in params.cartItems)
        item.product.id: item.product.imageUrl,
    };

    // Construct the backend order JSON according to Warsha API specs
    final orderJson = {
      'bankAccountId': 1, // ASSUMPTION: default bank account id 1 per guide
      'paymentMethod': params.paymentMethod,
      'orderSource': 'Website', // ASSUMPTION: Storefront web channel
      'notes': params.notes?.trim() ?? '',
      'downPayment': params.downPayment / 100.0,
      'items': [
        for (final item in params.cartItems)
          {
            'productId': item.product.id,
            if (item.variantId != null) 'variantId': item.variantId,
            'quantity': item.quantity,
          },
      ],
    };

    final formDataMap = <String, dynamic>{
      'order': MultipartFile.fromString(
        jsonEncode(orderJson),
        contentType: DioMediaType('application', 'json'),
      ),
    };

    if (params.depositReceipt != null) {
      final receipt = params.depositReceipt!;
      final isPng = receipt.fileName.toLowerCase().endsWith('.png');
      formDataMap['images'] = MultipartFile.fromBytes(
        receipt.bytes,
        filename: receipt.fileName,
        contentType: DioMediaType('image', isPng ? 'png' : 'jpeg'),
      );
    }

    final formData = FormData.fromMap(formDataMap);

    final response = await client.dio.post(
      ApiConstants.placeOrder,
      data: formData,
    );

    final data = response.data;

    if (data is Map<String, dynamic>) {
      return OrderModel.fromJson(
        data,
        fallbackAddress: params.shippingAddress,
        fallbackPaymentMethod: params.paymentMethod,
        productImages: productImages,
      );
    } else if (data is num) {
      final generatedMap = <String, dynamic>{
        'orderId': data.toInt(),
        'orderDate': DateTime.now().toIso8601String(),
        'status': 'PLACED',
        'orderSource': 'Website',
        'discount': params.discount / 100.0,
        'delivery': params.deliveryFee / 100.0,
        'totalPrice': params.total / 100.0,
        'downPayment': params.downPayment / 100.0,
        'paymentMethod': params.paymentMethod,
      };
      return OrderModel.fromJson(
        generatedMap,
        fallbackAddress: params.shippingAddress,
        fallbackPaymentMethod: params.paymentMethod,
        productImages: productImages,
      );
    } else if (data is String) {
      try {
        final decoded = jsonDecode(data);
        if (decoded is Map<String, dynamic>) {
          return OrderModel.fromJson(
            decoded,
            fallbackAddress: params.shippingAddress,
            fallbackPaymentMethod: params.paymentMethod,
            productImages: productImages,
          );
        }
      } catch (_) {
        // Plain text response, extract digits or use current time
        final match = RegExp(r'\d+').firstMatch(data);
        final orderId = match != null
            ? int.parse(match.group(0)!)
            : DateTime.now().millisecondsSinceEpoch % 100000;
        final generatedMap = <String, dynamic>{
          'orderId': orderId,
          'orderDate': DateTime.now().toIso8601String(),
          'status': 'PLACED',
          'orderSource': 'Website',
          'discount': params.discount / 100.0,
          'delivery': params.deliveryFee / 100.0,
          'totalPrice': params.total / 100.0,
          'downPayment': params.downPayment / 100.0,
          'paymentMethod': params.paymentMethod,
        };
        return OrderModel.fromJson(
          generatedMap,
          fallbackAddress: params.shippingAddress,
          fallbackPaymentMethod: params.paymentMethod,
          productImages: productImages,
        );
      }
    }

    throw const FormatException(
      'Unexpected response format from placeOrder API',
    );
  }
}
