import 'package:equatable/equatable.dart';
import 'package:warsha_commerce/features/checkout/domain/entities/receipt_attachment.dart';
import 'package:warsha_commerce/features/orders/domain/entities/order.dart';

enum CheckoutStatus { initial, loading, submitting, success, failure }

class CheckoutState extends Equatable {
  final CheckoutStatus status;
  final String fullName;
  final String phone;
  final String secondaryPhone;
  final String governorate;
  final String city;
  final String addressLine;
  final String notes;
  final String paymentMethod;
  final int deliveryFee;
  final int downPayment;
  final ReceiptAttachment? depositReceipt;
  final Order? placedOrder;
  final String? errorMessage;

  const CheckoutState({
    this.status = CheckoutStatus.initial,
    this.fullName = '',
    this.phone = '',
    this.secondaryPhone = '',
    this.governorate = 'القاهرة',
    this.city = '',
    this.addressLine = '',
    this.notes = '',
    this.paymentMethod = 'Instapay',
    this.deliveryFee = 0, // set from the live price list
    this.downPayment = 0,
    this.depositReceipt,
    this.placedOrder,
    this.errorMessage,
  });

  bool get isShippingValid =>
      fullName.trim().isNotEmpty &&
      phone.trim().isNotEmpty &&
      governorate.trim().isNotEmpty &&
      city.trim().isNotEmpty &&
      addressLine.trim().isNotEmpty;

  bool get isValid => isShippingValid && depositReceipt != null && downPayment > 0;

  CheckoutState copyWith({
    CheckoutStatus? status,
    String? fullName,
    String? phone,
    String? secondaryPhone,
    String? governorate,
    String? city,
    String? addressLine,
    String? notes,
    String? paymentMethod,
    int? deliveryFee,
    int? downPayment,
    bool clearDownPayment = false,
    ReceiptAttachment? depositReceipt,
    bool clearDepositReceipt = false,
    Order? placedOrder,
    String? errorMessage,
    bool clearError = false,
  }) {
    return CheckoutState(
      status: status ?? this.status,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      secondaryPhone: secondaryPhone ?? this.secondaryPhone,
      governorate: governorate ?? this.governorate,
      city: city ?? this.city,
      addressLine: addressLine ?? this.addressLine,
      notes: notes ?? this.notes,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      downPayment: clearDownPayment ? 0 : (downPayment ?? this.downPayment),
      depositReceipt: clearDepositReceipt
          ? null
          : (depositReceipt ?? this.depositReceipt),
      placedOrder: placedOrder ?? this.placedOrder,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [
    status,
    fullName,
    phone,
    secondaryPhone,
    governorate,
    city,
    addressLine,
    notes,
    paymentMethod,
    deliveryFee,
    downPayment,
    depositReceipt,
    placedOrder,
    errorMessage,
  ];
}
