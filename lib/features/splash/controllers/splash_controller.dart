import 'package:flutter/material.dart';
import '../../../core/storage/app_preferences.dart';

class SplashController extends ChangeNotifier {
  Future<bool> hasSeenOnboarding() {
    return AppPreferences.instance.hasSeenOnboarding;
  }

  Future<bool> isLoggedIn() {
    return AppPreferences.instance.isLoggedIn;
  }
}
