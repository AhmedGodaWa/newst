import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences {
  static const String _hasSeenOnboardingKey = 'hasSeenOnboarding';
  // static const String _isLoggedInKey = 'isLoggedIn';

  AppPreferences._();

  static final AppPreferences instance = AppPreferences._();

  late final SharedPreferencesAsync _preferences;

  Future<void> init() async {
    _preferences = SharedPreferencesAsync();
  }

  Future<void> setHasSeenOnboarding(bool value) async {
    await _preferences.setBool(_hasSeenOnboardingKey, value);
  }

  Future<bool> get hasSeenOnboarding async {
    return await _preferences.getBool(_hasSeenOnboardingKey) ?? false;
  }

  // Future<void> setIsLoggedIn(bool value) async {
  //   await _preferences.setBool(_isLoggedInKey, value);
  // }

  // Future<bool> get isLoggedIn async {
  //   return await _preferences.getBool(_isLoggedInKey) ?? false;
  // }
}
