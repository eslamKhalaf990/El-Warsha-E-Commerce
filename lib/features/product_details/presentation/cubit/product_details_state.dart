import 'package:equatable/equatable.dart';
import 'package:warsha_commerce/features/catalog/domain/entities/product.dart';

enum ProductDetailsStatus { initial, loading, success, failure }

class ProductDetailsState extends Equatable {
  final ProductDetailsStatus status;
  final Product? product;
  final List<Product> relatedProducts;
  final String? errorMessage;

  const ProductDetailsState({
    this.status = ProductDetailsStatus.initial,
    this.product,
    this.relatedProducts = const [],
    this.errorMessage,
  });

  bool get isLoading => status == ProductDetailsStatus.loading;
  bool get isSuccess => status == ProductDetailsStatus.success;
  bool get isFailure => status == ProductDetailsStatus.failure;

  ProductDetailsState copyWith({
    ProductDetailsStatus? status,
    Product? product,
    List<Product>? relatedProducts,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ProductDetailsState(
      status: status ?? this.status,
      product: product ?? this.product,
      relatedProducts: relatedProducts ?? this.relatedProducts,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [status, product, relatedProducts, errorMessage];
}
