import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:food_delivery/core/services/local_storage_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('LocalStorageService', () {
    late LocalStorageService storage;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      storage = await LocalStorageService.create();
    });

    test('stores and reads primitive values', () async {
      expect(await storage.setString('name', 'BiteRush'), isTrue);
      expect(await storage.setBool('isLoggedIn', true), isTrue);
      expect(await storage.setInt('launchCount', 3), isTrue);
      expect(await storage.setDouble('ratio', 1.5), isTrue);
      expect(await storage.setStringList('items', ['burger', 'fries']), isTrue);

      expect(storage.getString('name'), 'BiteRush');
      expect(storage.getBool('isLoggedIn'), isTrue);
      expect(storage.getInt('launchCount'), 3);
      expect(storage.getDouble('ratio'), 1.5);
      expect(storage.getStringList('items'), ['burger', 'fries']);
      expect(storage.containsKey('name'), isTrue);
    });

    test('removes and clears values', () async {
      await storage.setString('token', 'abc');
      expect(storage.containsKey('token'), isTrue);

      expect(await storage.remove('token'), isTrue);
      expect(storage.containsKey('token'), isFalse);

      await storage.setString('session', 'active');
      expect(await storage.clear(), isTrue);
      expect(storage.containsKey('session'), isFalse);
    });
  });
}
