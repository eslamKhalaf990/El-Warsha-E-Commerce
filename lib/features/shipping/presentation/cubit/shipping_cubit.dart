import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:warsha_commerce/features/shipping/data/models/governorate_model.dart';
import 'package:warsha_commerce/features/shipping/domain/repositories/shipping_repository.dart';
import 'package:warsha_commerce/features/shipping/presentation/cubit/shipping_state.dart';

class ShippingCubit extends Cubit<ShippingState> {
  final ShippingRepository shippingRepository;

  ShippingCubit({required this.shippingRepository})
      : super(const ShippingState());

  Future<void> loadGovernorates() async {
    if (state.isSuccess && state.governorates.isNotEmpty) {
      return;
    }

    emit(state.copyWith(status: ShippingStatus.loading));

    final result = await shippingRepository.getGovernorates();

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: ShippingStatus.failure,
            errorMessage: failure.friendlyMessage,
          ),
        );
      },
      (list) {
        final map = <String, double>{
          for (final item in list) item.governorate: item.price,
        };
        emit(
          state.copyWith(
            status: ShippingStatus.success,
            governorates: list,
            governoratesMap: map,
          ),
        );
      },
    );
  }

  Future<double> fetchPriceForGovernorate(String governorate) async {
    if (state.governoratesMap.containsKey(governorate)) {
      return state.governoratesMap[governorate]!;
    }
    final result = await shippingRepository.getGovernoratePrice(governorate);
    return result.fold(
      (_) => 80.0,
      (price) => price,
    );
  }
}
