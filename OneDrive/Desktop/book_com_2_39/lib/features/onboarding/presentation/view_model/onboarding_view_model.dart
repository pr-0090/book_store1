import 'package:flutter/material.dart';
import '../../../../app/shared_prefs/shared_prefs_service.dart';

class OnboardingSlideData {
  final String title;
  final String subtitle;
  final String imageUrl;
  final IconData icon;

  OnboardingSlideData({
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.icon,
  });
}

class OnboardingViewModel extends ChangeNotifier {
  final PageController pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingSlideData> slides = [
    OnboardingSlideData(
      title: 'Discover Amazing Books',
      subtitle: 'Explore thousands of books from various genres and authors',
      imageUrl: 'assets/images/w-1.png',
      icon: Icons.auto_stories,
    ),
    OnboardingSlideData(
      title: 'Find Your Perfect Read',
      subtitle: 'Search, filter, and discover books that match your interests',
      imageUrl: 'assets/images/w-2.png',
      icon: Icons.search,
    ),
    OnboardingSlideData(
      title: 'Easy Shopping Experience',
      subtitle: 'Add to cart, checkout securely, and get your books delivered',
      imageUrl: 'assets/images/w-3.jpg',
      icon: Icons.shopping_cart,
    ),
  ];

  // Getters
  int get currentPage => _currentPage;
  int get totalPages => slides.length;
  bool get isLastPage => _currentPage == slides.length - 1;

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void setCurrentPage(int page) {
    _currentPage = page;
    notifyListeners();
  }

  void nextPage() {
    if (_currentPage < slides.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void previousPage() {
    if (_currentPage > 0) {
      pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void goToPage(int page) {
    pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Future<void> completeOnboarding() async {
    // Mark onboarding as completed
    await SharedPrefsService.setOnboardingCompleted(true);
    
    // Set first launch date if not already set
    if (SharedPrefsService.getFirstLaunchDate() == null) {
      await SharedPrefsService.setFirstLaunchDate(DateTime.now().toIso8601String());
    }
  }

  OnboardingSlideData getCurrentSlide() {
    return slides[_currentPage];
  }

  double getProgress() {
    return (_currentPage + 1) / slides.length;
  }
} 