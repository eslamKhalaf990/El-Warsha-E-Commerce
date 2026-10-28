import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:warsha_commerce/features/catalog/domain/entities/product.dart';
import 'package:warsha_commerce/features/product_details/presentation/widgets/product_gallery_view.dart';

Product _product({String? cover, List<String> images = const []}) => Product(
      id: 1,
      name: 'Tote',
      description: '',
      sellingPrice: 100,
      discount: 0,
      totalPrice: 100,
      imageUrl: cover,
      sku: '',
      quantity: 3,
      categoryName: '',
      categoryId: 1,
      images: images,
    );

Future<void> _pump(WidgetTester tester, Product product) => tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(width: 360, child: SingleChildScrollView(child: ProductGalleryView(product: product))),
        ),
      ),
    );

/// Runs page animations to the end. pumpAndSettle can't be used: the image
/// placeholder's loading spinner never stops in tests.
Future<void> _settle(WidgetTester tester) async {
  for (var i = 0; i < 30; i++) {
    await tester.pump(const Duration(milliseconds: 50));
  }
}

void main() {
  testWidgets('a single image shows no dots or thumbnails', (tester) async {
    await _pump(tester, _product(cover: '/images/a.jpg'));
    expect(find.byType(PageView), findsOneWidget);
    expect(find.bySemanticsLabel(RegExp(r'^Image \d of')), findsNothing);
  });

  testWidgets('several images can be swiped and picked from thumbnails', (tester) async {
    await _pump(tester, _product(cover: '/images/a.jpg', images: ['/images/b.jpg', '/images/c.jpg']));
    expect(find.bySemanticsLabel(RegExp(r'^Image \d of 3')), findsNWidgets(3));

    PageController controller() => tester.widget<PageView>(find.byType(PageView)).controller!;

    await tester.drag(find.byType(PageView), const Offset(-300, 0));
    await _settle(tester);
    expect(controller().page, 1);

    await tester.tap(find.bySemanticsLabel(RegExp(r'^Image 3 of 3')));
    await _settle(tester);
    expect(controller().page, 2);
  });
}
