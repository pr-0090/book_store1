import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../view_model/onboarding_view_model.dart';
import '../widgets/onboarding_slide.dart';
import '../../../auth/presentation/view/login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late OnboardingViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = OnboardingViewModel();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (!_viewModel.isLastPage) {
      _viewModel.nextPage();
    } else {
      _navigateToLogin();
    }
  }

  void _navigateToLogin() async {
    await _viewModel.completeOnboarding();
    
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: Consumer<OnboardingViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            body: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF667eea), // Cool blue
                    Color(0xFF764ba2), // Purple
                    Color(0xFFf093fb), // Soft pink
                  ],
                  stops: [0.0, 0.5, 1.0],
                ),
              ),
              child: SafeArea(
                child: Column(
                  children: [
                    // Skip Button
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: EdgeInsets.all(16.w),
                        child: TextButton(
                          onPressed: _navigateToLogin,
                          child: Text(
                            'Skip',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                    
                    // Page View
                    Expanded(
                      child: PageView.builder(
                        controller: viewModel.pageController,
                        onPageChanged: (index) {
                          viewModel.setCurrentPage(index);
                        },
                        itemCount: viewModel.slides.length,
                        itemBuilder: (context, index) {
                          return OnboardingSlide(data: viewModel.slides[index]);
                        },
                      ),
                    ),
                  
                    // Dots Indicator
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 20.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          viewModel.slides.length,
                          (index) => AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: EdgeInsets.symmetric(horizontal: 4.w),
                            height: 8.h,
                            width: viewModel.currentPage == index ? 24.w : 8.w,
                            decoration: BoxDecoration(
                              color: viewModel.currentPage == index 
                                  ? Colors.white 
                                  : Colors.white.withOpacity(0.4),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ),
                    ),
                  
                    // Next/Get Started Button
                    Padding(
                      padding: EdgeInsets.all(24.w),
                      child: Row(
                        children: [
                          // Previous Button (only show if not on first page)
                          if (viewModel.currentPage > 0)
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () {
                                  viewModel.previousPage();
                                },
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  side: const BorderSide(color: Colors.white, width: 1),
                                  padding: EdgeInsets.symmetric(vertical: 16.h),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Text(
                                  'Previous',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          
                          if (viewModel.currentPage > 0) SizedBox(width: 16.w),
                          
                          // Next/Get Started Button
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _nextPage,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: AppTheme.primaryColor,
                                padding: EdgeInsets.symmetric(vertical: 16.h),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 3,
                              ),
                              child: Text(
                                viewModel.isLastPage ? 'Get Started' : 'Next',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

 