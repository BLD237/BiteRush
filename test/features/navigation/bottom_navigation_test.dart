import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:food_delivery/core/routes/app_router.dart';
import 'package:food_delivery/features/favorites/presentation/pages/favorites_page.dart';
import 'package:food_delivery/features/home/data/repositories/home_repository.dart';
import 'package:food_delivery/features/home/presentation/pages/home_page.dart';
import 'package:food_delivery/features/home/presentation/providers/home_provider.dart';
import 'package:food_delivery/features/orders/presentation/pages/orders_page.dart';
import 'package:food_delivery/features/profile/presentation/pages/profile_page.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('bottom navigation routes between screens', (tester) async {
    final router = GoRouter(
      initialLocation: AppRoutes.home,
      routes: [
        GoRoute(
          path: AppRoutes.home,
          builder: (context, state) => ChangeNotifierProvider(
            create: (_) =>
                HomeProvider(repository: const HomeRepository())
                  ..loadInitialData(),
            child: const HomePage(),
          ),
        ),
        GoRoute(
          path: AppRoutes.profile,
          builder: (context, state) => const ProfilePage(),
        ),
        GoRoute(
          path: AppRoutes.orders,
          builder: (context, state) => const OrdersPage(),
        ),
        GoRoute(
          path: AppRoutes.favorites,
          builder: (context, state) => const FavoritesPage(),
        ),
      ],
    );

    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.pumpAndSettle();

    expect(find.text('BiteRush'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('bottom-nav-profile')));
    await tester.pumpAndSettle();

    expect(find.text('Profile'), findsOneWidget);
    expect(find.text('Manage your account and preferences'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('bottom-nav-orders')));
    await tester.pumpAndSettle();

    expect(find.text('Orders'), findsOneWidget);
    expect(
      find.text('Track your orders and chat with support'),
      findsOneWidget,
    );

    await tester.tap(find.byKey(const ValueKey('bottom-nav-favorites')));
    await tester.pumpAndSettle();

    expect(find.text('Favorites'), findsOneWidget);
    expect(find.text('Saved foods and items you like most'), findsOneWidget);
  });
}
