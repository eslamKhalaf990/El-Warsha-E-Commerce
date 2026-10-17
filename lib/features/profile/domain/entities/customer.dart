import 'package:equatable/equatable.dart';
import 'package:warsha_commerce/features/profile/domain/entities/address.dart';

class Customer extends Equatable {
  final int id;
  final String fullName;
  final String email;
  final String phone;
  final String? secondaryPhone;
  final String governorate;
  final String city;
  final String address;
  final Address? defaultAddress;

  const Customer({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    this.secondaryPhone,
    required this.governorate,
    required this.city,
    required this.address,
    this.defaultAddress,
  });

  @override
  List<Object?> get props => [
    id,
    fullName,
    email,
    phone,
    secondaryPhone,
    governorate,
    city,
    address,
    defaultAddress,
  ];
}
