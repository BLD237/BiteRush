import 'package:flutter/material.dart';

class LoginProvider extends ChangeNotifier {
  bool _obscurePassword = true;
  bool _rememberMe = true;
  bool _isSubmitting = false;

  bool get obscurePassword => _obscurePassword;

  bool get rememberMe => _rememberMe;

  bool get isSubmitting => _isSubmitting;

  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  void toggleRememberMe(bool? value) {
    _rememberMe = value ?? false;
    notifyListeners();
  }

  void setSubmitting(bool value) {
    if (_isSubmitting == value) {
      return;
    }

    _isSubmitting = value;
    notifyListeners();
  }
}
