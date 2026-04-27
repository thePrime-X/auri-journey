import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'local_preferences_service.dart';

final localPreferencesServiceProvider = Provider<LocalPreferencesService>((
  ref,
) {
  return LocalPreferencesService();
});

final hasCompletedOnboardingProvider = FutureProvider<bool>((ref) async {
  final service = ref.read(localPreferencesServiceProvider);
  return service.hasCompletedOnboarding();
});
