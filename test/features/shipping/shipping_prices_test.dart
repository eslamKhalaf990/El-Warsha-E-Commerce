import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:warsha_commerce/features/shipping/data/datasources/shipping_remote_datasource.dart';
import 'package:warsha_commerce/features/shipping/data/models/governorate_model.dart';
import 'package:warsha_commerce/features/shipping/data/repositories/shipping_repository_impl.dart';
import 'package:warsha_commerce/features/shipping/presentation/cubit/shipping_state.dart';

/// Stands in for the backend's /governorates, whose prices the admin edits in the ERP.
class _FakeServer implements ShippingRemoteDataSource {
  Map<String, double> prices = {'القاهرة': 80, 'الإسكندرية': 90};
  bool down = false;

  @override
  Future<List<GovernorateModel>> getGovernorates() async {
    if (down) throw DioException(requestOptions: RequestOptions(path: '/governorates'));
    return prices.entries.map((e) => GovernorateModel(governorate: e.key, price: e.value)).toList();
  }

  @override
  Future<Map<String, double>> getGovernoratesMap() async => Map.of(prices);

  @override
  Future<GovernorateModel> getGovernoratePrice(String governorate) async =>
      GovernorateModel(governorate: governorate, price: prices[governorate]!);
}

void main() {
  test('a price changed in the ERP shows up after a refresh', () async {
    final server = _FakeServer();
    final repo = ShippingRepositoryImpl(remoteDataSource: server);
    await repo.getGovernorates();
    expect(repo.getCachedPrice('الإسكندرية'), 90);

    server.prices['الإسكندرية'] = 95; // admin edits the zone
    expect(repo.getCachedPrice('الإسكندرية'), 90, reason: 'cached until refreshed');

    await repo.refreshGovernorates();
    expect(repo.getCachedPrice('الإسكندرية'), 95);
    expect(repo.getCachedPrice('الاسكندريه'), 95, reason: 'spelling variants match');
  });

  test('a failed refresh keeps the last known prices', () async {
    final server = _FakeServer();
    final repo = ShippingRepositoryImpl(remoteDataSource: server);
    await repo.getGovernorates();

    server.down = true;
    final result = await repo.refreshGovernorates();

    expect(result.isLeft(), isTrue);
    expect(repo.getCachedPrice('القاهرة'), 80);
  });

  test('unknown governorates have no price instead of a made-up one', () {
    const state = ShippingState(
      governorates: [GovernorateModel(governorate: 'القاهرة', price: 80)],
      governoratesMap: {'القاهرة': 80},
    );
    expect(state.getMinorPriceFor('القاهرة'), 8000);
    expect(state.getPriceFor('مطروح'), isNull);
    expect(state.getMinorPriceFor('مطروح'), isNull);
  });
}
