import 'package:equatable/equatable.dart';

class HomeBanner extends Equatable {
  final String id;
  final String eyebrow;
  final String eyebrowAr;
  final String title;
  final String titleAr;
  final String subtitle;
  final String subtitleAr;
  final String buttonText;
  final String buttonTextAr;
  final String buttonLink;
  final String? imageUrl;

  const HomeBanner({
    required this.id,
    required this.eyebrow,
    required this.eyebrowAr,
    required this.title,
    required this.titleAr,
    required this.subtitle,
    required this.subtitleAr,
    required this.buttonText,
    required this.buttonTextAr,
    required this.buttonLink,
    this.imageUrl,
  });

  String getEyebrow(bool isArabic) => isArabic ? eyebrowAr : eyebrow;
  String getTitle(bool isArabic) => isArabic ? titleAr : title;
  String getSubtitle(bool isArabic) => isArabic ? subtitleAr : subtitle;
  String getButtonText(bool isArabic) => isArabic ? buttonTextAr : buttonText;

  @override
  List<Object?> get props => [
    id,
    eyebrow,
    eyebrowAr,
    title,
    titleAr,
    subtitle,
    subtitleAr,
    buttonText,
    buttonTextAr,
    buttonLink,
    imageUrl,
  ];
}
