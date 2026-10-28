import 'package:flutter_test/flutter_test.dart';
import 'package:warsha_commerce/features/cart/data/models/cart_item_model.dart';
import 'package:warsha_commerce/features/cart/domain/entities/cart_item.dart';
import 'package:warsha_commerce/features/catalog/data/models/product_model.dart';

void main() {
  final json = {
    'id': 5,
    'name': 'Tote bag',
    'nameAr': 'شنطة',
    'description': 'Canvas',
    'descriptionAr': 'قماش',
    'sellingPrice': 300.0,
    'discount': 20.0,
    'totalPrice': 280.0,
    'sku': 'TB',
    'quantity': '7',
    'categoryName': 'Bags',
    'categoryId': 1,
    'variants': [
      {'id': 9, 'size': 'L', 'color': 'Black', 'colorAr': 'أسود', 'price': 350.0, 'totalPrice': 330.0, 'quantity': 3},
      {'id': 10, 'size': 'M', 'price': 300.0, 'totalPrice': 280.0, 'quantity': 4},
    ],
  };

  test('product reads Arabic text and variants in minor units', () {
    final p = ProductModel.fromJson(json);
    expect(p.nameFor('ar'), 'شنطة');
    expect(p.nameFor('en'), 'Tote bag');
    expect(p.descriptionFor('ar'), 'قماش');
    expect(p.hasVariants, isTrue);
    expect(p.variants.first.totalPrice, 33000);
    expect(p.variants.first.labelFor('ar'), 'L / أسود');
    expect(p.variants.last.labelFor('ar'), 'M');
  });

  test('the gallery starts with the cover, then the extra images in order', () {
    final p = ProductModel.fromJson({
      ...json,
      'imageUrl': '/images/cover.jpg',
      'images': [
        {'id': 1, 'imageUrl': '/images/b.jpg', 'sortOrder': 0},
        {'id': 2, 'imageUrl': '/images/c.jpg', 'sortOrder': 1},
      ],
    });
    expect(p.galleryImages, ['/images/cover.jpg', '/images/b.jpg', '/images/c.jpg']);

    final restored = CartItemModel.fromJson(CartItemModel.fromEntity(CartItem(product: p, quantity: 1)).toJson());
    expect(restored.product.images, ['/images/b.jpg', '/images/c.jpg']);
  });

  test('missing Arabic falls back to English', () {
    final p = ProductModel.fromJson({...json, 'nameAr': null, 'descriptionAr': ''});
    expect(p.nameFor('ar'), 'Tote bag');
    expect(p.descriptionFor('ar'), 'Canvas');
  });

  test('a cart row uses its variant price, stock and identity', () {
    final p = ProductModel.fromJson(json);
    final row = CartItem(product: p, quantity: 2, variant: p.variants.first);
    expect(row.unitPrice, 33000);
    expect(row.totalPrice, 66000);
    expect(row.availableStock, 3);
    expect(row.isLine(5, 9), isTrue);
    expect(row.isLine(5, 10), isFalse);
    expect(row.isLine(5, null), isFalse);
  });

  test('cart rows survive local storage with their variant', () {
    final p = ProductModel.fromJson(json);
    final saved = CartItemModel.fromEntity(CartItem(product: p, quantity: 1, variant: p.variants.last)).toJson();
    final restored = CartItemModel.fromJson(saved);
    expect(restored.variantId, 10);
    expect(restored.product.nameAr, 'شنطة');
    expect(restored.unitPrice, 28000);
  });
}
