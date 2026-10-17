import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:warsha_commerce/features/catalog/domain/repositories/catalog_repository.dart';
import 'package:warsha_commerce/features/home/domain/repositories/banners_repository.dart';
import 'package:warsha_commerce/features/home/presentation/cubit/home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final BannersRepository bannersRepository;
  final CatalogRepository catalogRepository;

  HomeCubit({required this.bannersRepository, required this.catalogRepository})
    : super(const HomeState());

  Future<void> loadAll() async {
    await Future.wait([
      loadBanners(),
      loadCategories(),
      loadNewArrivals(),
      loadBestSellers(),
    ]);
  }

  Future<void> loadBanners() async {
    emit(
      state.copyWith(
        bannersStatus: ShelfStatus.loading,
        clearBannersError: true,
      ),
    );

    final result = await bannersRepository.getHomeBanners();

    result.fold(
      (failure) => emit(
        state.copyWith(
          bannersStatus: ShelfStatus.failure,
          bannersError: failure.message,
        ),
      ),
      (banners) => emit(
        state.copyWith(
          bannersStatus: ShelfStatus.success,
          banners: banners,
          clearBannersError: true,
        ),
      ),
    );
  }

  Future<void> loadCategories() async {
    emit(
      state.copyWith(
        categoriesStatus: ShelfStatus.loading,
        clearCategoriesError: true,
      ),
    );

    final result = await catalogRepository.getCategories();

    result.fold(
      (failure) => emit(
        state.copyWith(
          categoriesStatus: ShelfStatus.failure,
          categoriesError: failure.message,
        ),
      ),
      (categories) => emit(
        state.copyWith(
          categoriesStatus: ShelfStatus.success,
          categories: categories,
          clearCategoriesError: true,
        ),
      ),
    );
  }

  Future<void> selectCategory(int? categoryId) async {
    if (state.selectedCategoryId == categoryId) return;

    if (categoryId == null) {
      emit(state.copyWith(clearSelectedCategory: true));
    } else {
      emit(state.copyWith(selectedCategoryId: categoryId));
    }

    await loadNewArrivals(categoryId: categoryId);
  }

  Future<void> loadNewArrivals({int? categoryId}) async {
    emit(
      state.copyWith(
        newArrivalsStatus: ShelfStatus.loading,
        clearNewArrivalsError: true,
      ),
    );

    final catId = categoryId ?? state.selectedCategoryId;
    final result = await catalogRepository.getNewArrivals(categoryId: catId);

    result.fold(
      (failure) => emit(
        state.copyWith(
          newArrivalsStatus: ShelfStatus.failure,
          newArrivalsError: failure.message,
        ),
      ),
      (products) => emit(
        state.copyWith(
          newArrivalsStatus: ShelfStatus.success,
          newArrivals: products,
          clearNewArrivalsError: true,
        ),
      ),
    );
  }

  Future<void> loadBestSellers() async {
    emit(
      state.copyWith(
        bestSellersStatus: ShelfStatus.loading,
        clearBestSellersError: true,
      ),
    );

    final result = await catalogRepository.getBestSellers();

    result.fold(
      (failure) => emit(
        state.copyWith(
          bestSellersStatus: ShelfStatus.failure,
          bestSellersError: failure.message,
        ),
      ),
      (products) => emit(
        state.copyWith(
          bestSellersStatus: ShelfStatus.success,
          bestSellers: products,
          clearBestSellersError: true,
        ),
      ),
    );
  }
}
