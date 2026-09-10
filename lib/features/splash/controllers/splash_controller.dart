import 'package:flutter/material.dart';
import 'package:newst/features/auth/data/auth_service.dart';
import '../../../core/storage/app_preferences.dart';

class SplashController extends ChangeNotifier {
  final AuthService _authService = AuthService();

  Future<bool> hasSeenOnboarding() {
    return AppPreferences.instance.hasSeenOnboarding;
  }

  bool get isLoggedIn {
    return _authService.currentSession != null;
  }
}
