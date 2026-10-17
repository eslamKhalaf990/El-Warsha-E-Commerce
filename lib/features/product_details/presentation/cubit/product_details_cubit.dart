import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:warsha_commerce/features/catalog/domain/entities/product.dart';
import 'package:warsha_commerce/features/catalog/domain/repositories/catalog_repository.dart';
import 'package:warsha_commerce/features/product_details/presentation/cubit/product_details_state.dart';

class ProductDetailsCubit extends Cubit<ProductDetailsState> {
  final CatalogRepository catalogRepository;

  ProductDetailsCubit({required this.catalogRepository})
    : super(const ProductDetailsState());

  Future<void> loadProduct(int id) async {
    emit(
      state.copyWith(status: ProductDetailsStatus.loading, clearError: true),
    );

    final productResult = await catalogRepository.getProductById(id);

    await productResult.fold(
      (failure) async {
        emit(
          state.copyWith(
            status: ProductDetailsStatus.failure,
            errorMessage: failure.message,
          ),
        );
      },
      (product) async {
        // Fetch related products from same category
        final categoryResult = await catalogRepository.getProducts(
          categoryId: product.categoryId,
        );

        List<Product> related = [];
        categoryResult.fold((_) {}, (items) {
          related = items.where((p) => p.id != product.id).toList();
        });

        // If fewer than 4 related items, supplement with best sellers
        if (related.length < 4) {
          final bestSellersResult = await catalogRepository.getBestSellers();
          bestSellersResult.fold((_) {}, (bestSellers) {
            for (final item in bestSellers) {
              if (item.id != product.id &&
                  !related.any((r) => r.id == item.id)) {
                related.add(item);
              }
              if (related.length >= 6) break;
            }
          });
        }

        emit(
          state.copyWith(
            status: ProductDetailsStatus.success,
            product: product,
            relatedProducts: related,
            clearError: true,
          ),
        );
      },
    );
  }
}
