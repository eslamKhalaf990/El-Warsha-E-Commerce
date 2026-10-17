import 'package:dartz/dartz.dart';
import 'package:warsha_commerce/core/error/failures.dart';
import 'package:warsha_commerce/features/catalog/domain/repositories/catalog_repository.dart';
import 'package:warsha_commerce/features/home/domain/entities/home_banner.dart';
import 'package:warsha_commerce/features/home/domain/repositories/banners_repository.dart';

class BannersRepositoryImpl implements BannersRepository {
  final CatalogRepository catalogRepository;

  BannersRepositoryImpl({required this.catalogRepository});

  static const List<HomeBanner> _fallbackBanners = [
    HomeBanner(
      id: 'banner_fallback_1',
      eyebrow: 'Exclusive Collection',
      eyebrowAr: 'تشكيلة حصرية',
      title: 'إبداعات إكسسوارات الورشة',
      titleAr: 'إبداعات إكسسوارات الورشة',
      subtitle: 'صياغة يدوية استثنائية صُممت لتضيء أبهى لحظاتك.',
      subtitleAr: 'صياغة يدوية استثنائية صُممت لتضيء أبهى لحظاتك.',
      buttonText: 'تسوقي التشكيلة',
      buttonTextAr: 'تسوقي التشكيلة',
      buttonLink: '/shop',
      imageUrl:
          'https://images.unsplash.com/photo-1515562141207-7a88fb7ce338?w=800',
    ),
    HomeBanner(
      id: 'banner_fallback_2',
      eyebrow: 'Authentic Charm',
      eyebrowAr: 'سحر أصيل',
      title: 'مجموعة الزمرد واللؤلؤ الملكي',
      titleAr: 'مجموعة الزمرد واللؤلؤ الملكي',
      subtitle: 'أحجار كريمة نادرة مصوغة بلمسات عصرية من الذهب عيار 18.',
      subtitleAr: 'أحجار كريمة نادرة مصوغة بلمسات عصرية من الذهب عيار 18.',
      buttonText: 'تسوقي الإكسسوارات',
      buttonTextAr: 'تسوقي الإكسسوارات',
      buttonLink: '/shop',
      imageUrl:
          'https://images.unsplash.com/photo-1599643478518-a784e5dc4c8f?w=800',
    ),
  ];

  @override
  Future<Either<Failure, List<HomeBanner>>> getHomeBanners() async {
    final productsResult = await catalogRepository.getProducts();

    return productsResult.fold(
      (failure) {
        // If the backend products call fails, provide graceful fallback banners so hero stays intact
        return const Right(_fallbackBanners);
      },
      (products) {
        if (products.isEmpty) {
          return const Right(_fallbackBanners);
        }

        // Section 7: Hero carousel featured/discounted products (highest discount first)
        final discounted = products.where((p) => p.discount > 0).toList();
        discounted.sort((a, b) => b.discount.compareTo(a.discount));

        final heroProducts = (discounted.isNotEmpty ? discounted : products)
            .take(3)
            .toList();

        final dynamicBanners = heroProducts.map((p) {
          final isSale = p.discount > 0;
          return HomeBanner(
            id: 'product_hero_${p.id}',
            eyebrow: isSale ? 'Special Offer' : 'Exclusive Piece',
            eyebrowAr: isSale ? 'عرض خاص' : 'قطعة حصرية',
            title: p.name,
            titleAr: p.name,
            subtitle: p.description.trim().isNotEmpty
                ? p.description
                : 'صياغة يدوية استثنائية صُممت لتضيء أبهى لحظاتك.',
            subtitleAr: p.description.trim().isNotEmpty
                ? p.description
                : 'صياغة يدوية استثنائية صُممت لتضيء أبهى لحظاتك.',
            buttonText: 'اكتشفي القطعة',
            buttonTextAr: 'اكتشفي القطعة',
            buttonLink: '/product/${p.id}',
            imageUrl: p.imageUrl,
          );
        }).toList();

        return Right(dynamicBanners);
      },
    );
  }
}
