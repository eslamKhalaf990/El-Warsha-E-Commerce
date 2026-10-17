import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:warsha_commerce/features/cart/presentation/pages/cart_page.dart';
import 'package:warsha_commerce/features/catalog/presentation/pages/catalog_page.dart';
import 'package:warsha_commerce/features/checkout/presentation/pages/checkout_page.dart';
import 'package:warsha_commerce/features/checkout/presentation/pages/order_confirmation_page.dart';
import 'package:warsha_commerce/features/dev/gallery_page.dart';
import 'package:warsha_commerce/features/home/presentation/pages/home_page.dart';
import 'package:warsha_commerce/features/orders/domain/entities/order.dart';
import 'package:warsha_commerce/features/product_details/presentation/pages/product_details_page.dart';
import 'package:warsha_commerce/features/profile/presentation/pages/customer_dashboard_page.dart';

class PlaceholderPage extends StatelessWidget {
  final String title;
  const PlaceholderPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(title)),
    body: Center(child: Text(title)),
  );
}

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: '/dev/gallery',
      name: 'gallery',
      builder: (context, state) => const GalleryPage(),
    ),
    GoRoute(
      path: '/shop',
      name: 'shop',
      builder: (context, state) {
        final catStr = state.uri.queryParameters['category'];
        final categoryId = int.tryParse(catStr ?? '');
        final query = state.uri.queryParameters['q'];
        return CatalogPage(initialCategoryId: categoryId, initialQuery: query);
      },
    ),
    GoRoute(
      path: '/products',
      name: 'products',
      builder: (context, state) {
        final catStr = state.uri.queryParameters['category'];
        final categoryId = int.tryParse(catStr ?? '');
        final query = state.uri.queryParameters['q'];
        return CatalogPage(initialCategoryId: categoryId, initialQuery: query);
      },
    ),
    GoRoute(
      path: '/category/:id',
      name: 'category_products',
      builder: (context, state) {
        final idStr = state.pathParameters['id'] ?? '';
        final categoryId = int.tryParse(idStr);
        return CatalogPage(initialCategoryId: categoryId);
      },
    ),
    GoRoute(
      path: '/product/:id',
      name: 'product_details',
      builder: (context, state) {
        final idStr = state.pathParameters['id'] ?? '';
        final id = int.tryParse(idStr) ?? 1;
        return ProductDetailsPage(productId: id);
      },
    ),
    GoRoute(
      path: '/products/:id',
      builder: (context, state) {
        final idStr = state.pathParameters['id'] ?? '';
        final id = int.tryParse(idStr) ?? 1;
        return ProductDetailsPage(productId: id);
      },
    ),
    GoRoute(
      path: '/cart',
      name: 'cart',
      builder: (context, state) => const CartPage(),
    ),
    GoRoute(
      path: '/checkout',
      name: 'checkout',
      builder: (context, state) => const CheckoutPage(),
    ),
    GoRoute(
      path: '/order-confirmation',
      name: 'order-confirmation',
      builder: (context, state) {
        final order = state.extra as Order?;
        return OrderConfirmationPage(order: order);
      },
    ),
    GoRoute(
      path: '/wishlist',
      builder: (context, state) => const PlaceholderPage(title: 'Wishlist'),
    ),
    GoRoute(
      path: '/account',
      name: 'account',
      builder: (context, state) =>
          const CustomerDashboardPage(initialTabIndex: 0),
    ),
    GoRoute(
      path: '/orders',
      name: 'orders',
      builder: (context, state) =>
          const CustomerDashboardPage(initialTabIndex: 1),
    ),
    GoRoute(
      path: '/my-reviews',
      name: 'my-reviews',
      builder: (context, state) =>
          const CustomerDashboardPage(initialTabIndex: 0),
    ),
  ],
);
