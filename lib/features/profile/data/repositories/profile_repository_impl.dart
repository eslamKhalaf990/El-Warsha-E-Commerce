import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:warsha_commerce/core/error/failures.dart';
import 'package:warsha_commerce/features/profile/domain/entities/address.dart';
import 'package:warsha_commerce/features/profile/domain/entities/customer.dart';
import 'package:warsha_commerce/features/profile/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final SharedPreferences sharedPreferences;
  static const String customerProfileKey = 'saved_customer_profile';

  ProfileRepositoryImpl({required this.sharedPreferences});

  @override
  Future<Either<Failure, Customer>> getCustomerProfile() async {
    final rawJson = sharedPreferences.getString(customerProfileKey);
    if (rawJson != null && rawJson.trim().isNotEmpty) {
      try {
        final map = jsonDecode(rawJson) as Map<String, dynamic>;
        final address = Address(
          fullName: (map['fullName'] ?? '').toString(),
          phone: (map['phone'] ?? '').toString(),
          secondaryPhone: map['secondaryPhone']?.toString(),
          governorate: (map['governorate'] ?? 'القاهرة').toString(),
          city: (map['city'] ?? '').toString(),
          addressLine: (map['address'] ?? map['addressLine'] ?? '').toString(),
        );

        final customer = Customer(
          id: (map['id'] as num?)?.toInt() ?? 0,
          fullName: (map['fullName'] ?? '').toString(),
          email: (map['email'] ?? '').toString(),
          phone: (map['phone'] ?? '').toString(),
          secondaryPhone: map['secondaryPhone']?.toString(),
          governorate: (map['governorate'] ?? 'القاهرة').toString(),
          city: (map['city'] ?? '').toString(),
          address: (map['address'] ?? map['addressLine'] ?? '').toString(),
          defaultAddress: address,
        );
        return Right(customer);
      } catch (_) {
        // Fall through to failure
      }
    }

    return const Left(ServerFailure('No stored customer profile'));
  }

  Future<void> saveProfile({
    required String fullName,
    required String phone,
    String? secondaryPhone,
    required String governorate,
    required String city,
    required String address,
  }) async {
    final data = {
      'fullName': fullName,
      'phone': phone,
      'secondaryPhone': secondaryPhone,
      'governorate': governorate,
      'city': city,
      'address': address,
    };
    await sharedPreferences.setString(customerProfileKey, jsonEncode(data));
  }

  @override
  Future<void> saveCachedCustomer(Customer customer) async {
    final data = {
      'id': customer.id,
      'fullName': customer.fullName,
      'email': customer.email,
      'phone': customer.phone,
      'secondaryPhone': customer.secondaryPhone,
      'governorate': customer.governorate,
      'city': customer.city,
      'address': customer.address,
    };
    await sharedPreferences.setString(customerProfileKey, jsonEncode(data));
  }

  @override
  Future<Customer?> getCachedCustomer() async {
    final result = await getCustomerProfile();
    return result.fold((_) => null, (customer) => customer);
  }

  @override
  Future<void> clearProfile() async {
    await sharedPreferences.remove(customerProfileKey);
  }
}
