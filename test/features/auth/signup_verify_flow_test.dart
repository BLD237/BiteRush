import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:food_delivery/features/auth/presentation/pages/signup_page.dart';
import 'package:food_delivery/features/auth/presentation/pages/verify_email_page.dart';
import 'package:food_delivery/features/auth/presentation/pages/login_page.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('signup navigates to verify and then back to login', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});

    final media = MediaQuery(
      data: const MediaQueryData(size: Size(1080, 1920), textScaleFactor: 0.85),
      child: const MaterialApp(home: SignupPage()),
    );

    await tester.pumpWidget(media);
    await tester.pumpAndSettle();

    // There are 4 fields: Full Name, Email, Password, Confirm Password
    final fields = find.byType(TextFormField);
    expect(fields, findsNWidgets(4));

    await tester.enterText(fields.at(0), 'Test User');
    await tester.enterText(fields.at(1), 'test@example.com');
    await tester.enterText(fields.at(2), 'password123');
    await tester.enterText(fields.at(3), 'password123');
    await tester.pumpAndSettle();

    // Tap Signup (disambiguate using ElevatedButton)
    final signupBtn = find.widgetWithText(ElevatedButton, 'Signup');
    expect(signupBtn, findsOneWidget);
    await tester.tap(signupBtn);
    await tester.pumpAndSettle();

    // Should be on VerifyEmailPage
    expect(find.byType(VerifyEmailPage), findsOneWidget);

    // Tap Create Account
    final createBtn = find.text('Create Account');
    expect(createBtn, findsOneWidget);
    await tester.tap(createBtn);
    await tester.pumpAndSettle();

    // Should navigate back to LoginPage
    expect(find.byType(LoginPage), findsOneWidget);
  });
}
