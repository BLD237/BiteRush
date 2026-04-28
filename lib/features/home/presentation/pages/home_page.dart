import 'package:flutter/material.dart';
import 'package:food_delivery/core/constants/app_colors.dart';
import 'package:food_delivery/features/home/data/models/burger_product.dart';
import 'package:food_delivery/features/home/data/models/home_category.dart';
import 'package:food_delivery/features/home/presentation/providers/home_provider.dart';
import 'package:food_delivery/features/navigation/presentation/widgets/app_bottom_navigation_bar.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _introController;

  @override
  void initState() {
    super.initState();
    _introController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    )..forward();
  }

  @override
  void dispose() {
    _introController.dispose();
    super.dispose();
  }

  Animation<double> _sectionAnimation(double begin, double end) {
    return CurvedAnimation(
      parent: _introController,
      curve: Interval(begin, end, curve: Curves.easeOutCubic),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.white,
        leadingWidth: 132,
        leading: const Padding(
          padding: EdgeInsets.only(left: 12),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'BiteRush',
              style: TextStyle(
                color: Color(0xFF3A2A26),
                fontSize: 30,
                fontWeight: FontWeight.w700,
                fontStyle: FontStyle.italic,
                letterSpacing: -0.4,
              ),
            ),
          ),
        ),
        title: const SizedBox.shrink(),
        titleSpacing: 0,
        centerTitle: false,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: Color(0xFFFFD9C9),
              child: Icon(Icons.person_rounded, color: Color(0xFF8A4B3A)),
            ),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: Consumer<HomeProvider>(
          builder: (context, homeProvider, _) {
            if (!homeProvider.isLoaded) {
              return const Center(
                child: CircularProgressIndicator(color: Color(0xFFEF2A39)),
              );
            }

            return ListView(
              padding: const EdgeInsets.fromLTRB(19, 12, 20, 24),
              children: [
                _AnimatedSection(
                  animation: _sectionAnimation(0.0, 0.18),
                  slideOffset: const Offset(0, 0.08),
                  child: const Text(
                    'Order your favourite food!',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Color(0xFF242424),
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      height: 1.2,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                _AnimatedSection(
                  animation: _sectionAnimation(0.08, 0.28),
                  slideOffset: const Offset(0, 0.08),
                  child: Row(
                    children: [
                      Expanded(
                        child: _SearchBar(
                          onChanged: homeProvider.setSearchQuery,
                        ),
                      ),
                      const SizedBox(width: 12),
                      _FilterButton(
                        onTap: () => _showFilterSheet(context, homeProvider),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                _AnimatedSection(
                  animation: _sectionAnimation(0.16, 0.38),
                  slideOffset: const Offset(0, 0.08),
                  child: _CategoryStrip(
                    categories: homeProvider.categories,
                    selectedCategoryId: homeProvider.selectedCategoryId,
                    onCategorySelected: homeProvider.selectCategory,
                  ),
                ),
                const SizedBox(height: 18),
                _AnimatedSection(
                  animation: _sectionAnimation(0.26, 0.52),
                  slideOffset: const Offset(0, 0.06),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    switchInCurve: Curves.easeOutCubic,
                    switchOutCurve: Curves.easeInCubic,
                    transitionBuilder: (child, animation) {
                      final fade = CurvedAnimation(
                        parent: animation,
                        curve: Curves.easeOut,
                      );
                      final slide = Tween<Offset>(
                        begin: const Offset(0, 0.03),
                        end: Offset.zero,
                      ).animate(fade);
                      return FadeTransition(
                        opacity: fade,
                        child: SlideTransition(position: slide, child: child),
                      );
                    },
                    child: KeyedSubtree(
                      key: ValueKey(
                        '${homeProvider.searchQuery}_${homeProvider.selectedCategoryId}_${homeProvider.selectedFilterId}_${homeProvider.visibleProducts.length}',
                      ),
                      child: _FoodGrid(
                        products: homeProvider.visibleProducts,
                        isFavorite: homeProvider.isFavorite,
                        onFavoriteTap: homeProvider.toggleFavorite,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: const AppBottomNavigationBar(activeIndex: 0),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color(0xFFEF2A39),
        foregroundColor: Colors.white,
        elevation: 8,
        shape: const CircleBorder(),
        child: const Icon(Icons.add_rounded, size: 30),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

class _AnimatedSection extends StatelessWidget {
  const _AnimatedSection({
    required this.animation,
    required this.child,
    this.slideOffset = Offset.zero,
  });

  final Animation<double> animation;
  final Widget child;
  final Offset slideOffset;

  @override
  Widget build(BuildContext context) {
    final slide = Tween<Offset>(
      begin: slideOffset,
      end: Offset.zero,
    ).animate(animation);
    return FadeTransition(
      opacity: animation,
      child: SlideTransition(position: slide, child: child),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({required this.onChanged});

  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        height: 60,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              offset: const Offset(0, 4),
              blurRadius: 12,
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.search_rounded, color: Colors.black45),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                onChanged: onChanged,
                decoration: const InputDecoration(
                  hintText: 'Search',
                  border: InputBorder.none,
                  isCollapsed: true,
                  hintStyle: TextStyle(color: Colors.black45, fontSize: 13),
                ),
                style: const TextStyle(color: Colors.black87, fontSize: 13),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterButton extends StatelessWidget {
  const _FilterButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: const Color(0xFFEF2A39),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Center(
            child: Icon(Icons.tune_rounded, color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class _CategoryStrip extends StatelessWidget {
  const _CategoryStrip({
    required this.categories,
    required this.selectedCategoryId,
    required this.onCategorySelected,
  });

  final List<HomeCategory> categories;
  final String selectedCategoryId;
  final ValueChanged<String> onCategorySelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Transform.translate(
        offset: const Offset(-19, 0),
        child: SizedBox(
          width: MediaQuery.sizeOf(context).width,
          child: Container(
            color: Colors.white,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 19),
              itemCount: categories.length,
              separatorBuilder: (context, index) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                final category = categories[index];
                return _CategoryChip(
                  label: category.label,
                  selected: selectedCategoryId == category.id,
                  onTap: () => onCategorySelected(category.id),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.label,
    required this.onTap,
    this.selected = false,
  });

  final String label;
  final VoidCallback onTap;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(17),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          height: 34,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: selected ? AppColors.primary : const Color(0xFFF4F1EE),
            borderRadius: BorderRadius.circular(17),
            border: Border.all(
              color: selected ? AppColors.primary : const Color(0xFFE4DDD7),
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              color: selected ? Colors.white : const Color(0xFF4F3B33),
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

class _FoodGrid extends StatelessWidget {
  const _FoodGrid({
    required this.products,
    required this.isFavorite,
    required this.onFavoriteTap,
  });

  final List<BurgerProduct> products;
  final bool Function(String productId) isFavorite;
  final ValueChanged<String> onFavoriteTap;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 3,
        mainAxisSpacing: 14,
        mainAxisExtent: 225,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return _FoodCard(
          card: product,
          isFavorite: isFavorite(product.id),
          onFavoriteTap: () => onFavoriteTap(product.id),
        );
      },
    );
  }
}

class _FoodCard extends StatelessWidget {
  const _FoodCard({
    required this.card,
    required this.isFavorite,
    required this.onFavoriteTap,
  });

  final BurgerProduct card;
  final bool isFavorite;
  final VoidCallback onFavoriteTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            offset: const Offset(0, 6),
            blurRadius: 16,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 5,
            child: Center(
              child: Image.asset(
                card.imageAsset,
                width: 110,
                height: 110,
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            card.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color(0xFF34211C),
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            card.subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.black54,
              fontSize: 12,
              height: 1.2,
            ),
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.star_rounded,
                    color: Color(0xFFFFB400),
                    size: 16,
                  ),
                  const SizedBox(width: 3),
                  Text(
                    card.rating.toStringAsFixed(1),
                    style: const TextStyle(
                      color: Color(0xFF34211C),
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              InkWell(
                onTap: onFavoriteTap,
                borderRadius: BorderRadius.circular(999),
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: isFavorite
                        ? const Color(0xFFEF2A39)
                        : const Color(0xFFFFEEF0),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Icon(
                    isFavorite
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    color: isFavorite ? Colors.white : const Color(0xFFEF2A39),
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

void _showFilterSheet(BuildContext context, HomeProvider provider) {
  showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (sheetContext) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Filters',
                style: TextStyle(
                  color: Color(0xFF34211C),
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 14),
              ...provider.filters.map(
                (filter) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(filter.label),
                  trailing: provider.selectedFilterId == filter.id
                      ? const Icon(
                          Icons.check_rounded,
                          color: Color(0xFFEF2A39),
                        )
                      : null,
                  onTap: () {
                    provider.selectFilter(filter.id);
                    Navigator.of(sheetContext).pop();
                  },
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
