import 'package:flutter_test/flutter_test.dart';

import 'package:food_delivery/main.dart';

void main() {
  testWidgets('renders BiteRush splash screen', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('BiteRush'), findsOneWidget);
  });
}
