import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:warsha_commerce/core/config/app_config.dart';
import 'package:warsha_commerce/core/config/mock_debug_state.dart';
import 'package:warsha_commerce/core/localization/locale_cubit.dart';
import 'package:warsha_commerce/core/network/dio_client.dart';
import 'package:warsha_commerce/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:warsha_commerce/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:warsha_commerce/features/auth/data/repositories/mock_auth_repository.dart';
import 'package:warsha_commerce/features/auth/domain/repositories/auth_repository.dart';
import 'package:warsha_commerce/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:warsha_commerce/features/cart/data/datasources/cart_local_datasource.dart';
import 'package:warsha_commerce/features/cart/data/repositories/cart_repository_impl.dart';
import 'package:warsha_commerce/features/cart/data/repositories/mock_cart_repository.dart';
import 'package:warsha_commerce/features/cart/domain/repositories/cart_repository.dart';
import 'package:warsha_commerce/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:warsha_commerce/features/catalog/data/datasources/catalog_remote_datasource.dart';
import 'package:warsha_commerce/features/catalog/data/repositories/catalog_repository_impl.dart';
import 'package:warsha_commerce/features/catalog/data/repositories/mock_catalog_repository.dart';
import 'package:warsha_commerce/features/catalog/domain/repositories/catalog_repository.dart';
import 'package:warsha_commerce/features/catalog/presentation/cubit/catalog_cubit.dart';
import 'package:warsha_commerce/features/checkout/data/datasources/checkout_remote_datasource.dart';
import 'package:warsha_commerce/features/checkout/data/repositories/checkout_repository_impl.dart';
import 'package:warsha_commerce/features/checkout/data/repositories/mock_checkout_repository.dart';
import 'package:warsha_commerce/features/checkout/domain/repositories/checkout_repository.dart';
import 'package:warsha_commerce/features/checkout/presentation/cubit/checkout_cubit.dart';
import 'package:warsha_commerce/features/feedback/data/datasources/feedback_remote_datasource.dart';
import 'package:warsha_commerce/features/feedback/data/repositories/feedback_repository_impl.dart';
import 'package:warsha_commerce/features/feedback/data/repositories/mock_feedback_repository.dart';
import 'package:warsha_commerce/features/feedback/domain/repositories/feedback_repository.dart';
import 'package:warsha_commerce/features/feedback/presentation/cubit/customer_feedback_cubit.dart';
import 'package:warsha_commerce/features/feedback/presentation/cubit/feedback_submission_cubit.dart';
import 'package:warsha_commerce/features/feedback/presentation/cubit/product_feedback_cubit.dart';
import 'package:warsha_commerce/features/feedback/presentation/cubit/testimonials_cubit.dart';
import 'package:warsha_commerce/features/home/data/repositories/banners_repository_impl.dart';
import 'package:warsha_commerce/features/home/data/repositories/mock_banners_repository.dart';
import 'package:warsha_commerce/features/home/domain/repositories/banners_repository.dart';
import 'package:warsha_commerce/features/home/presentation/cubit/home_cubit.dart';
import 'package:warsha_commerce/features/orders/data/datasources/orders_remote_datasource.dart';
import 'package:warsha_commerce/features/orders/data/repositories/mock_orders_repository.dart';
import 'package:warsha_commerce/features/orders/data/repositories/orders_repository_impl.dart';
import 'package:warsha_commerce/features/orders/domain/repositories/orders_repository.dart';
import 'package:warsha_commerce/features/product_details/presentation/cubit/product_details_cubit.dart';
import 'package:warsha_commerce/features/profile/data/repositories/mock_profile_repository.dart';
import 'package:warsha_commerce/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:warsha_commerce/features/profile/domain/repositories/profile_repository.dart';

final GetIt sl = GetIt.instance;

Future<void> initDi() async {
  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  sl.registerLazySingleton<Dio>(() => Dio());

  // Network client
  sl.registerLazySingleton<DioClient>(
    () => DioClient(dio: sl(), sharedPreferences: sl()),
  );

  // Debug controller for mock state testing
  sl.registerLazySingleton<MockDebugController>(
    () => MockDebugController.instance,
  );

  // Repositories (swapped via AppConfig.useMockData)
  if (AppConfig.useMockData) {
    sl.registerLazySingleton<CatalogRepository>(
      () => MockCatalogRepository(debugController: sl()),
    );
    sl.registerLazySingleton<CartRepository>(
      () => MockCartRepository(debugController: sl()),
    );
    sl.registerLazySingleton<CheckoutRepository>(
      () => MockCheckoutRepository(debugController: sl()),
    );
    sl.registerLazySingleton<OrdersRepository>(
      () => MockOrdersRepository(debugController: sl()),
    );
    sl.registerLazySingleton<ProfileRepository>(
      () => MockProfileRepository(debugController: sl()),
    );
    sl.registerLazySingleton<BannersRepository>(
      () => MockBannersRepository(debugController: sl()),
    );
    sl.registerLazySingleton<AuthRepository>(
      () => MockAuthRepository(sharedPreferences: sl()),
    );
    sl.registerLazySingleton<FeedbackRepository>(
      () => MockFeedbackRepository(),
    );
  } else {
    // Real backend API implementations for Catalog and Home
    sl.registerLazySingleton<CatalogRemoteDataSource>(
      () => CatalogRemoteDataSourceImpl(client: sl()),
    );
    sl.registerLazySingleton<CatalogRepository>(
      () => CatalogRepositoryImpl(remoteDataSource: sl()),
    );
    sl.registerLazySingleton<BannersRepository>(
      () => BannersRepositoryImpl(catalogRepository: sl()),
    );

    // Real Cart (persisted in SharedPreferences, synced with catalog)
    sl.registerLazySingleton<CartLocalDataSource>(
      () => CartLocalDataSourceImpl(sharedPreferences: sl()),
    );
    sl.registerLazySingleton<CartRepository>(
      () => CartRepositoryImpl(
        localDataSource: sl(),
        catalogRepository: sl(),
      ),
    );

    // Real Checkout (POST /orders/placeOrder via Dio with pre-flight reconciliation)
    sl.registerLazySingleton<CheckoutRemoteDataSource>(
      () => CheckoutRemoteDataSourceImpl(client: sl()),
    );
    sl.registerLazySingleton<CheckoutRepository>(
      () => CheckoutRepositoryImpl(
        remoteDataSource: sl(),
        catalogRepository: sl(),
      ),
    );

    // Real Orders (GET /orders/customer)
    sl.registerLazySingleton<OrdersRemoteDataSource>(
      () => OrdersRemoteDataSourceImpl(client: sl()),
    );
    sl.registerLazySingleton<OrdersRepository>(
      () => OrdersRepositoryImpl(remoteDataSource: sl()),
    );

    // Real Profile (persisted customer info in SharedPreferences)
    sl.registerLazySingleton<ProfileRepository>(
      () => ProfileRepositoryImpl(sharedPreferences: sl()),
    );

    // Real Auth (POST /customers/customerSignUp, /auth/verifyCode, /auth/customerLogin, etc.)
    sl.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(client: sl()),
    );
    sl.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(
        remoteDataSource: sl(),
        sharedPreferences: sl(),
        profileRepository: sl<ProfileRepository>(),
      ),
    );

    // Real Feedbacks, Reviews & Threaded Comments (POST /feedbacks, GET /feedbacks/public, GET /feedbacks/product/:id, etc.)
    sl.registerLazySingleton<FeedbackRemoteDataSource>(
      () => FeedbackRemoteDataSourceImpl(client: sl()),
    );
    sl.registerLazySingleton<FeedbackRepository>(
      () => FeedbackRepositoryImpl(remoteDataSource: sl()),
    );
  }

  // Cubits / Blocs
  sl.registerLazySingleton<LocaleCubit>(() => LocaleCubit());
  sl.registerLazySingleton<CartCubit>(() => CartCubit(cartRepository: sl()));
  sl.registerLazySingleton<AuthCubit>(() => AuthCubit(authRepository: sl()));
  sl.registerFactory<CatalogCubit>(() => CatalogCubit(catalogRepository: sl()));
  sl.registerFactory<HomeCubit>(
    () => HomeCubit(bannersRepository: sl(), catalogRepository: sl()),
  );
  sl.registerFactory<CheckoutCubit>(
    () => CheckoutCubit(checkoutRepository: sl(), profileRepository: sl()),
  );
  sl.registerFactory<ProductDetailsCubit>(
    () => ProductDetailsCubit(catalogRepository: sl()),
  );
  sl.registerFactory<TestimonialsCubit>(
    () => TestimonialsCubit(feedbackRepository: sl()),
  );
  sl.registerFactory<ProductFeedbackCubit>(
    () => ProductFeedbackCubit(feedbackRepository: sl()),
  );
  sl.registerFactory<CustomerFeedbackCubit>(
    () => CustomerFeedbackCubit(feedbackRepository: sl()),
  );
  sl.registerFactory<FeedbackSubmissionCubit>(
    () => FeedbackSubmissionCubit(feedbackRepository: sl()),
  );
}
