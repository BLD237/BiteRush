import 'package:flutter_test/flutter_test.dart';
import 'package:food_delivery/features/home/data/repositories/home_repository.dart';
import 'package:food_delivery/features/home/presentation/providers/home_provider.dart';

void main() {
  group('HomeProvider', () {
    late HomeProvider provider;

    setUp(() {
      provider = HomeProvider(repository: const HomeRepository());
      provider.loadInitialData();
    });

    test('loads categories and products', () {
      expect(provider.categories, isNotEmpty);
      expect(provider.products, isNotEmpty);
      expect(provider.categories.first.id, 'all');
    });

    test('filters products by search query', () {
      provider.setSearchQuery('spicy');

      expect(provider.visibleProducts.length, 1);
      expect(provider.visibleProducts.first.title, 'Spicy Burger');
    });

    test('filters products by category', () {
      provider.selectCategory('pizza');

      expect(provider.visibleProducts.length, 1);
      expect(provider.visibleProducts.first.title, 'Pepper Pizza');
    });

    test('toggles favorites', () {
      expect(provider.isFavorite('double-burger'), isFalse);

      provider.toggleFavorite('double-burger');

      expect(provider.isFavorite('double-burger'), isTrue);
    });

    test('cycles filter options', () {
      expect(provider.selectedFilterId, 'recommended');

      provider.cycleFilter();

      expect(provider.selectedFilterId, 'top_rated');
    });
  });
}
