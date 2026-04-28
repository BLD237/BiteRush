import 'package:go_router/go_router.dart';
import 'package:food_delivery/features/splash/presentation/pages/splash_screen.dart';
import 'package:food_delivery/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:food_delivery/features/auth/presentation/pages/login_page.dart';
import 'package:food_delivery/features/auth/presentation/pages/signup_page.dart';
import 'package:food_delivery/features/auth/presentation/pages/verify_email_page.dart';
import 'package:food_delivery/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:food_delivery/features/home/presentation/pages/home_page.dart';
import 'package:food_delivery/features/home/presentation/providers/home_provider.dart';
import 'package:food_delivery/features/home/data/repositories/home_repository.dart';
import 'package:food_delivery/features/profile/presentation/pages/profile_page.dart';
import 'package:food_delivery/features/orders/presentation/pages/orders_page.dart';
import 'package:food_delivery/features/favorites/presentation/pages/favorites_page.dart';
import 'package:provider/provider.dart';

class AppRoutes {
  static const splash = '/';
  static const onboarding = '/onboarding';
  static const login = '/login';
  static const signup = '/signup';
  static const verify = '/verify';
  static const forgot = '/forgot';
  static const home = '/home';
  static const profile = '/profile';
  static const orders = '/orders';
  static const favorites = '/favorites';
}

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  routes: <GoRoute>[
    GoRoute(
      name: 'splash',
      path: AppRoutes.splash,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      name: 'onboarding',
      path: AppRoutes.onboarding,
      builder: (context, state) => const OnboardingPage(),
    ),
    GoRoute(
      name: 'login',
      path: AppRoutes.login,
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      name: 'signup',
      path: AppRoutes.signup,
      builder: (context, state) => const SignupPage(),
    ),
    GoRoute(
      name: 'verify',
      path: AppRoutes.verify,
      builder: (context, state) => const VerifyEmailPage(),
    ),
    GoRoute(
      name: 'forgot',
      path: AppRoutes.forgot,
      builder: (context, state) => const ForgotPasswordPage(),
    ),
    GoRoute(
      name: 'home',
      path: AppRoutes.home,
      builder: (context, state) => ChangeNotifierProvider(
        create: (_) =>
            HomeProvider(repository: const HomeRepository())..loadInitialData(),
        child: const HomePage(),
      ),
    ),
    GoRoute(
      name: 'profile',
      path: AppRoutes.profile,
      builder: (context, state) => const ProfilePage(),
    ),
    GoRoute(
      name: 'orders',
      path: AppRoutes.orders,
      builder: (context, state) => const OrdersPage(),
    ),
    GoRoute(
      name: 'favorites',
      path: AppRoutes.favorites,
      builder: (context, state) => const FavoritesPage(),
    ),
  ],
);
