import 'package:equatable/equatable.dart';
import 'package:warsha_commerce/features/orders/domain/entities/order_status.dart';

class OrderTrackingEvent extends Equatable {
  final OrderStatus status;
  final String title;
  final String description;
  final DateTime timestamp;
  final bool isCompleted;

  const OrderTrackingEvent({
    required this.status,
    required this.title,
    required this.description,
    required this.timestamp,
    required this.isCompleted,
  });

  @override
  List<Object?> get props => [
    status,
    title,
    description,
    timestamp,
    isCompleted,
  ];
}
