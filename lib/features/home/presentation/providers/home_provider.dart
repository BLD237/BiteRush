import 'package:flutter/foundation.dart';
import 'package:food_delivery/features/home/data/models/burger_product.dart';
import 'package:food_delivery/features/home/data/models/home_category.dart';
import 'package:food_delivery/features/home/data/models/home_filter_option.dart';
import 'package:food_delivery/features/home/data/repositories/home_repository.dart';

class HomeProvider extends ChangeNotifier {
  HomeProvider({HomeRepository? repository})
    : _repository = repository ?? const HomeRepository();

  final HomeRepository _repository;

  List<HomeCategory> _categories = const [];
  List<HomeFilterOption> _filters = const [];
  List<BurgerProduct> _products = const [];
  String _searchQuery = '';
  String _selectedCategoryId = 'all';
  String _selectedFilterId = 'recommended';
  final Set<String> _favoriteProductIds = <String>{};

  bool _isLoaded = false;

  List<HomeCategory> get categories => _categories;
  List<HomeFilterOption> get filters => _filters;
  List<BurgerProduct> get products => _products;
  String get searchQuery => _searchQuery;
  String get selectedCategoryId => _selectedCategoryId;
  String get selectedFilterId => _selectedFilterId;
  String get selectedFilterLabel {
    if (_filters.isEmpty) {
      return 'Filters';
    }

    return _filters
        .firstWhere(
          (filter) => filter.id == _selectedFilterId,
          orElse: () => _filters.first,
        )
        .label;
  }

  bool get isLoaded => _isLoaded;

  Set<String> get favoriteProductIds => Set.unmodifiable(_favoriteProductIds);

  void loadInitialData() {
    if (_isLoaded) {
      return;
    }

    _categories = _repository.loadCategories();
    _filters = _repository.loadFilters();
    _products = _repository.loadProducts();
    _isLoaded = true;
    notifyListeners();
  }

  void setSearchQuery(String value) {
    final normalizedValue = value.trim();
    if (_searchQuery == normalizedValue) {
      return;
    }
    _searchQuery = normalizedValue;
    notifyListeners();
  }

  void selectCategory(String categoryId) {
    if (_selectedCategoryId == categoryId) {
      return;
    }
    _selectedCategoryId = categoryId;
    notifyListeners();
  }

  void selectFilter(String filterId) {
    if (_selectedFilterId == filterId) {
      return;
    }
    _selectedFilterId = filterId;
    notifyListeners();
  }

  void cycleFilter() {
    if (_filters.isEmpty) {
      return;
    }

    final currentIndex = _filters.indexWhere(
      (filter) => filter.id == _selectedFilterId,
    );
    final nextIndex = (currentIndex + 1) % _filters.length;
    selectFilter(_filters[nextIndex].id);
  }

  void toggleFavorite(String productId) {
    if (_favoriteProductIds.contains(productId)) {
      _favoriteProductIds.remove(productId);
    } else {
      _favoriteProductIds.add(productId);
    }
    notifyListeners();
  }

  bool isFavorite(String productId) => _favoriteProductIds.contains(productId);

  List<BurgerProduct> get visibleProducts {
    Iterable<BurgerProduct> results = _products;

    if (_selectedCategoryId != 'all') {
      results = results.where(
        (product) => product.categoryId == _selectedCategoryId,
      );
    }

    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      results = results.where(
        (product) =>
            product.title.toLowerCase().contains(query) ||
            product.subtitle.toLowerCase().contains(query),
      );
    }

    final visible = results.toList();

    switch (_selectedFilterId) {
      case 'top_rated':
        visible.sort((left, right) => right.rating.compareTo(left.rating));
        break;
      case 'popular':
        visible.sort((left, right) => right.title.compareTo(left.title));
        break;
      case 'price_low':
        visible.sort((left, right) => left.title.compareTo(right.title));
        break;
      case 'price_high':
        visible.sort((left, right) => right.title.compareTo(left.title));
        break;
      case 'recommended':
      default:
        break;
    }

    return visible;
  }
}
