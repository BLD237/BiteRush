import 'dart:async';

import 'package:flutter/material.dart';
import 'package:food_delivery/core/constants/app_assets.dart';
import 'package:food_delivery/core/constants/app_colors.dart';
import 'package:food_delivery/core/providers/app_startup_provider.dart';
import 'package:food_delivery/features/auth/presentation/pages/login_page.dart';
import 'package:food_delivery/features/home/presentation/pages/home_page.dart';
import 'package:food_delivery/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _firstBurgerDrop;
  late final Animation<double> _secondBurgerDrop;
  static const String _subtitleText = 'Amazing Bites';

  Timer? _subtitleTimer;
  int _subtitleVisibleCharacters = 0;
  bool _animationCompleted = false;
  bool _didNavigate = false;
  AppStartupProvider? _startupProvider;
  bool _startupListenerAttached = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..forward();

    _firstBurgerDrop = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.0,
          end: 1.08,
        ).chain(CurveTween(curve: Curves.easeOutCubic)),
        weight: 82,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.08,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeOutQuad)),
        weight: 18,
      ),
    ]).animate(_controller);

    _secondBurgerDrop = TweenSequence<double>([
      TweenSequenceItem(tween: ConstantTween<double>(0.0), weight: 46),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.0,
          end: 1.05,
        ).chain(CurveTween(curve: Curves.easeOutCubic)),
        weight: 44,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.05,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeOutQuad)),
        weight: 10,
      ),
    ]).animate(_controller);

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationCompleted = true;
        _startSubtitleTyping();
        _maybeNavigate();
      }
    });
  }

  @override
  void dispose() {
    _subtitleTimer?.cancel();
    _startupProvider?.removeListener(_onStartupChanged);
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_startupListenerAttached) {
      return;
    }

    _startupProvider = context.read<AppStartupProvider>();
    _startupProvider?.addListener(_onStartupChanged);
    _startupListenerAttached = true;
  }

  void _startSubtitleTyping() {
    if (!mounted || _subtitleTimer != null) {
      return;
    }

    _subtitleVisibleCharacters = 0;
    _subtitleTimer = Timer.periodic(const Duration(milliseconds: 70), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      if (_subtitleVisibleCharacters >= _subtitleText.length) {
        timer.cancel();
        _subtitleTimer = null;
        return;
      }

      setState(() {
        _subtitleVisibleCharacters++;
      });
    });
  }

  void _onStartupChanged() {
    _maybeNavigate();
  }

  void _maybeNavigate() {
    if (!mounted || _didNavigate) {
      return;
    }

    final startup = context.read<AppStartupProvider>();
    if (!_animationCompleted ||
        startup.isLoading ||
        startup.destination == null) {
      return;
    }

    _didNavigate = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }

      final destination = startup.destination;
      final Widget nextPage;

      switch (destination) {
        case AppStartDestination.onboarding:
          nextPage = const OnboardingPage();
        case AppStartDestination.login:
          nextPage = const LoginPage();
        case AppStartDestination.home:
          nextPage = const HomePage();
        case null:
          return;
      }

      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute<void>(builder: (_) => nextPage));
    });
  }

  Widget _dropBurger({
    required Animation<double> animation,
    required Widget child,
    required double startOffsetY,
  }) {
    return AnimatedBuilder(
      animation: animation,
      child: child,
      builder: (context, animatedChild) {
        final dropProgress = animation.value;
        final offsetY = startOffsetY * (1 - dropProgress);
        final scale = 0.84 + (0.16 * dropProgress);

        return Transform.translate(
          offset: Offset(0, offsetY),
          child: Transform.scale(
            scale: scale,
            alignment: Alignment.bottomLeft,
            child: animatedChild,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.splashTop, AppColors.splashBottom],
          ),
        ),
        child: Stack(
          children: [
            const Positioned(
              top: -70,
              left: -40,
              child: _SoftGlow(size: 190, color: Color(0x22FFFFFF)),
            ),
            const Positioned(
              top: 0,
              right: -30,
              child: _SoftGlow(size: 120, color: Color(0x18FFFFFF)),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Align(
                  alignment: const Alignment(0, -0.18),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'BiteRush',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.splashText,
                          fontSize: 54,
                          height: 1,
                          fontWeight: FontWeight.w700,
                          fontStyle: FontStyle.italic,
                          letterSpacing: 0.2,
                          shadows: const [
                            Shadow(
                              color: Color(0x33000000),
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _subtitleText.substring(0, _subtitleVisibleCharacters),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          // ignore: deprecated_member_use
                          color: AppColors.splashText.withOpacity(0.96),
                          fontSize: 18,
                          height: 1,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.7,
                          shadows: const [
                            Shadow(
                              color: Color(0x22000000),
                              blurRadius: 8,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Burger cluster placed at outer stack level so it can be flush-left
            Positioned(
              left: -60,
              bottom: -16,
              child: SafeArea(
                left: false,
                top: false,
                right: false,
                bottom: false,
                child: SizedBox(
                  width: 420,
                  height: 260,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Positioned(
                        left: 0,
                        bottom: 0,
                        child: _dropBurger(
                          animation: _firstBurgerDrop,
                          startOffsetY: 182,
                          child: Image.asset(
                            AppAssets.burgerTwo,
                            width: 260,
                            height: 260,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      Positioned(
                        left: 142,
                        bottom: 0,
                        child: _dropBurger(
                          animation: _secondBurgerDrop,
                          startOffsetY: 196,
                          child: Image.asset(
                            AppAssets.burgerOne,
                            width: 200,
                            height: 200,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SoftGlow extends StatelessWidget {
  const _SoftGlow({required this.size, required this.color});

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
