import 'package:flutter/material.dart';
import 'package:food_delivery/core/services/local_storage_service.dart';

enum AppStartDestination {
  onboarding,
  login,
  home,
}

class AppStartupProvider extends ChangeNotifier {
  static const String _firstLaunchKey = 'first_launch_completed';
  static const String _loggedInKey = 'is_logged_in';

  AppStartupProvider({LocalStorageService? localStorageService})
      : _localStorageService = localStorageService;

  final LocalStorageService? _localStorageService;

  LocalStorageService? _storage;
  bool _isLoading = true;
  AppStartDestination? _destination;
  bool _initialized = false;

  bool get isLoading => _isLoading;

  AppStartDestination? get destination => _destination;

  Future<void> initialize() async {
    if (_initialized) {
      return;
    }

    _initialized = true;
    _isLoading = true;
    notifyListeners();

    _storage = _localStorageService ?? await LocalStorageService.create();

    final firstLaunchCompleted = _storage?.getBool(_firstLaunchKey) ?? false;
    final isLoggedIn = _storage?.getBool(_loggedInKey) ?? false;

    if (!firstLaunchCompleted) {
      _destination = AppStartDestination.onboarding;
    } else if (isLoggedIn) {
      _destination = AppStartDestination.home;
    } else {
      _destination = AppStartDestination.login;
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> markOnboardingComplete() async {
    await _ensureStorage();
    await _storage?.setBool(_firstLaunchKey, true);
    _destination = AppStartDestination.login;
    notifyListeners();
  }

  Future<void> setLoggedIn(bool value) async {
    await _ensureStorage();
    await _storage?.setBool(_loggedInKey, value);
    _destination = value ? AppStartDestination.home : AppStartDestination.login;
    notifyListeners();
  }

  Future<void> logout() async {
    await setLoggedIn(false);
  }

  Future<void> _ensureStorage() async {
    _storage ??= _localStorageService ?? await LocalStorageService.create();
  }
}