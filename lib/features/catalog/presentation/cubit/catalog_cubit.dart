import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:warsha_commerce/features/catalog/domain/entities/category.dart';
import 'package:warsha_commerce/features/catalog/domain/entities/product.dart';
import 'package:warsha_commerce/features/catalog/domain/repositories/catalog_repository.dart';
import 'package:warsha_commerce/features/catalog/presentation/cubit/catalog_state.dart';

class CatalogCubit extends Cubit<CatalogState> {
  final CatalogRepository catalogRepository;
  Timer? _debounceTimer;

  CatalogCubit({required this.catalogRepository}) : super(const CatalogState());

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    return super.close();
  }

  Future<void> loadCatalog({
    int? initialCategoryId,
    String? initialQuery,
  }) async {
    emit(
      state.copyWith(
        status: CatalogStatus.loading,
        selectedCategoryId: initialCategoryId,
        searchQuery: initialQuery ?? '',
        clearError: true,
      ),
    );

    final categoriesResult = await catalogRepository.getCategories();
    final productsResult = await catalogRepository.getProducts();

    List<Category> categories = [];
    categoriesResult.fold((_) => null, (cats) => categories = cats);

    productsResult.fold(
      (failure) {
        emit(
          state.copyWith(
            status: CatalogStatus.failure,
            categories: categories,
            errorMessage: failure.friendlyMessage,
          ),
        );
      },
      (products) {
        final filtered = _filterAndSort(
          products: products,
          categoryId: initialCategoryId,
          query: initialQuery ?? '',
          sortOption: state.sortOption,
        );

        emit(
          state.copyWith(
            status: CatalogStatus.success,
            allProducts: products,
            displayedProducts: filtered,
            categories: categories,
            selectedCategoryId: initialCategoryId,
            searchQuery: initialQuery ?? '',
            clearError: true,
          ),
        );
      },
    );
  }

  void selectCategory(int? categoryId) {
    if (state.selectedCategoryId == categoryId) return;

    final filtered = _filterAndSort(
      products: state.allProducts,
      categoryId: categoryId,
      query: state.searchQuery,
      sortOption: state.sortOption,
    );

    if (categoryId == null) {
      emit(
        state.copyWith(
          clearSelectedCategory: true,
          displayedProducts: filtered,
        ),
      );
    } else {
      emit(
        state.copyWith(
          selectedCategoryId: categoryId,
          displayedProducts: filtered,
        ),
      );
    }
  }

  void onSearchChanged(String query) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 350), () {
      final filtered = _filterAndSort(
        products: state.allProducts,
        categoryId: state.selectedCategoryId,
        query: query,
        sortOption: state.sortOption,
      );

      emit(state.copyWith(searchQuery: query, displayedProducts: filtered));
    });
  }

  void setSortOption(CatalogSortOption sortOption) {
    if (state.sortOption == sortOption) return;

    final filtered = _filterAndSort(
      products: state.allProducts,
      categoryId: state.selectedCategoryId,
      query: state.searchQuery,
      sortOption: sortOption,
    );

    emit(state.copyWith(sortOption: sortOption, displayedProducts: filtered));
  }

  void clearFilters() {
    final filtered = _filterAndSort(
      products: state.allProducts,
      categoryId: null,
      query: '',
      sortOption: CatalogSortOption.newest,
    );

    emit(
      state.copyWith(
        clearSelectedCategory: true,
        searchQuery: '',
        sortOption: CatalogSortOption.newest,
        displayedProducts: filtered,
      ),
    );
  }

  List<Product> _filterAndSort({
    required List<Product> products,
    required int? categoryId,
    required String query,
    required CatalogSortOption sortOption,
  }) {
    var result = List<Product>.from(products);

    // Filter by Category
    if (categoryId != null) {
      result = result.where((p) => p.categoryId == categoryId).toList();
    }

    // Filter by Search Query (debounced search across name, description, SKU, categoryName)
    final cleanQuery = query.trim().toLowerCase();
    if (cleanQuery.isNotEmpty) {
      result = result.where((p) {
        final nameMatch = p.name.toLowerCase().contains(cleanQuery);
        final descMatch = p.description.toLowerCase().contains(cleanQuery);
        final skuMatch = p.sku.toLowerCase().contains(cleanQuery);
        final catMatch = p.categoryName.toLowerCase().contains(cleanQuery);
        return nameMatch || descMatch || skuMatch || catMatch;
      }).toList();
    }

    // Sort products
    switch (sortOption) {
      case CatalogSortOption.newest:
        // ASSUMPTION: Higher id = newer product
        result.sort((a, b) => b.id.compareTo(a.id));
        break;
      case CatalogSortOption.priceLowToHigh:
        result.sort((a, b) => a.totalPrice.compareTo(b.totalPrice));
        break;
      case CatalogSortOption.priceHighToLow:
        result.sort((a, b) => b.totalPrice.compareTo(a.totalPrice));
        break;
      case CatalogSortOption.discount:
        result.sort((a, b) => b.discount.compareTo(a.discount));
        break;
    }

    return result;
  }
}
