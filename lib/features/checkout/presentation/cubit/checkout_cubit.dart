import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:warsha_commerce/core/l10n/app_strings.dart';
import 'package:warsha_commerce/features/cart/domain/entities/cart_item.dart';
import 'package:warsha_commerce/features/checkout/domain/entities/checkout_order_params.dart';
import 'package:warsha_commerce/features/checkout/domain/entities/receipt_attachment.dart';
import 'package:warsha_commerce/features/checkout/domain/repositories/checkout_repository.dart';
import 'package:warsha_commerce/features/checkout/presentation/cubit/checkout_state.dart';
import 'package:warsha_commerce/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:warsha_commerce/features/profile/domain/entities/address.dart';
import 'package:warsha_commerce/features/profile/domain/entities/customer.dart';
import 'package:warsha_commerce/features/profile/domain/repositories/profile_repository.dart';

class CheckoutCubit extends Cubit<CheckoutState> {
  final CheckoutRepository checkoutRepository;
  final ProfileRepository profileRepository;

  CheckoutCubit({
    required this.checkoutRepository,
    required this.profileRepository,
  }) : super(const CheckoutState());

  Future<void> initCheckout() async {
    emit(state.copyWith(status: CheckoutStatus.loading));

    final profileResult = await profileRepository.getCustomerProfile();

    profileResult.fold(
      (failure) {
        // Fallback default
        final initialFee = checkoutRepository.calculateDeliveryFee('القاهرة');
        emit(
          state.copyWith(
            status: CheckoutStatus.initial,
            deliveryFee: initialFee,
          ),
        );
      },
      (customer) {
        populateFromCustomer(customer);
      },
    );
  }

  void populateFromCustomer(Customer customer) {
    final gov = customer.governorate.isNotEmpty
        ? customer.governorate
        : 'القاهرة';
    final initialFee = checkoutRepository.calculateDeliveryFee(gov);

    emit(
      state.copyWith(
        status: CheckoutStatus.initial,
        fullName: customer.fullName,
        phone: customer.phone,
        secondaryPhone: customer.secondaryPhone ?? '',
        governorate: gov,
        city: customer.city,
        addressLine: customer.address,
        deliveryFee: initialFee,
        clearError: true,
      ),
    );
  }

  void clearCustomerDetails() {
    emit(
      state.copyWith(
        fullName: '',
        phone: '',
        secondaryPhone: '',
        city: '',
        addressLine: '',
        notes: '',
        clearDownPayment: true,
        clearDepositReceipt: true,
        clearError: true,
      ),
    );
  }

  void updateFullName(String value) {
    emit(state.copyWith(fullName: value, clearError: true));
  }

  void updatePhone(String value) {
    emit(state.copyWith(phone: value, clearError: true));
  }

  void updateSecondaryPhone(String value) {
    emit(state.copyWith(secondaryPhone: value, clearError: true));
  }

  void updateGovernorate(String governorate) {
    final fee = checkoutRepository.calculateDeliveryFee(governorate);
    emit(
      state.copyWith(
        governorate: governorate,
        deliveryFee: fee,
        clearError: true,
      ),
    );
  }

  void updateCity(String value) {
    emit(state.copyWith(city: value, clearError: true));
  }

  void updateAddressLine(String value) {
    emit(state.copyWith(addressLine: value, clearError: true));
  }

  void updateNotes(String value) {
    emit(state.copyWith(notes: value, clearError: true));
  }

  void updatePaymentMethod(String method) {
    emit(state.copyWith(paymentMethod: method, clearError: true));
  }

  void updateDownPayment(int valueMinor) {
    emit(
      state.copyWith(
        downPayment: valueMinor.clamp(0, 999999999),
        clearError: true,
      ),
    );
  }

  void updateDownPaymentFromText(String value) {
    final clean = value.trim().replaceAll(',', '.');
    if (clean.isEmpty) {
      emit(state.copyWith(downPayment: 0, clearError: true));
      return;
    }
    final parsed = double.tryParse(clean);
    if (parsed != null && parsed >= 0) {
      final minor = (parsed * 100).round();
      emit(state.copyWith(downPayment: minor, clearError: true));
    }
  }

  void updateDepositReceipt(ReceiptAttachment? receipt) {
    emit(
      state.copyWith(
        depositReceipt: receipt,
        clearDepositReceipt: receipt == null,
        clearError: true,
      ),
    );
  }

  Future<void> submitOrder({
    required List<CartItem> cartItems,
    required int subtotal,
    required int discount,
  }) async {
    if (state.status == CheckoutStatus.submitting) {
      return; // Prevent double submit
    }

    if (!state.isShippingValid) {
      emit(
        state.copyWith(
          status: CheckoutStatus.failure,
          errorMessage: 'يرجى استكمال جميع بيانات التوصيل الإلزامية',
        ),
      );
      return;
    }

    if (state.downPayment <= 0) {
      emit(
        state.copyWith(
          status: CheckoutStatus.failure,
          errorMessage: AppStrings.downPaymentRequired,
        ),
      );
      return;
    }

    final grandTotal = (subtotal - discount + state.deliveryFee).clamp(
      0,
      999999999,
    );

    if (state.downPayment > grandTotal) {
      emit(
        state.copyWith(
          status: CheckoutStatus.failure,
          errorMessage: AppStrings.downPaymentExceedsTotal,
        ),
      );
      return;
    }

    if (state.depositReceipt == null) {
      emit(
        state.copyWith(
          status: CheckoutStatus.failure,
          errorMessage: AppStrings.depositScreenshotRequired,
        ),
      );
      return;
    }

    if (cartItems.isEmpty) {
      emit(
        state.copyWith(
          status: CheckoutStatus.failure,
          errorMessage: 'حقيبة التسوق فارغة',
        ),
      );
      return;
    }

    emit(state.copyWith(status: CheckoutStatus.submitting, clearError: true));

    final address = Address(
      fullName: state.fullName.trim(),
      phone: state.phone.trim(),
      secondaryPhone: state.secondaryPhone.trim().isEmpty
          ? null
          : state.secondaryPhone.trim(),
      governorate: state.governorate,
      city: state.city.trim(),
      addressLine: state.addressLine.trim(),
    );

    final params = CheckoutOrderParams(
      shippingAddress: address,
      paymentMethod: state.paymentMethod,
      notes: state.notes.trim().isEmpty ? null : state.notes.trim(),
      cartItems: cartItems,
      subtotal: subtotal,
      deliveryFee: state.deliveryFee,
      discount: discount,
      total: grandTotal,
      downPayment: state.downPayment,
      depositReceipt: state.depositReceipt,
    );

    final result = await checkoutRepository.placeOrder(params);

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: CheckoutStatus.failure,
          errorMessage: failure.friendlyMessage,
        ),
      ),
      (order) {
        if (profileRepository is ProfileRepositoryImpl) {
          (profileRepository as ProfileRepositoryImpl).saveProfile(
            fullName: state.fullName.trim(),
            phone: state.phone.trim(),
            secondaryPhone: state.secondaryPhone.trim().isEmpty
                ? null
                : state.secondaryPhone.trim(),
            governorate: state.governorate,
            city: state.city.trim(),
            address: state.addressLine.trim(),
          );
        }
        emit(
          state.copyWith(status: CheckoutStatus.success, placedOrder: order),
        );
      },
    );
  }
}
