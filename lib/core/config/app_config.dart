abstract final class AppConfig {
  static const String brandName = 'ELWARSHA';
  static const String brandNameAr = 'الورشة';

  static const bool useMockData = bool.fromEnvironment(
    'USE_MOCK',
    defaultValue: false,
  );
}
