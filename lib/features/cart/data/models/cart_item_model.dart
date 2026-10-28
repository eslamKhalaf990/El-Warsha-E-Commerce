import 'package:warsha_commerce/features/cart/domain/entities/cart_item.dart';
import 'package:warsha_commerce/features/catalog/data/models/product_model.dart';

class CartItemModel extends CartItem {
  const CartItemModel({required super.product, required super.quantity, super.variant});

  factory CartItemModel.fromEntity(CartItem entity) {
    return CartItemModel(product: entity.product, quantity: entity.quantity, variant: entity.variant);
  }

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    final productJson = json['product'] as Map<String, dynamic>;
    final product = ProductModel.fromJson(productJson);
    final quantity = (json['quantity'] as num?)?.toInt() ?? 1;

    final variantId = (json['variantId'] as num?)?.toInt();

    return CartItemModel(
      product: product,
      quantity: quantity,
      variant: product.variantById(variantId),
    );
  }

  Map<String, dynamic> toJson() {
    final productModel = product is ProductModel
        ? product as ProductModel
        : ProductModel(
            id: product.id,
            name: product.name,
            description: product.description,
            nameAr: product.nameAr,
            descriptionAr: product.descriptionAr,
            buyingPrice: product.buyingPrice,
            sellingPrice: product.sellingPrice,
            discount: product.discount,
            totalPrice: product.totalPrice,
            imageUrl: product.imageUrl,
            sku: product.sku,
            quantity: product.quantity,
            categoryName: product.categoryName,
            categoryId: product.categoryId,
            variants: product.variants,
            images: product.images,
          );

    return {
      'quantity': quantity,
      if (variantId != null) 'variantId': variantId,
      'product': productModel.toJson(),
    };
  }
}
