import 'package:food_delivery/core/constants/app_assets.dart';
import 'package:food_delivery/features/home/data/models/burger_product.dart';
import 'package:food_delivery/features/home/data/models/home_category.dart';
import 'package:food_delivery/features/home/data/models/home_filter_option.dart';

class HomeRepository {
  const HomeRepository();

  List<HomeCategory> loadCategories() {
    return const [
      HomeCategory(id: 'all', label: 'All'),
      HomeCategory(id: 'burger', label: 'Burger'),
      HomeCategory(id: 'pizza', label: 'Pizza'),
      HomeCategory(id: 'dessert', label: 'Dessert'),
      HomeCategory(id: 'drinks', label: 'Drinks'),
    ];
  }

  List<HomeFilterOption> loadFilters() {
    return const [
      HomeFilterOption(id: 'recommended', label: 'Recommended'),
      HomeFilterOption(id: 'top_rated', label: 'Top rated'),
      HomeFilterOption(id: 'popular', label: 'Popular'),
      HomeFilterOption(id: 'price_low', label: 'Price: Low to high'),
      HomeFilterOption(id: 'price_high', label: 'Price: High to low'),
    ];
  }

  List<BurgerProduct> loadProducts() {
    return const [
      BurgerProduct(
        id: 'cheeseburger',
        title: 'Cheeseburger',
        subtitle: "Wendy's Burger",
        rating: 4.9,
        imageAsset: AppAssets.burgerOne,
        categoryId: 'burger',
      ),
      BurgerProduct(
        id: 'double-burger',
        title: 'Double Burger',
        subtitle: 'Burger House',
        rating: 4.8,
        imageAsset: AppAssets.burgerFive,
        categoryId: 'burger',
      ),
      BurgerProduct(
        id: 'classic-burger',
        title: 'Classic Burger',
        subtitle: 'Cheese & lettuce',
        rating: 4.7,
        imageAsset: AppAssets.burgerThree,
        categoryId: 'burger',
      ),
      BurgerProduct(
        id: 'spicy-burger',
        title: 'Spicy Burger',
        subtitle: 'Signature spicy sauce',
        rating: 4.9,
        imageAsset: AppAssets.burgerFour,
        categoryId: 'burger',
      ),
      BurgerProduct(
        id: 'pizza',
        title: 'Pepper Pizza',
        subtitle: 'Crispy crust and extra cheese',
        rating: 4.8,
        imageAsset: AppAssets.pizza,
        categoryId: 'pizza',
      ),
    ];
  }
}
