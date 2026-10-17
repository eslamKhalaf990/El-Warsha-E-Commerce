import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:warsha_commerce/core/config/app_config.dart';
import 'package:warsha_commerce/core/di/di.dart';
import 'package:warsha_commerce/core/localization/locale_cubit.dart';
import 'package:warsha_commerce/core/router/app_router.dart';
import 'package:warsha_commerce/core/theme/app_theme.dart';
import 'package:warsha_commerce/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:warsha_commerce/features/cart/presentation/cubit/cart_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();
  await initDi();

  runApp(const EcommerceApp());
}

class EcommerceApp extends StatelessWidget {
  const EcommerceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CartCubit>(create: (_) => sl<CartCubit>()..loadCart()),
        BlocProvider<AuthCubit>(create: (_) => sl<AuthCubit>()..checkAuth()),
        BlocProvider<LocaleCubit>(create: (_) => sl<LocaleCubit>()),
      ],
      child: BlocBuilder<LocaleCubit, Locale>(
        builder: (context, locale) {
          return MaterialApp.router(
            title: '${AppConfig.brandNameAr} - ${AppConfig.brandName}',
            debugShowCheckedModeBanner: false,
            locale: locale,
            supportedLocales: const [
              Locale('ar', 'EG'),
              Locale('ar'),
              Locale('en'),
            ],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            theme: AppTheme.light(locale),
            themeMode: ThemeMode.light,
            routerConfig: appRouter,
          );
        },
      ),
    );
  }
}
