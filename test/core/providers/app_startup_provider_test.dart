import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:food_delivery/core/providers/app_startup_provider.dart';
import 'package:food_delivery/core/services/local_storage_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AppStartupProvider', () {
    test('initializes to onboarding when first launch not completed', () async {
      SharedPreferences.setMockInitialValues({});
      final storage = await LocalStorageService.create();
      final provider = AppStartupProvider(localStorageService: storage);

      await provider.initialize();

      expect(provider.isLoading, isFalse);
      expect(provider.destination, AppStartDestination.onboarding);
    });

    test(
      'initializes to home when first launch completed and logged in',
      () async {
        SharedPreferences.setMockInitialValues({
          'first_launch_completed': true,
          'is_logged_in': true,
        });
        final storage = await LocalStorageService.create();
        final provider = AppStartupProvider(localStorageService: storage);

        await provider.initialize();

        expect(provider.destination, AppStartDestination.home);
      },
    );

    test(
      'initializes to login when first launch completed but not logged in',
      () async {
        SharedPreferences.setMockInitialValues({
          'first_launch_completed': true,
          'is_logged_in': false,
        });
        final storage = await LocalStorageService.create();
        final provider = AppStartupProvider(localStorageService: storage);

        await provider.initialize();

        expect(provider.destination, AppStartDestination.login);
      },
    );

    test(
      'markOnboardingComplete sets storage and destination to login',
      () async {
        SharedPreferences.setMockInitialValues({});
        final storage = await LocalStorageService.create();
        final provider = AppStartupProvider(localStorageService: storage);

        await provider.initialize();
        await provider.markOnboardingComplete();

        expect(storage.getBool('first_launch_completed'), isTrue);
        expect(provider.destination, AppStartDestination.login);
      },
    );

    test('setLoggedIn toggles login state and destination', () async {
      SharedPreferences.setMockInitialValues({});
      final storage = await LocalStorageService.create();
      final provider = AppStartupProvider(localStorageService: storage);

      await provider.initialize();
      await provider.setLoggedIn(true);

      expect(storage.getBool('is_logged_in'), isTrue);
      expect(provider.destination, AppStartDestination.home);

      await provider.setLoggedIn(false);
      expect(storage.getBool('is_logged_in'), isFalse);
      expect(provider.destination, AppStartDestination.login);
    });
  });
}
