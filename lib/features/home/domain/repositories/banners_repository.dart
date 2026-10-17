import 'package:dartz/dartz.dart';
import 'package:warsha_commerce/core/error/failures.dart';
import 'package:warsha_commerce/features/home/domain/entities/home_banner.dart';

abstract class BannersRepository {
  Future<Either<Failure, List<HomeBanner>>> getHomeBanners();
}
