import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:food_delivery/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:food_delivery/features/auth/presentation/pages/login_page.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('forgot password submit navigates back to login', (tester) async {
    // Ensure a sufficiently wide test surface to avoid layout overflow
    // Wrap with MediaQuery to control text scale and avoid overflow in tests.
    final media = MediaQuery(
      data: const MediaQueryData(size: Size(1080, 1920), textScaleFactor: 0.75),
      child: MaterialApp.router(
        routerConfig: GoRouter(
          initialLocation: '/forgot',
          routes: [
            GoRoute(
              path: '/forgot',
              builder: (context, state) => const ForgotPasswordPage(),
            ),
            GoRoute(
              path: '/login',
              builder: (context, state) => const LoginPage(),
            ),
          ],
        ),
      ),
    );

    await tester.pumpWidget(media);
    await tester.pumpAndSettle();

    final emailField = find.byType(TextFormField);
    expect(emailField, findsOneWidget);

    await tester.enterText(emailField, 'test@example.com');
    await tester.pumpAndSettle();

    final submitBtn = find.text('Submit');
    expect(submitBtn, findsOneWidget);
    await tester.tap(submitBtn);
    await tester.pumpAndSettle();

    expect(find.byType(LoginPage), findsOneWidget);
  });
}
