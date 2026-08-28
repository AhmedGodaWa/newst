import 'package:flutter/material.dart';
import 'package:newst/features/onboarding/models/onboarding_model.dart';

class OnboardingController extends ChangeNotifier {
  int currentIndex = 0;

  bool get isLastPage =>
    currentIndex == OnboardingModel.onboardingData.length - 1;

  void changePage(int index) {
    currentIndex = index;
    notifyListeners();
  }
}
