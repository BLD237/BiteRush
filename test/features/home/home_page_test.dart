import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:food_delivery/features/home/data/repositories/home_repository.dart';
import 'package:food_delivery/features/home/presentation/pages/home_page.dart';
import 'package:food_delivery/features/home/presentation/providers/home_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('renders the branded home screen', (tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) =>
            HomeProvider(repository: const HomeRepository())..loadInitialData(),
        child: const MaterialApp(home: HomePage()),
      ),
    );

    expect(find.text('BiteRush'), findsOneWidget);
    expect(find.text('Order your favourite food!'), findsOneWidget);
    expect(find.text('Search'), findsOneWidget);
    expect(find.text('Cheeseburger'), findsOneWidget);
    expect(find.text("Wendy's Burger"), findsOneWidget);
  });
}
