
import 'package:flutter/material.dart';

class OnboardingProvider extends ChangeNotifier {
  final PageController pageController = PageController();

  int _currentPage = 0;

  int get currentPage => _currentPage;

  bool get isLastPage => _currentPage == 2;

  void onPageChanged(int index) {
    _currentPage = index;
    notifyListeners();
  }

  void nextPage() {
    if (_currentPage < 2) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    }
  }

  void previousPage() {
    if (_currentPage > 0) {
      pageController.previousPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    }
  }

  void completeOnboarding() {
    // Onboarding completion and navigation are handled by the screen.
  }



  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}
