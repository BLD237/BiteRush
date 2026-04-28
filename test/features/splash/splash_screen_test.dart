import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:food_delivery/core/services/local_storage_service.dart';
import 'package:food_delivery/core/providers/app_startup_provider.dart';
import 'package:food_delivery/features/splash/presentation/pages/splash_screen.dart';
import 'package:food_delivery/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:food_delivery/features/auth/presentation/pages/login_page.dart';
import 'package:food_delivery/features/home/data/repositories/home_repository.dart';
import 'package:food_delivery/features/home/presentation/pages/home_page.dart';
import 'package:food_delivery/features/home/presentation/providers/home_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<void> _pumpWithProvider(
    WidgetTester tester,
    AppStartupProvider provider,
  ) async {
    tester.binding.window.physicalSizeTestValue = const Size(1080, 1920);
    tester.binding.window.devicePixelRatioTestValue = 1.0;
    addTearDown(() {
      tester.binding.window.clearPhysicalSizeTestValue();
      tester.binding.window.clearDevicePixelRatioTestValue();
    });

    final media = MediaQuery(
      data: const MediaQueryData(size: Size(1080, 1920), textScaleFactor: 0.75),
      child: ChangeNotifierProvider<AppStartupProvider>.value(
        value: provider,
        child: MaterialApp.router(
          routerConfig: GoRouter(
            initialLocation: '/',
            routes: [
              GoRoute(
                path: '/',
                builder: (context, state) => const SplashScreen(),
              ),
              GoRoute(
                path: '/onboarding',
                builder: (context, state) => const OnboardingPage(),
              ),
              GoRoute(
                path: '/login',
                builder: (context, state) => const LoginPage(),
              ),
              GoRoute(
                path: '/home',
                builder: (context, state) => ChangeNotifierProvider(
                  create: (_) =>
                      HomeProvider(repository: const HomeRepository())
                        ..loadInitialData(),
                  child: const HomePage(),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    await tester.pumpWidget(media);
  }

  testWidgets(
    'navigates to onboarding when startup destination is onboarding',
    (tester) async {
      SharedPreferences.setMockInitialValues({});
      final storage = await LocalStorageService.create();
      final provider = AppStartupProvider(localStorageService: storage);
      await provider.initialize();

      await _pumpWithProvider(tester, provider);

      // advance animation duration and settle navigation
      await tester.pump(const Duration(milliseconds: 2400));
      await tester.pumpAndSettle();

      expect(find.byType(OnboardingPage), findsOneWidget);
    },
  );

  testWidgets('navigates to login when startup destination is login', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({
      'first_launch_completed': true,
      'is_logged_in': false,
    });
    final storage = await LocalStorageService.create();
    final provider = AppStartupProvider(localStorageService: storage);
    await provider.initialize();

    await _pumpWithProvider(tester, provider);

    await tester.pump(const Duration(milliseconds: 2400));
    await tester.pumpAndSettle();

    expect(find.byType(LoginPage), findsOneWidget);
  });

  testWidgets('navigates to home when startup destination is home', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({
      'first_launch_completed': true,
      'is_logged_in': true,
    });
    final storage = await LocalStorageService.create();
    final provider = AppStartupProvider(localStorageService: storage);
    await provider.initialize();

    await _pumpWithProvider(tester, provider);

    await tester.pump(const Duration(milliseconds: 2400));
    await tester.pumpAndSettle();

    expect(find.byType(HomePage), findsOneWidget);
  });
}
