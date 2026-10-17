import 'dart:math';

import 'package:dartz/dartz.dart';
import 'package:warsha_commerce/core/config/mock_debug_state.dart';
import 'package:warsha_commerce/core/error/failures.dart';
import 'package:warsha_commerce/features/profile/domain/entities/address.dart';
import 'package:warsha_commerce/features/profile/domain/entities/customer.dart';
import 'package:warsha_commerce/features/profile/domain/repositories/profile_repository.dart';

class MockProfileRepository implements ProfileRepository {
  final MockDebugController _debugController;
  final Random _random = Random();

  MockProfileRepository({MockDebugController? debugController})
    : _debugController = debugController ?? MockDebugController.instance;

  Future<void> _simulateLatency() async {
    final ms = 300 + _random.nextInt(300); // 300-600 ms
    await Future.delayed(Duration(milliseconds: ms));
  }

  static const defaultAddress = Address(
    id: 1,
    fullName: 'سارة أحمد',
    phone: '01012345678',
    secondaryPhone: '01223456789',
    governorate: 'القاهرة',
    city: 'المعادي',
    addressLine: 'شارع 9، المعادي، عمارة 45',
    isDefault: true,
  );

  static const defaultCustomer = Customer(
    id: 101,
    fullName: 'سارة أحمد',
    email: 'sara.ahmed@example.com',
    phone: '01012345678',
    secondaryPhone: '01223456789',
    governorate: 'القاهرة',
    city: 'المعادي',
    address: 'شارع 9، المعادي، عمارة 45',
    defaultAddress: defaultAddress,
  );

  Customer? _cachedCustomer = defaultCustomer;

  @override
  Future<Either<Failure, Customer>> getCustomerProfile() async {
    await _simulateLatency();

    switch (_debugController.state) {
      case MockRepoState.error:
        return const Left(ServerFailure('Failed to load profile'));
      case MockRepoState.empty:
      case MockRepoState.loading:
      case MockRepoState.normal:
        return Right(_cachedCustomer ?? defaultCustomer);
    }
  }

  @override
  Future<void> saveCachedCustomer(Customer customer) async {
    _cachedCustomer = customer;
  }

  @override
  Future<Customer?> getCachedCustomer() async {
    return _cachedCustomer;
  }

  @override
  Future<void> clearProfile() async {
    _cachedCustomer = null;
  }
}
