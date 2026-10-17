import 'package:equatable/equatable.dart';

class Address extends Equatable {
  final int? id;
  final String fullName;
  final String phone;
  final String? secondaryPhone;
  final String governorate;
  final String city;
  final String addressLine;
  final bool isDefault;

  const Address({
    this.id,
    required this.fullName,
    required this.phone,
    this.secondaryPhone,
    required this.governorate,
    required this.city,
    required this.addressLine,
    this.isDefault = true,
  });

  String get formattedAddress => '$governorate, $city, $addressLine';

  @override
  List<Object?> get props => [
    id,
    fullName,
    phone,
    secondaryPhone,
    governorate,
    city,
    addressLine,
    isDefault,
  ];
}
