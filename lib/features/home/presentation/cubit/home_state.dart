import 'package:equatable/equatable.dart';
import 'package:warsha_commerce/features/catalog/domain/entities/category.dart';
import 'package:warsha_commerce/features/catalog/domain/entities/product.dart';
import 'package:warsha_commerce/features/home/domain/entities/home_banner.dart';

enum ShelfStatus { initial, loading, success, failure }

class HomeState extends Equatable {
  final ShelfStatus bannersStatus;
  final List<HomeBanner> banners;
  final String? bannersError;

  final ShelfStatus categoriesStatus;
  final List<Category> categories;
  final int? selectedCategoryId;
  final String? categoriesError;

  final ShelfStatus newArrivalsStatus;
  final List<Product> newArrivals;
  final String? newArrivalsError;

  final ShelfStatus bestSellersStatus;
  final List<Product> bestSellers;
  final String? bestSellersError;

  const HomeState({
    this.bannersStatus = ShelfStatus.initial,
    this.banners = const [],
    this.bannersError,
    this.categoriesStatus = ShelfStatus.initial,
    this.categories = const [],
    this.selectedCategoryId,
    this.categoriesError,
    this.newArrivalsStatus = ShelfStatus.initial,
    this.newArrivals = const [],
    this.newArrivalsError,
    this.bestSellersStatus = ShelfStatus.initial,
    this.bestSellers = const [],
    this.bestSellersError,
  });

  bool get isLoading =>
      bannersStatus == ShelfStatus.loading &&
      categoriesStatus == ShelfStatus.loading &&
      newArrivalsStatus == ShelfStatus.loading &&
      bestSellersStatus == ShelfStatus.loading;

  bool get hasAnyFailure =>
      bannersStatus == ShelfStatus.failure ||
      categoriesStatus == ShelfStatus.failure ||
      newArrivalsStatus == ShelfStatus.failure ||
      bestSellersStatus == ShelfStatus.failure;

  HomeState copyWith({
    ShelfStatus? bannersStatus,
    List<HomeBanner>? banners,
    String? bannersError,
    bool clearBannersError = false,
    ShelfStatus? categoriesStatus,
    List<Category>? categories,
    int? selectedCategoryId,
    bool clearSelectedCategory = false,
    String? categoriesError,
    bool clearCategoriesError = false,
    ShelfStatus? newArrivalsStatus,
    List<Product>? newArrivals,
    String? newArrivalsError,
    bool clearNewArrivalsError = false,
    ShelfStatus? bestSellersStatus,
    List<Product>? bestSellers,
    String? bestSellersError,
    bool clearBestSellersError = false,
  }) {
    return HomeState(
      bannersStatus: bannersStatus ?? this.bannersStatus,
      banners: banners ?? this.banners,
      bannersError: clearBannersError
          ? null
          : (bannersError ?? this.bannersError),
      categoriesStatus: categoriesStatus ?? this.categoriesStatus,
      categories: categories ?? this.categories,
      selectedCategoryId: clearSelectedCategory
          ? null
          : (selectedCategoryId ?? this.selectedCategoryId),
      categoriesError: clearCategoriesError
          ? null
          : (categoriesError ?? this.categoriesError),
      newArrivalsStatus: newArrivalsStatus ?? this.newArrivalsStatus,
      newArrivals: newArrivals ?? this.newArrivals,
      newArrivalsError: clearNewArrivalsError
          ? null
          : (newArrivalsError ?? this.newArrivalsError),
      bestSellersStatus: bestSellersStatus ?? this.bestSellersStatus,
      bestSellers: bestSellers ?? this.bestSellers,
      bestSellersError: clearBestSellersError
          ? null
          : (bestSellersError ?? this.bestSellersError),
    );
  }

  @override
  List<Object?> get props => [
    bannersStatus,
    banners,
    bannersError,
    categoriesStatus,
    categories,
    selectedCategoryId,
    categoriesError,
    newArrivalsStatus,
    newArrivals,
    newArrivalsError,
    bestSellersStatus,
    bestSellers,
    bestSellersError,
  ];
}
