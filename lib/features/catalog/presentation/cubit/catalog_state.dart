import 'package:equatable/equatable.dart';
import 'package:warsha_commerce/features/catalog/domain/entities/category.dart';
import 'package:warsha_commerce/features/catalog/domain/entities/product.dart';

enum CatalogStatus { initial, loading, success, failure }

enum CatalogSortOption { newest, priceLowToHigh, priceHighToLow, discount }

class CatalogState extends Equatable {
  final CatalogStatus status;
  final List<Product> allProducts;
  final List<Product> displayedProducts;
  final List<Category> categories;
  final int? selectedCategoryId;
  final String searchQuery;
  final CatalogSortOption sortOption;
  final String? errorMessage;

  const CatalogState({
    this.status = CatalogStatus.initial,
    this.allProducts = const [],
    this.displayedProducts = const [],
    this.categories = const [],
    this.selectedCategoryId,
    this.searchQuery = '',
    this.sortOption = CatalogSortOption.newest,
    this.errorMessage,
  });

  bool get isLoading => status == CatalogStatus.loading;
  bool get isSuccess => status == CatalogStatus.success;
  bool get isFailure => status == CatalogStatus.failure;
  bool get isEmpty => isSuccess && displayedProducts.isEmpty;

  CatalogState copyWith({
    CatalogStatus? status,
    List<Product>? allProducts,
    List<Product>? displayedProducts,
    List<Category>? categories,
    int? selectedCategoryId,
    bool clearSelectedCategory = false,
    String? searchQuery,
    CatalogSortOption? sortOption,
    String? errorMessage,
    bool clearError = false,
  }) {
    return CatalogState(
      status: status ?? this.status,
      allProducts: allProducts ?? this.allProducts,
      displayedProducts: displayedProducts ?? this.displayedProducts,
      categories: categories ?? this.categories,
      selectedCategoryId: clearSelectedCategory
          ? null
          : (selectedCategoryId ?? this.selectedCategoryId),
      searchQuery: searchQuery ?? this.searchQuery,
      sortOption: sortOption ?? this.sortOption,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [
    status,
    allProducts,
    displayedProducts,
    categories,
    selectedCategoryId,
    searchQuery,
    sortOption,
    errorMessage,
  ];
}
