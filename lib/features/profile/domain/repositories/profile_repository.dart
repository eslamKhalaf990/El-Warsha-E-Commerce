import 'package:dartz/dartz.dart';
import 'package:warsha_commerce/core/error/failures.dart';
import 'package:warsha_commerce/features/profile/domain/entities/customer.dart';

abstract class ProfileRepository {
  Future<Either<Failure, Customer>> getCustomerProfile();
  Future<void> saveCachedCustomer(Customer customer);
  Future<Customer?> getCachedCustomer();
  Future<void> clearProfile();
}
