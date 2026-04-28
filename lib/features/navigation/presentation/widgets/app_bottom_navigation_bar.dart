import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:food_delivery/core/constants/app_assets.dart';
import 'package:food_delivery/core/routes/app_router.dart';

class AppBottomNavigationBar extends StatelessWidget {
  const AppBottomNavigationBar({super.key, required this.activeIndex});

  final int activeIndex;

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: const Color(0xFFEF2A39),
      elevation: 0,
      surfaceTintColor: const Color(0xFFEF2A39),
      shadowColor: Colors.black.withOpacity(0.2),
      notchMargin: 8,
      shape: const CircularNotchedRectangle(),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 90,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _BottomNavItem(
                key: const ValueKey('bottom-nav-home'),
                iconAsset: AppAssets.homeIcon,
                active: activeIndex == 0,
                onTap: () => context.go(AppRoutes.home),
              ),
              _BottomNavItem(
                key: const ValueKey('bottom-nav-profile'),
                iconAsset: AppAssets.userIcon,
                active: activeIndex == 1,
                onTap: () => context.go(AppRoutes.profile),
              ),
              const SizedBox(width: 48),
              _BottomNavItem(
                key: const ValueKey('bottom-nav-orders'),
                iconAsset: AppAssets.commentIcon,
                active: activeIndex == 2,
                onTap: () => context.go(AppRoutes.orders),
              ),
              _BottomNavItem(
                key: const ValueKey('bottom-nav-favorites'),
                iconAsset: AppAssets.heartIcon,
                active: activeIndex == 3,
                onTap: () => context.go(AppRoutes.favorites),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomNavItem extends StatelessWidget {
  const _BottomNavItem({
    super.key,
    required this.iconAsset,
    required this.active,
    required this.onTap,
  });

  final String iconAsset;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: SizedBox(
        width: 44,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(iconAsset, width: 24, height: 24, color: Colors.white),
            const SizedBox(height: 6),
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOutCubic,
              width: 5,
              height: 5,
              decoration: BoxDecoration(
                color: active ? Colors.white : Colors.transparent,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
