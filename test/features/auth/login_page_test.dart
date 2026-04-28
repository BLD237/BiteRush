import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:food_delivery/features/auth/presentation/pages/login_page.dart';
import 'package:food_delivery/features/home/presentation/pages/home_page.dart';
import 'package:food_delivery/core/providers/app_startup_provider.dart';
import 'package:food_delivery/core/services/local_storage_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('login form submits and navigates to home', (tester) async {
    SharedPreferences.setMockInitialValues({
      'first_launch_completed': true,
      'is_logged_in': false,
    });
    final storage = await LocalStorageService.create();
    final provider = AppStartupProvider(localStorageService: storage);
    await provider.initialize();

    final media = MediaQuery(
      data: const MediaQueryData(size: Size(1080, 1920), textScaleFactor: 0.85),
      child: ChangeNotifierProvider<AppStartupProvider>.value(
        value: provider,
        child: const MaterialApp(home: LoginPage()),
      ),
    );

    await tester.pumpWidget(media);
    await tester.pumpAndSettle();

    // Enter email and password into the two TextFormFields
    final fields = find.byType(TextFormField);
    expect(fields, findsNWidgets(2));

    await tester.enterText(fields.at(0), 'test@example.com');
    await tester.enterText(fields.at(1), 'password123');
    await tester.pumpAndSettle();

    // Tap login button (use ElevatedButton with text to disambiguate)
    final loginBtn = find.widgetWithText(ElevatedButton, 'Login');
    expect(loginBtn, findsOneWidget);
    await tester.tap(loginBtn);
    await tester.pumpAndSettle();

    expect(find.byType(HomePage), findsOneWidget);
    expect(storage.getBool('is_logged_in'), isTrue);
  });
}
