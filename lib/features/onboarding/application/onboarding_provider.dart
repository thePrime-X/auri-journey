import 'package:flutter_riverpod/flutter_riverpod.dart';

class OnboardingNotifier extends Notifier<bool> {
  @override
  bool build() {
    return false; // not completed by default
  }

  void completeOnboarding() {
    state = true;
  }

  void reset() {
    state = false;
  }
}

final onboardingCompletedProvider = NotifierProvider<OnboardingNotifier, bool>(
  OnboardingNotifier.new,
);
