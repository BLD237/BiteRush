import 'package:flutter/material.dart';
import 'package:food_delivery/core/constants/app_assets.dart';
import 'package:food_delivery/core/constants/app_colors.dart';
import 'package:food_delivery/core/providers/app_startup_provider.dart';
import 'package:food_delivery/features/onboarding/presentation/providers/onboarding_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:food_delivery/core/routes/app_router.dart';
import 'package:provider/provider.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => OnboardingProvider(),
      child: const _OnboardingView(),
    );
  }
}

class _OnboardingView extends StatefulWidget {
  const _OnboardingView();

  @override
  State<_OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<_OnboardingView> {
  late final PageController _pageController;

  final List<_OnboardingItem> _items = const [
    _OnboardingItem(
      title: 'Fresh burgers, fast delivery',
      subtitle: 'Hot, juicy burgers delivered before the craving cools down.',
      assetPath: AppAssets.burgerThree,
      accent: Color(0xFFFFC2C2),
    ),
    _OnboardingItem(
      title: 'Pizza made for sharing',
      subtitle: 'Melty cheese, crisp crust, and a warm finish every time.',
      assetPath: AppAssets.pizza,
      accent: Color(0xFFFFD29B),
    ),
    _OnboardingItem(
      title: 'More flavor in every bite',
      subtitle: 'Swipe through the menu and unlock a smoother way to order.',
      assetPath: AppAssets.burgerFour,
      accent: Color(0xFFFFE0B8),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _goToNextPage() async {
    final provider = context.read<OnboardingProvider>();
    if (provider.currentPage < _items.length - 1) {
      await _pageController.nextPage(
        duration: const Duration(milliseconds: 360),
        curve: Curves.easeOutCubic,
      );
    } else {
      final router = GoRouter.of(context);
      await context.read<AppStartupProvider>().markOnboardingComplete();
      if (!mounted) {
        return;
      }

      router.go(AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        color: Colors.white,
        child: SafeArea(
          child: Stack(
            children: [
              const Positioned(
                top: -70,
                left: -40,
                child: _OnboardingGlow(size: 180, color: Color(0x11000000)),
              ),
              const Positioned(
                top: 30,
                right: -20,
                child: _OnboardingGlow(size: 110, color: Color(0x0F000000)),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'BiteRush',
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.4,
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            final router = GoRouter.of(context);
                            await context
                                .read<AppStartupProvider>()
                                .markOnboardingComplete();
                            if (!mounted) {
                              return;
                            }

                            router.go(AppRoutes.login);
                          },
                          child: const Text(
                            'Skip',
                            style: TextStyle(color: AppColors.primary),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: _items.length,
                        onPageChanged: (page) {
                          context.read<OnboardingProvider>().setPage(page);
                        },
                        itemBuilder: (context, index) {
                          final item = _items[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Column(
                              children: [
                                const Spacer(),
                                Expanded(
                                  flex: 5,
                                  child: Center(
                                    child: Hero(
                                      tag: item.assetPath,
                                      child: Image.asset(
                                        item.assetPath,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.fromLTRB(
                                    22,
                                    26,
                                    22,
                                    24,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF7F7F7),
                                    borderRadius: BorderRadius.circular(32),
                                    border: Border.all(color: Colors.black12),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Color(0x11000000),
                                        blurRadius: 20,
                                        offset: Offset(0, 8),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: 58,
                                        height: 6,
                                        decoration: BoxDecoration(
                                          // ignore: deprecated_member_use
                                          color: item.accent.withOpacity(0.95),
                                          borderRadius: BorderRadius.circular(
                                            999,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 18),
                                      Text(
                                        item.title,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          color: Colors.black87,
                                          fontSize: 30,
                                          fontWeight: FontWeight.w800,
                                          height: 1.1,
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        item.subtitle,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.black54,
                                          fontSize: 15,
                                          height: 1.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 18),
                                Consumer<OnboardingProvider>(
                                  builder: (context, onboardingProvider, _) {
                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: List.generate(_items.length, (
                                        dotIndex,
                                      ) {
                                        final isActive =
                                            dotIndex ==
                                            onboardingProvider.currentPage;
                                        return AnimatedContainer(
                                          duration: const Duration(
                                            milliseconds: 240,
                                          ),
                                          margin: const EdgeInsets.symmetric(
                                            horizontal: 5,
                                          ),
                                          width: isActive ? 22 : 8,
                                          height: 8,
                                          decoration: BoxDecoration(
                                            color: isActive
                                                ? AppColors.primary
                                                : Colors.black26,
                                            borderRadius: BorderRadius.circular(
                                              999,
                                            ),
                                          ),
                                        );
                                      }),
                                    );
                                  },
                                ),
                                const SizedBox(height: 18),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primary,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 16,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(18),
                                      ),
                                    ),
                                    onPressed: _goToNextPage,
                                    child: Consumer<OnboardingProvider>(
                                      builder:
                                          (context, onboardingProvider, _) {
                                            return Text(
                                              onboardingProvider.currentPage ==
                                                      _items.length - 1
                                                  ? 'Get Started'
                                                  : 'Next',
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            );
                                          },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OnboardingItem {
  const _OnboardingItem({
    required this.title,
    required this.subtitle,
    required this.assetPath,
    required this.accent,
  });

  final String title;
  final String subtitle;
  final String assetPath;
  final Color accent;
}

class _OnboardingGlow extends StatelessWidget {
  const _OnboardingGlow({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}
