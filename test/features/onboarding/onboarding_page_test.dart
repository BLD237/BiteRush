import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:food_delivery/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:food_delivery/core/providers/app_startup_provider.dart';
import 'package:food_delivery/core/services/local_storage_service.dart';
import 'package:food_delivery/features/auth/presentation/pages/login_page.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('completes onboarding and navigates to login', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final storage = await LocalStorageService.create();
    final provider = AppStartupProvider(localStorageService: storage);
    await provider.initialize();

    final media = MediaQuery(
      data: const MediaQueryData(size: Size(1080, 1920), textScaleFactor: 0.75),
      child: ChangeNotifierProvider<AppStartupProvider>.value(
        value: provider,
        child: const MaterialApp(home: OnboardingPage()),
      ),
    );

    await tester.pumpWidget(media);
    await tester.pumpAndSettle();

    // There are 3 pages. Press the Next button until Get Started appears.
    for (var i = 0; i < 3; i++) {
      final btn = find.byType(ElevatedButton).last;
      expect(btn, findsOneWidget);
      await tester.tap(btn);
      await tester.pumpAndSettle();
    }

    // After finishing, should navigate to LoginPage and set storage key
    expect(find.byType(LoginPage), findsOneWidget);
    expect(storage.getBool('first_launch_completed'), isTrue);
  });
}
