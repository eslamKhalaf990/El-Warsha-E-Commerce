import 'dart:math';

import 'package:dartz/dartz.dart';
import 'package:warsha_commerce/core/config/mock_debug_state.dart';
import 'package:warsha_commerce/core/error/failures.dart';
import 'package:warsha_commerce/features/home/domain/entities/home_banner.dart';
import 'package:warsha_commerce/features/home/domain/repositories/banners_repository.dart';

class MockBannersRepository implements BannersRepository {
  final MockDebugController _debugController;
  final Random _random = Random();

  MockBannersRepository({MockDebugController? debugController})
    : _debugController = debugController ?? MockDebugController.instance;

  Future<void> _simulateLatency() async {
    final ms = 300 + _random.nextInt(300); // 300-600 ms
    await Future.delayed(Duration(milliseconds: ms));
  }

  static const List<HomeBanner> banners = [
    HomeBanner(
      id: 'banner_1',
      eyebrow: 'تشكيلة حصرية',
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
      id: 'banner_2',
      eyebrow: 'سحر أصيل',
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
    HomeBanner(
      id: 'banner_3',
      eyebrow: 'هدايا استثنائية',
      eyebrowAr: 'هدايا استثنائية',
      title: 'لحظات من البهجة الخالصة',
      titleAr: 'لحظات من البهجة الخالصة',
      subtitle: 'تغليف هدايا فاخر متضمن مجاناً مع كل طلب من الورشة.',
      subtitleAr: 'تغليف هدايا فاخر متضمن مجاناً مع كل طلب من الورشة.',
      buttonText: 'شاهدي تشكيلة الهدايا',
      buttonTextAr: 'شاهدي تشكيلة الهدايا',
      buttonLink: '/shop',
      imageUrl:
          'https://images.unsplash.com/photo-1535632066927-ab7c9ab60908?w=800',
    ),
  ];

  @override
  Future<Either<Failure, List<HomeBanner>>> getHomeBanners() async {
    await _simulateLatency();

    switch (_debugController.state) {
      case MockRepoState.error:
        return const Left(ServerFailure('Failed to load home banners'));
      case MockRepoState.empty:
        return const Right([]);
      case MockRepoState.loading:
        await Future.delayed(const Duration(seconds: 10));
        return const Right([]);
      case MockRepoState.normal:
        return const Right(banners);
    }
  }
}
