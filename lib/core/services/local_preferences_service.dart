import 'package:shared_preferences/shared_preferences.dart';

class LocalPreferencesService {
  static const _hasCompletedOnboardingKey = 'hasCompletedOnboarding';

  Future<bool> hasCompletedOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_hasCompletedOnboardingKey) ?? false;
  }

  Future<void> setHasCompletedOnboarding(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_hasCompletedOnboardingKey, value);
  }
}
